import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'login_page.dart';
import 'home_page.dart';
import 'user_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  // LOGIC: Cek Session User
  Future<void> _checkSession() async {
    // 1. Tunggu 2 detik untuk estetika logo
    await Future.delayed(const Duration(seconds: 2));

    // 2. Cek penyimpanan HP
    final prefs = await SharedPreferences.getInstance();
    
    // Kita cek key 'current_user' (Logic ini perlu kamu tambahkan saat Login nanti)
    String? savedUserString = prefs.getString('current_user');

    if (!mounted) return;

    if (savedUserString != null) {
      // --- SKENARIO 1: USER SUDAH LOGIN ---
      try {
        // Kembalikan data user ke Memory (UserManager)
        Map<String, dynamic> userMap = jsonDecode(savedUserString);
        await UserManager.setCurrentUserFromMap(userMap);

        // Langsung ke Home Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } catch (e) {
        // Jika data rusak, paksa login ulang
        _goToLogin();
      }
    } else {
      // --- SKENARIO 2: BELUM LOGIN / LOGOUT ---
      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEE4D2D), // Oranye Shopee
      body: Stack(
        children: [
          // LOGO TENGAH
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shopping_bag_outlined,
                  size: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                const Text(
                  "SHOOPEDIA",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 30),
                const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                )
              ],
            ),
          ),
          
          // VERSI APLIKASI (DI BAWAH)
          const Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Versi 1.0.0",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          )
        ],
      ),
    );
  }
}
