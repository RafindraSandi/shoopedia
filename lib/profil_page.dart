import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shoopedia/pages/edit_profile_page.dart';
import 'package:shoopedia/pages/settings_page.dart';
import 'package:shoopedia/pages/address_page.dart';
import 'package:shoopedia/pages/payment_page.dart';
import 'package:shoopedia/pages/voucher_page.dart';
import 'package:shoopedia/pages/pesanan_page.dart';
import 'package:shoopedia/pages/shopeediaPay_page.dart';
import 'package:shoopedia/pages/coin_page.dart';
import 'package:shoopedia/pages/verification_form_page.dart';
import 'package:shoopedia/pages/store_management_page.dart';
import 'user_manager.dart';

class ShopeediaProfilePage extends StatefulWidget {
  const ShopeediaProfilePage({super.key});

  @override
  State<ShopeediaProfilePage> createState() => _ShopeediaProfilePageState();
}

class _ShopeediaProfilePageState extends State<ShopeediaProfilePage> {
  final Color mainColor = const Color(0xFFEE4D2D);

  // Helper untuk mendapatkan Image Provider (File atau Kosong)
  ImageProvider? _getProfileImage() {
    final path = UserManager.currentUser.profileImagePath;
    if (path != null && path.isNotEmpty) {
      final file = File(path);
      if (file.existsSync()) {
        return FileImage(file);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Refresh state saat halaman dibangun kembali (untuk update foto/nama setelah edit)
    final currentUser = UserManager.currentUser;

    return SafeArea(
      child: Container(
        color: Colors.grey[100],
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ==================================================
              // HEADER PROFIL
              // ==================================================
              InkWell(
                onTap: () async {
                  // Gunakan await agar saat kembali dari EditProfile, halaman ini di-refresh
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const EditProfilePage()),
                  );
                  setState(() {}); // Refresh halaman setelah edit
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  color: mainColor,
                  child: Row(
                    children: [
                      // FOTO PROFIL
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        backgroundImage: _getProfileImage(),
                        child: _getProfileImage() == null
                            ? const Icon(Icons.person,
                                size: 40, color: Colors.grey)
                            : null,
                      ),
                      const SizedBox(width: 15),
                      // NAMA & LABEL MEMBER
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentUser.fullName.isEmpty
                                  ? currentUser.username
                                  : currentUser.fullName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                "Member Silver", // Bisa dibuat dinamis nanti
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFEE4D2D),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      // TOMBOL SETTING
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SettingsPage()),
                          );
                        },
                        icon: const Icon(Icons.settings,
                            color: Colors.white, size: 28),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ==================================================
              // QUICK ACTION BUTTONS (Alamat, Pembayaran, Voucher)
              // ==================================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround, // Rapi otomatis
                  children: [
                    _buildQuickActionBtn(
                      icon: Icons.location_on,
                      title: "Alamat",
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const AddressPage())),
                    ),
                    _buildQuickActionBtn(
                      icon: Icons.credit_card,
                      title: "Pembayaran",
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const PaymentPage())),
                    ),
                    _buildQuickActionBtn(
                      icon: Icons.card_giftcard,
                      title: "Voucher",
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const VoucherPage())),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // PESANAN SAYA
              // ==================================================
              _buildSectionBox(
                title: "Pesanan Saya",
                children: [
                  _buildMenuTile(
                    icon: Icons.inventory_2,
                    title: "Dikemas",
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PesananPage(initialTab: 0))),
                  ),
                  _buildMenuTile(
                    icon: Icons.local_shipping,
                    title: "Dikirim",
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PesananPage(initialTab: 1))),
                  ),
                  _buildMenuTile(
                    icon: Icons.check_circle,
                    title: "Selesai",
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PesananPage(initialTab: 2))),
                  ),
                  _buildMenuTile(
                    icon: Icons.refresh,
                    title: "Pengembalian",
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PesananPage(initialTab: 3))),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ==================================================
              // DOMPET SHOOPEDIA
              // ==================================================
              _buildSectionBox(
                title: "Dompet Shopeedia",
                children: [
                  _buildWalletTile(
                    icon: Icons.account_balance_wallet,
                    title: "Saldo ShopeediaPay",
                    value: "Rp 1.540.000",
                    colorIcon: mainColor,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ShopeediaPayPage())),
                  ),
                  _buildWalletTile(
                    icon: Icons.monetization_on,
                    title: "Koin Shopeedia",
                    value: "2.500 Koin",
                    colorIcon: Colors.amber[700]!,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ShopeeCoinsPage())),
                  ),
                  _buildWalletTile(
                    icon: Icons.local_offer,
                    title: "Voucher Saya",
                    value: "3 Voucher",
                    colorIcon: Colors.orange,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const VoucherPage())),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ==================================================
              // SELLER SECTION (TOKO SAYA)
              // ==================================================
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [mainColor, mainColor.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: mainColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4))
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      if (!currentUser.isSeller) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const VerificationFormPage()),
                        ).then((_) => setState(() {}));
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const StoreManagementPage()),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          const Icon(Icons.store_front,
                              color: Colors.white, size: 36),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentUser.isSeller
                                      ? "Toko Saya"
                                      : "Mulai Jual",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  currentUser.isSeller
                                      ? "Kelola produk & pesanan masuk"
                                      : "Daftar Gratis & mulai jualan sekarang!",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              color: Colors.white70, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // WIDGET BUILDER METHODS (Agar code build utama bersih)
  // =========================================================

  Widget _buildQuickActionBtn(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 100,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: mainColor, size: 28),
            ),
            const SizedBox(height: 8),
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionBox(
      {required String title, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const Divider(height: 1),
          ...children,
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildMenuTile(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: onTap,
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildWalletTile(
      {required IconData icon,
      required String title,
      required String value,
      required Color colorIcon,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: colorIcon),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
      onTap: onTap,
    );
  }
}
