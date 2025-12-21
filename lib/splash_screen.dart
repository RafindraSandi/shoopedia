import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'home_page.dart';

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

  // Cek apakah user sudah pernah login sebelumnya
  Future<void> _checkSession() async {
    // Tunggu 2 detik biar logo tampil
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    // Anggaplah kalau ada data 'all_users', kita cek session (opsional)
    // Di sini kita sederhana saja: Langsung ke Login Page
    // Kalau mau canggih, bisa cek token login di sini.
    
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEE4D2D), // Warna Oranye Shopee
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ganti Icon ini dengan Gambar Logo kamu jika ada
            const Icon(
              Icons.shopping_bag, 
              size: 100, 
              color: Colors.white
            ),
            const SizedBox(height: 20),
            const Text(
              "SHOOPEDIA",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            const CircularProgressIndicator(
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
