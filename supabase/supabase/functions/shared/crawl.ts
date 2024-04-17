import {
  DOMParser,
  HTMLDocument,
} from "https://deno.land/x/deno_dom/deno-dom-wasm.ts";
export const getDocument = async (url: string): Promise<HTMLDocument> => {
  const request = new Request(url, {
    method: "GET",
  });

  const response = await fetch(request);
  const html = await response.text();
  const doc: HTMLDocument = new DOMParser().parseFromString(html, "text/html")!;
  const title = doc.title;
  var uint8array = new TextEncoder().encode(title);
  var string = new TextDecoder().decode(uint8array);
  console.log(uint8array, string);

  return doc;
};
