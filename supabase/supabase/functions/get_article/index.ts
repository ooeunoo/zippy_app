import { supabaseClient } from "../shared/supabase-client.ts";
import {
  DOMParser,
  Element,
  HTMLDocument,
  Node,
  NodeList,
} from "https://deno.land/x/deno_dom/deno-dom-wasm.ts";

Deno.serve(async (req) => {
  const { community, url } = await req.json();

  const response = await fetch(new Request(url), { method: "Get" });

  const html = await response.text();
  const document: HTMLDocument = new DOMParser().parseFromString(
    html,
    "text/html"
  )!;

  const content = document.querySelector("div.writing_view_box");
  console.log(content?.outerHTML);

  return new Response(JSON.stringify(content?.outerHTML), {
    headers: { "Content-Type": "application/json" },
  });
});
