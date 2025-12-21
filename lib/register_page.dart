import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoopedia/database_helper.dart'; // Panggil DB
import 'register_page.dart';
import 'home_page.dart';

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

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      _isButtonActive = _usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    });
  }

  // PROSES LOGIN
  Future<void> _handleLogin() async {
    String emailInput = _usernameController.text;
    String passwordInput = _passwordController.text;

    // Cek ke Database Lokal (SQLite)
    // Ini akan mendeteksi akun 'faisal' dan 'testing' yang sudah kita tanam
    var user = await DatabaseHelper.instance.loginUser(emailInput, passwordInput);

    if (user != null) {
      // Login Sukses
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', user['name']);
      
      print("Login Berhasil sebagai: ${user['name']}");
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selamat Datang, ${user['name']}!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      // Login Gagal
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email atau Password salah!"),
          backgroundColor: Colors.red,
        ),
      );
    }
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
        // Tombol back dihapus karena ini halaman awal
        automaticallyImplyLeading: false, 
        title: const Text("Log In", style: TextStyle(color: Colors.black, fontSize: 20)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Icon(Icons.shopping_bag, size: 70, color: mainColor),
              const SizedBox(height: 10),
              const Text("Shoopedia", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 30),
              
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: "Email",
                  prefixIcon: const Icon(Icons.person_outline),
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
              const SizedBox(height: 30),
              
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isButtonActive ? mainColor : Colors.grey[300],
                    elevation: 0,
                  ),
                  onPressed: _isButtonActive ? _handleLogin : null, 
                  child: Text(
                    "Log In", 
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
      bottomNavigationBar: Container(
        height: 50,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Belum punya akun? ", style: TextStyle(color: Colors.grey)),
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
                  style: TextStyle(color: mainColor, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
