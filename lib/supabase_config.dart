import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // Inicializa Supabase
  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://oootpwyyhakzpkbmmwbf.supabase.co',
      anonKey: 'sb_publishable_u5dbt2QMgv28v-RPKZLJ5Q_Dxr-GZ4f',
    );
  }

  // Atajo para acceder al cliente
  static SupabaseClient get client => Supabase.instance.client;
}
