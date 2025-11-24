import 'package:flutter/material.dart';
import 'home_page.dart'; // PENTING: Import ini agar bisa pindah ke Home

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
          onPressed: () {
            Navigator.pop(context);
          },
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
                  // 👇 LOGIKA PINDAH KE HOME JUGA DISINI
                  onPressed: _isButtonActive ? () {
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
      bottomNavigationBar: Container(
        height: 50,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Sudah punya akun? ", style: TextStyle(color: Colors.grey)),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Log In",
                  style: TextStyle(color: mainColor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}