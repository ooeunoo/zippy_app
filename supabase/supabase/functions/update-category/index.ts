// deno-lint-ignore-file no-explicit-any no-empty-interface
import { supabaseClient } from "../shared/supabase-client.ts";
import {
  DOMParser,
  Element,
  HTMLDocument,
  Node,
  NodeList,
} from "https://deno.land/x/deno_dom/deno-dom-wasm.ts";

interface HTMLElement extends Element {}

Deno.serve(async (req) => {
  const { data: communities, error: communityCallError } = await supabaseClient
    .from("community")
    .select("*");

  // TODO: error

  for await (const {
    id: communityId,
    name: communityName,
    list_view_url: listViewUrl,
  } of communities!) {
    const { data: categories, error: categoryCallError } = await supabaseClient
      .from("category")
      .select("*")
      .eq("community_id", communityId)
      .eq("status", true);

    // TODO: error
    for await (const category of categories!) {
      const { id: categoryId, path } = category;
      await parser(communityName, listViewUrl, categoryId, path);
    }
  }

  return new Response(JSON.stringify({ success: true }), {
    headers: { "Content-Type": "application/json" },
  });
});

async function parser(
  communityName: string,
  listViewUrl: string,
  categoryId: string,
  categoryPath: string
) {
  const response = await fetch(
    new Request(listViewUrl.replace("{category}", categoryPath), {
      method: "Get",
    })
  );

  const html = await response.text();
  const document: HTMLDocument = new DOMParser().parseFromString(
    html,
    "text/html"
  )!;

  try {
    let max: number = 0;
    switch (communityName) {
      case "dcinside": {
        const table = document.querySelector("tbody.listwrap2")!;
        const rows: NodeList = table.querySelectorAll("tr");
        rows.forEach((row: Node) => {
          const rowElement = row as HTMLElement;
          const num = rowElement.getAttribute("data-no");
          if (num == undefined || !isNumeric(num)) return;
          max = Math.max(max, parseInt(num));
        });
        break;
      }
      case "bbombbu": {
        const rows = document.querySelectorAll(
          "td.baseList-space.baseList-numb"
        );
        rows.forEach((row: Node) => {
          const num = row.textContent;
          if (!isNumeric(num)) return;
          max = Math.max(max, parseInt(num));
        });
        break;
      }
      case "instiz": {
        const rows = document.querySelectorAll("td.listno.regdate");
        rows.forEach((row: Node) => {
          const num = (row as Element).getAttribute("no") ?? "";
          if (!isNumeric(num)) return;
          max = Math.max(max, parseInt(num));
        });
        break;
      }
    }
    if (isNumeric(max.toString())) {
      await supabaseClient
        .from("category")
        .update({ latest_index: max })
        .eq("id", categoryId);
    }
  } catch (e) {
    // TODO: error
    console.log(e);
  }
}

function isNumeric(data?: string): boolean {
  try {
    return !isNaN(Number(data));
  } catch (e) {
    return false;
  }
}
