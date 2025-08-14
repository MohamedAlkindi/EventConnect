import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> initSupabase() async {
  await Supabase.initialize(
      url: 'https://mretvbuvvmcbjdivlogc.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1yZXR2YnV2dm1jYmpkaXZsb2djIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA0NTM0MzgsImV4cCI6MjA2NjAyOTQzOH0.xPz552lN_TfgO1RX7CjHYheRJ04nmio0WV_Z6Yw-7Fw');
}
