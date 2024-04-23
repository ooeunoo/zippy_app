import { supabaseClient } from "./supabase-client.ts";

export const updateCategoryLatestItemIndex = async (
  categoryId: number,
  index: string
) => {
  await supabaseClient
    .from("category")
    .update({ latest_item_index: index })
    .eq("id", categoryId);
};

export const getSavedCategoryMaxItemIndex = async (categoryId: number) => {
  const { data } = await supabaseClient
    .from("item")
    .select()
    .eq("category_id", categoryId)
    .order("item_index", { ascending: false })
    .limit(1)
    .single();
  return data;
};

export const getChannel = async (name: string) => {
  const { data } = await supabaseClient
    .from("channel")
    .select("*")
    .eq("name", name)
    .single();
  return data;
};

export const getCategories = async (channelId: number) => {
  const { data } = await supabaseClient
    .from("category")
    .select("*")
    .eq("channel_id", channelId);
  return data;
};
