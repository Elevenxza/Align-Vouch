import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_page.dart'; // Pastikan path ini benar

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase dengan API Key yang sudah lu kasih
  await Supabase.initialize(
    url: 'https://rtubkysqixsdgyorzeub.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ0dWJreXNxaXhzZGd5b3J6ZXViIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODM0NTMxNDEsImV4cCI6MjA5OTAyOTE0MX0.JMjcGXuh6qtbrqie1csSx2XV-SuN6SLEoXvv1cgNnHQ',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Align Vouch',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}