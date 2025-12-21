import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login_page.dart';
import 'address_page.dart';
// IMPORT FILE BARU KITA
import 'privacy_policy_page.dart';
import 'help_center_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  void _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar Akun'),
        content: const Text('Yakin ingin keluar?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              if (!mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text('Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pengaturan Akun")),
      body: ListView(
        children: [
          // Grup: Akun Saya
          _buildSectionHeader("Akun Saya"),
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: const Text("Alamat Saya"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddressPage())),
          ),
          
          const Divider(),

          // Grup: Informasi (YANG BARU DITAMBAHKAN)
          _buildSectionHeader("Informasi & Bantuan"),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined, color: Colors.blue),
            title: const Text("Kebijakan Privasi"),
            subtitle: const Text("Syarat ketentuan & penggunaan data"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigasi ke Halaman Kebijakan
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.green),
            title: const Text("Pusat Bantuan"),
            subtitle: const Text("FAQ & Hubungi CS"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigasi ke Halaman Bantuan
              Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpCenterPage()));
            },
          ),
          
          const Divider(),

          // Grup: Aksi
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Keluar", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }
}
