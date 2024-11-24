import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:alaremmu/ui/screen/splash_screen/splash_screen.dart';
import 'package:intl/date_symbol_data_local.dart'; // Tambahkan ini untuk inisialisasi tanggal lokal

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: 'https://lkezyphtpcgkxrfqbrni.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxrZXp5cGh0cGNna3hyZnFicm5pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE3ODA2OTEsImV4cCI6MjA0NzM1NjY5MX0.k7GhRDy_ciEXrs0qz5FCsubkc4VLNsjcU8LaGrXIyOU',
  );

  // Inisialisasi format tanggal lokal
  await initializeDateFormatting('id_ID', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
