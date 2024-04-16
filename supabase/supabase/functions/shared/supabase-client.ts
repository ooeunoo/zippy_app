import { createClient } from "https://esm.sh/@supabase/supabase-js@^2.42.4";

export const supabaseClient = createClient(
  // Supabase API URL - env var exported by default when deployed.
  // Deno.env.get("SUPABASE_URL") ??
  "https://xeqbiornocpbqweghyba.supabase.co",
  // Supabase API ANON KEY - env var exported by default when deployed.
  // Deno.env.get("SUPABASE_ANON_KEY") ??
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhlcWJpb3Jub2NwYnF3ZWdoeWJhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTMyNTI3MDcsImV4cCI6MjAyODgyODcwN30.PDdIdriOUqT9gn-WIxbJznmZIS5shyXTkovyhjtwDxo"
);
