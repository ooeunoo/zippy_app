// ignore_for_file: non_constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

class ENV {
  ENV._();

  static String SUPABASE_URL = dotenv.env['SUPABASE_URL']!;
  static String SUPABASE_ANON_KEY = dotenv.env['SUPABASE_ANON_KEY']!;
}
