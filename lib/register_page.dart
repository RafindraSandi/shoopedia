import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // PENTING: Untuk mengelola daftar data (JSON)
import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;
  bool _isButtonActive = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateButtonState);
    _phoneController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      _isButtonActive = _nameController.text.isNotEmpty && 
                        _phoneController.text.isNotEmpty && 
                        _passwordController.text.isNotEmpty;
    });
  }

  // FUNGSI BARU: MENYIMPAN BANYAK AKUN (TIDAK DITIMPA)
  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // 1. Ambil data lama dulu (jika ada)
    String? existingUsersString = prefs.getString('all_users');
    List<dynamic> userList = [];

    if (existingUsersString != null) {
      // Kalau sudah ada data sebelumnya, kita ubah jadi List agar bisa ditambah
      userList = jsonDecode(existingUsersString);
    }

    // 2. Siapkan data user baru
    Map<String, String> newUser = {
      "name": _nameController.text,
      "email": _phoneController.text, // Kita anggap no hp/email sebagai ID
      "password": _passwordController.text,
    };

    // 3. Masukkan user baru ke dalam List (Tumpuk data)
    userList.add(newUser);

    // 4. Simpan kembali List tersebut ke HP dalam bentuk Teks JSON
    await prefs.setString('all_users', jsonEncode(userList));

    print("Data Tersimpan! Total akun di HP: ${userList.length}");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color mainColor = Color(0xFFEE4D2D);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: mainColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Daftar", style: TextStyle(color: Colors.black, fontSize: 20)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Icon(Icons.shopping_bag, size: 60, color: mainColor),
              const SizedBox(height: 30),
              
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Nama Lengkap",
                  prefixIcon: const Icon(Icons.person_outline),
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: mainColor)),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  hintText: "No. Handphone/Email",
                  prefixIcon: const Icon(Icons.phone_android_outlined),
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: mainColor)),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _passwordController,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _isObscure = !_isObscure),
                  ),
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: mainColor)),
                ),
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isButtonActive ? mainColor : Colors.grey[300],
                    elevation: 0,
                  ),
                  onPressed: _isButtonActive ? () async {
                    // PANGGIL FUNGSI SIMPAN BARU
                    await _saveUserData();

                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Akun berhasil dibuat! Silakan Login.")),
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  } : null,
                  child: Text(
                    "Daftar", 
                    style: TextStyle(
                      color: _isButtonActive ? Colors.white : Colors.grey[600], 
                      fontSize: 16
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
