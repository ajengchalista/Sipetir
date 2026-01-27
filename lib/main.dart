import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://lpexaemcxjlfgdayvxyx.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxwZXhhZW1jeGpsZmdkYXl2eHl4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg2ODI5MDAsImV4cCI6MjA4NDI1ODkwMH0.nAJhj65Q4S25TtmaKFofrq-CVe5_eCU5X_jzGZ0fqCA',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
