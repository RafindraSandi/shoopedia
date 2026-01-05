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
  double _scale = 1.0;

  void animateButton(VoidCallback onTap) {
    setState(() => _scale = 0.9);
    Future.delayed(const Duration(milliseconds: 120), () {
      setState(() => _scale = 1.0);
      Future.delayed(const Duration(milliseconds: 120), onTap);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.grey[100],
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ==================================================
              // HEADER — Sekarang bisa diklik
              // ==================================================
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfilePage()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  color: mainColor,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        backgroundImage: UserManager
                                        .currentUser.profileImagePath !=
                                    null &&
                                UserManager
                                    .currentUser.profileImagePath!.isNotEmpty
                            ? FileImage(
                                File(UserManager.currentUser.profileImagePath!))
                            : null,
                        child:
                            UserManager.currentUser.profileImagePath == null ||
                                    UserManager
                                        .currentUser.profileImagePath!.isEmpty
                                ? const Icon(Icons.person,
                                    size: 40, color: Colors.grey)
                                : null,
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            UserManager.currentUser.fullName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
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
                              "Member",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFEE4D2D),
                              ),
                            ),
                          )
                        ],
                      ),
                      const Spacer(),
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
              // QUICK ACTION WITH CLICK
              // ==================================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    quickActionButton(
                      icon: Icons.location_on,
                      title: "Alamat",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AddressPage()),
                        );
                      },
                    ),
                    quickActionButton(
                      icon: Icons.credit_card,
                      title: "Pembayaran",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PaymentPage()),
                        );
                      },
                    ),
                    quickActionButton(
                      icon: Icons.card_giftcard,
                      title: "Voucher",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const VoucherPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // PESANAN SAYA (SUDAH BISA DIKLIK)
              // ==================================================
              sectionBox(
                title: "Pesanan Saya",
                children: [
                  orderMenu(
                    icon: Icons.inventory_2,
                    title: "Dikemas",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PesananPage(initialTab: 0),
                        ),
                      );
                    },
                  ),
                  orderMenu(
                    icon: Icons.local_shipping,
                    title: "Dikirim",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PesananPage(initialTab: 1),
                        ),
                      );
                    },
                  ),
                  orderMenu(
                    icon: Icons.check_circle,
                    title: "Pesanan Selesai",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PesananPage(initialTab: 2),
                        ),
                      );
                    },
                  ),
                  orderMenu(
                    icon: Icons.refresh,
                    title: "Pengembalian",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PesananPage(initialTab: 3),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ==================================================
              // DOMPET SHOOPEDIA
              // ==================================================
              sectionBox(
                title: "Dompet Shopeedia",
                children: [
                  walletMenu(
                    icon: Icons.account_balance_wallet,
                    title: "Saldo ShopeediaPay",
                    value: "Rp 1.540.000",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ShopeediaPayPage()),
                      );
                    },
                  ),
                  walletMenu(
                    icon: Icons.monetization_on,
                    title: "Koin Shopeedia",
                    value: "2500 Koin",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ShopeeCoinsPage()),
                      );
                    },
                  ),
                  walletMenu(
                    icon: Icons.local_offer,
                    title: "Voucher",
                    value: "3 Voucher",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const VoucherPage()),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ==================================================
              // MULAI JUAL / KELOLA TOKO
              // ==================================================
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: InkWell(
                  onTap: () {
                    if (!UserManager.currentUser.isSeller) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const VerificationFormPage()),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const StoreManagementPage()),
                      );
                    }
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.store, color: Colors.white, size: 30),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              UserManager.currentUser.isSeller
                                  ? "Kelola Toko"
                                  : "Mulai Jual",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              UserManager.currentUser.isSeller
                                  ? "Kelola produk dan toko Anda"
                                  : "Jadilah penjual dan mulai berjualan produk Anda",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // QUICK ACTION TEMPLATE
  // =========================================================
  Widget quickActionButton(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 120),
      child: InkWell(
        onTap: () => animateButton(onTap),
        child: SizedBox(
          width: 95,
          child: Column(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: mainColor.withOpacity(0.1),
                child: Icon(icon, color: mainColor),
              ),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // SECTION BOX WRAPPER
  // =========================================================
  Widget sectionBox({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 6,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(title,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ),
          const Divider(),
          ...children,
        ],
      ),
    );
  }

  // =========================================================
  // MENU COMPONENTS
  // =========================================================
  Widget orderMenu(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: mainColor),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget walletMenu(
      {required IconData icon,
      required String title,
      required String value,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      trailing:
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      onTap: onTap,
    );
  }

  Widget simpleMenu({required IconData icon, required String title}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {},
    );
  }
}
