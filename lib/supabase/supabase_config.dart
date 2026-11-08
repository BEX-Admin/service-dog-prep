import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

const String supabaseUrl = 'https://nacbocdblmvpbvtinuzj.supabase.co';
const String supabaseAnonKey = 'sb_publishable_H21Z3H8ZvcpF8s-3VkL2Hg_VX7GVKie';

Future<void> initializeSupabase() async {
  try {
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabaseAnonKey,
    );
    debugPrint('Supabase initialized');
  } catch (e) {
    debugPrint('Supabase init failed (running in demo mode): $e');
  }
}

SupabaseClient get supabase => Supabase.instance.client;
