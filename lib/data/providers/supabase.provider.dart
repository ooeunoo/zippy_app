import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zippy/app/utils/env.dart';

class SupabaseProvider {
  SupabaseClient get _client => Supabase.instance.client;
  SupabaseClient get client => _client;

  static init() async {
    print(ENV.SUPABASE_URL);
    print(ENV.SUPABASE_ANON_KEY);
    await Supabase.initialize(
      url: ENV.SUPABASE_URL,
      anonKey: ENV.SUPABASE_ANON_KEY,
    );
  }
}
