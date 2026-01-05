import 'package:flutter/material.dart';
import 'splash_screen.dart'; // Hanya perlu import ini
import 'user_manager.dart'; // Import UserManager

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load user data from shared preferences
  await UserManager.loadUserData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shoopedia',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFEE4D2D)),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // Membuka Login sebagai halaman pertama
    );
  }
}
