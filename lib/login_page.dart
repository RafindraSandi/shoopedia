import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'register_page.dart';
import 'home_page.dart';
import 'user_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;
  bool _isButtonActive = false;
  bool _isLoading = false; // TAMBAHAN: Biar tombol bisa loading

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      _isButtonActive = _usernameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  Future<void> _handleLogin() async {
    // UPDATE: Pakai trim() untuk buang spasi tidak sengaja di depan/belakang
    String emailInput = _usernameController.text.trim();
    String passwordInput = _passwordController.text.trim();

    setState(() {
      _isLoading = true; // Mulai loading
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      String? existingUsersString = prefs.getString('all_users');

      bool isFound = false;
      Map<String, dynamic>? foundUser;

      if (existingUsersString != null) {
        // UPDATE: Bungkus decode pakai try-catch biar gak crash kalau data corrupt
        try {
          List<dynamic> userList = jsonDecode(existingUsersString);

          for (var user in userList) {
            // Pastikan key-nya ada dulu pakai cek sederhana atau null check
            String uEmail = user['email'] ?? '';
            String uUsername = user['username'] ?? '';
            String uPhone = user['phone'] ?? '';
            String uFullname = user['fullName'] ?? '';
            String uPass = user['password'] ?? '';

            if ((uEmail == emailInput ||
                    uUsername == emailInput ||
                    uPhone == emailInput ||
                    uFullname == emailInput) &&
                uPass == passwordInput) {
              isFound = true;
              foundUser = user;
              break;
            }
          }
        } catch (e) {
          debugPrint("Error decoding JSON: $e");
        }
      }

      // Simulasi delay dikit biar kerasa "mikir" (opsional)
      await Future.delayed(const Duration(milliseconds: 500));

      if (isFound && foundUser != null) {
        // Simpan data user yang login (PENTING biar di Home gak kosong)
        await UserManager.setCurrentUserFromMap(foundUser);
        
        _goToHome();
      } else {
        if (!mounted) return;
        _showSnackBar("Email atau Password salah!", Colors.red);
      }
    } catch (e) {
      if (!mounted) return;
      _showSnackBar("Terjadi kesalahan sistem: $e", Colors.red);
    } finally {
      // Selesai loading, kembalikan state
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _goToHome() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
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
        // UPDATE: Leading logic sedikit dirapikan
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: mainColor),
          onPressed: () => Navigator.of(context).pop(), // Lebih aman pakai pop kalau cuma back
        ),
        title: const Text("Log In",
            style: TextStyle(color: Colors.black, fontSize: 20)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Icon(Icons.shopping_bag, size: 70, color: mainColor),
              const SizedBox(height: 40),
              
              // FIELD USERNAME
              TextField(
                controller: _usernameController,
                // UPDATE: Set keyboard type biar tombol @ muncul (UX)
                keyboardType: TextInputType.emailAddress, 
                textInputAction: TextInputAction.next, // Biar tombol enter jadi "Next"
                decoration: InputDecoration(
                  hintText: "No. Handphone/Email/Username",
                  prefixIcon: const Icon(Icons.email),
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: mainColor)),
                ),
              ),
              const SizedBox(height: 20),
              
              // FIELD PASSWORD
              TextField(
                controller: _passwordController,
                obscureText: _isObscure,
                textInputAction: TextInputAction.done, // Tombol enter jadi "Done/Check"
                onSubmitted: (_) => _isButtonActive ? _handleLogin() : null, // Enter langsung login
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
              const SizedBox(height: 30),
              
              // TOMBOL LOGIN
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isButtonActive ? mainColor : Colors.grey[300],
                    elevation: 0,
                  ),
                  // UPDATE: Cek _isLoading agar tidak double click
                  onPressed: (_isButtonActive && !_isLoading) ? _handleLogin : null,
                  child: _isLoading 
                    ? const SizedBox(
                        height: 20, 
                        width: 20, 
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      )
                    : Text(
                        "Log In",
                        style: TextStyle(
                            color: _isButtonActive
                                ? Colors.white
                                : Colors.grey[600],
                            fontSize: 16),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Belum punya akun? ",
                style: TextStyle(color: Colors.grey)),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Daftar",
                  style: TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
