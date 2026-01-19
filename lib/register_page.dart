import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;
  bool _isButtonActive = false;
  bool _isLoading = false; // TAMBAHAN: State untuk loading

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_updateButtonState);
    _nameController.addListener(_updateButtonState);
    _emailController.addListener(_updateButtonState);
    _phoneController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      _isButtonActive = _usernameController.text.isNotEmpty &&
          _nameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _phoneController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

// FUNGSI: PROSES REGISTER
  Future<void> _handleRegister() async {
    // 1. Validasi Input Dasar
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String phone = _phoneController.text.trim();
    String fullName = _nameController.text.trim();

    if (!email.contains('@')) {
      _showSnackBar("Format email tidak valid!", Colors.red);
      return;
    }
    if (password.length < 6) {
      _showSnackBar("Password minimal 6 karakter!", Colors.red);
      return;
    }

    setState(() {
      _isLoading = true; // Mulai loading
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      String? existingUsersString = prefs.getString('all_users');
      List<dynamic> userList = [];

      if (existingUsersString != null) {
        try {
          userList = jsonDecode(existingUsersString);
        } catch (e) {
          debugPrint("Error decode JSON: $e");
          userList = []; // Reset jika data rusak
        }
      }

// 2. CEK DUPLIKASI
      // Cek apakah username atau email sudah ada di database
      bool isDuplicate = userList.any((user) =>
          user['username'] == username || user['email'] == email);

      if (isDuplicate) {
        if (!mounted) return;
        _showSnackBar("Username atau Email sudah terdaftar!", Colors.orange);
        setState(() => _isLoading = false);
        return; // Stop proses
      }

// 3. SIMPAN DATA BARU
      // Gunakan Map<String, dynamic> agar bisa simpan boolean & angka
      Map<String, dynamic> newUser = {
        "username": username,
        "fullName": fullName,
        "email": email,
        "phone": phone,
        "password": password,
        "bio": "Pengguna baru Shoopedia",
        
        // Field tambahan untuk masa depan (Toko & Saldo)
        "isSeller": false,  // Default: Bukan penjual
        "balance": 0,       // Default: Saldo 0
        "role": "user",     // Default role
        "createdAt": DateTime.now().toIso8601String(),
      };

      // Masukkan user baru ke list
      userList.add(newUser);

      // Simpan list yang sudah diupdate ke penyimpanan HP
      await prefs.setString('all_users', jsonEncode(userList));

      // Simulasi delay biar berasa prosesnya
      await Future.delayed(const Duration(milliseconds: 1000));

      if (!mounted) return;
      // 4. SUKSES
    _showSnackBar("Akun berhasil dibuat! Silakan Login.", Colors.green);

      // Pindah ke halaman Login (Replacement agar tidak bisa back ke register)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );

    } catch (e) {
      if (!mounted) return;
      _showSnackBar("Gagal mendaftar: $e", Colors.red);
    } finally {
      // Pastikan loading berhenti apapun yang terjadi
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
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
        title: const Text("Daftar",
            style: TextStyle(color: Colors.black, fontSize: 20)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Icon(Icons.shopping_bag, size: 60, color: mainColor),
              const SizedBox(height: 30),
              
              // --- FORM INPUT ---
              // Username
              TextField(
                controller: _usernameController,
                textInputAction: TextInputAction.next, // Biar ada tombol next di keyboard
                decoration: const InputDecoration(
                  hintText: "Username",
                  prefixIcon: Icon(Icons.person),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: mainColor)),
                ),
              ),
              const SizedBox(height: 20),
              
              // Nama Lengkap
              TextField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: "Nama Lengkap",
                  prefixIcon: Icon(Icons.badge_outlined),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: mainColor)),
                ),
              ),
              const SizedBox(height: 20),
              
              // Email
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: "Email",
                  prefixIcon: Icon(Icons.email_outlined),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: mainColor)),
                ),
              ),
              const SizedBox(height: 20),
              
              // No Handphone
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: "No. Handphone",
                  prefixIcon: Icon(Icons.phone_android),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: mainColor)),
                ),
              ),
              const SizedBox(height: 20),
              
              // Password
              TextField(
                controller: _passwordController,
                obscureText: _isObscure,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _isButtonActive ? _handleRegister() : null,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _isObscure = !_isObscure),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: mainColor)),
                ),
              ),
              const SizedBox(height: 40),

              // --- TOMBOL DAFTAR ---
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isButtonActive ? mainColor : Colors.grey[300],
                    elevation: 0,
                  ),
                  onPressed: (_isButtonActive && !_isLoading)
                      ? _handleRegister
                      : null,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          "Daftar",
                          style: TextStyle(
                              color: _isButtonActive
                                  ? Colors.white
                                  : Colors.grey[600],
                              fontSize: 16),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

