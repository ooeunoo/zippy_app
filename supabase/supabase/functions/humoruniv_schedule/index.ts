import {
  CANNOT_FIND_A_TAG,
  NOT_FOUND_CATEGORY,
  NOT_FOUND_COMMUNITY,
} from "../shared/error-message.ts";
import { getDocument } from "../shared/crawl.ts";
import {
  getSavedCategoryMaxItemIndex,
  updateCategoryLatestItemIndex,
} from "../shared/query.ts";
import { supabaseClient } from "../shared/supabase-client.ts";
import {
  DOMParser,
  Element,
  HTMLDocument,
  Node,
  NodeList,
} from "https://deno.land/x/deno_dom/deno-dom-wasm.ts";
import { CANNOT_PARSE_LATEST_INDEX } from "../shared/error-message.ts";
import { getCategories } from "../shared/query.ts";
import { getCommunity } from "../shared/query.ts";
import { isNumeric } from "../shared/type.ts";
import { sleep, reSizeStartEnd } from "../shared/utils.ts";
import { DEFAULT_START_AGO } from "../shared/costant.ts";

const NAME = "humoruniv";

Deno.serve(async (req) => {
  // https://web.humoruniv.com/board/humor/read.html?table=pick&number=1301874

  const community = await getCommunity(NAME);
  if (community == null) {
    throw new Error(NOT_FOUND_COMMUNITY);
  }

  const categories = await getCategories(community.id);
  if (categories == undefined || categories.length == 0) {
    throw new Error(NOT_FOUND_CATEGORY);
  }

  await update(community, categories);

  return new Response(JSON.stringify({}), {
    headers: { "Content-Type": "application/json" },
  });
});

const update = async (community: any, categories: any) => {
  for await (const category of categories) {
    const url = community.list_view_url.replace("{category}", category.path);
    const document = await getDocument(url);
    // console.log(document);

    // const table = document.querySelector("table#post_list");
    // const tr = table?.querySelector("tr");
    // const anchorTag = tr!.querySelector("a");

    // let latestItemIndex = 0;
    // if (anchorTag) {
    //   const href = anchorTag.getAttribute("href");
    //   const match = href!.match(/number=(\d+)/);

    //   if (match) {
    //     const numberValue = match[1];
    //     if (isNumeric(numberValue)) {
    //       latestItemIndex = parseInt(numberValue);
    //     }
    //     await updateCategoryLatestItemIndex(category.id, numberValue);
    //   } else {
    //     throw new Error(CANNOT_PARSE_LATEST_INDEX);
    //   }
    // } else {
    //   throw new Error(CANNOT_FIND_A_TAG);
    // }

    // const savedMaxItemIndex = await getSavedCategoryMaxItemIndex(category.id);

    // const { start, end } = reSizeStartEnd(savedMaxItemIndex, latestItemIndex);

    // for (let i = start; i <= end; i++) {
    //   const url = community.item_view_url
    //     .replace("{category}", category.path)
    //     .replace("{index}", i);

    //   const document = await getDocument(url);
    //   console.log(document.documentElement!.innerHTML);

    //   const title = document.querySelector("span#ai_cm_title")?.textContent;
    //   const nickname = document.querySelector("span.hu_nick_txt")?.textContent;
    //   const createdAt = document
    //     .querySelector("div#content_info span:nth-of-type(6)")
    //     ?.textContent.trim();

    //   console.log("################");
    //   console.log(url);
    //   console.log(title);
    //   console.log(nickname);
    //   console.log(createdAt);
    //   console.log("################");

    //   await sleep(1000);
    // }
  }
};
