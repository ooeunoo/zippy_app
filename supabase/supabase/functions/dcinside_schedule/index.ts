import { remote } from "npm:webdriverio@8.36.0";
import {
  DOMParser,
  Element,
  HTMLDocument,
  Node,
  NodeList,
} from "https://deno.land/x/deno_dom/deno-dom-wasm.ts";

Deno.serve(async (req) => {
  const browser = await remote({
    capabilities: { browserName: "chrome" },
  });

  await browser.navigateTo("https://www.google.com/ncr");

  const searchInput = await browser.$("#lst-ib");
  await searchInput.setValue("WebdriverIO");

  const searchBtn = await browser.$('input[value="Google Search"]');
  await searchBtn.click();

  console.log(await browser.getTitle()); // outputs "WebdriverIO - Google Search"

  await browser.deleteSession();

  return new Response(JSON.stringify({}), {
    headers: { "Content-Type": "application/json" },
  });
});
