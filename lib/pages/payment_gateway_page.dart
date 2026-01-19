import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk fitur Copy Paste
import 'dart:math';

class PaymentGatewayPage extends StatefulWidget {
  final int totalAmount;
  final String paymentMethod; // e.g., "BCA Virtual Account", "Gopay"

  const PaymentGatewayPage({
    super.key,
    required this.totalAmount,
    required this.paymentMethod,
  });

  @override
  State<PaymentGatewayPage> createState() => _PaymentGatewayPageState();
}

class _PaymentGatewayPageState extends State<PaymentGatewayPage> {
  late String virtualAccountNumber;
  bool _isLoading = true;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    // Generate nomor VA dummy acak
    virtualAccountNumber = "880${Random().nextInt(99999999)}";
    
    // Simulasi loading koneksi ke gateway
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _simulatePaymentSuccess() {
    setState(() => _isLoading = true);
    
    // Simulasi proses verifikasi pembayaran
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isSuccess = true;
        });
        
        // Tutup halaman setelah 1.5 detik dan kirim status SUKSES ke halaman sebelumnya
        Future.delayed(const Duration(milliseconds: 1500), () {
          Navigator.pop(context, true); // true artinya pembayaran sukses
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Payment Gateway", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context, false), // false artinya batal
        ),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text("Memproses Transaksi..."),
                ],
              ),
            )
          : _isSuccess
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.check_circle, color: Colors.green, size: 80),
                      SizedBox(height: 20),
                      Text("Pembayaran Berhasil!",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Total
                      Center(
                        child: Column(
                          children: [
                            const Text("Total Pembayaran", style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 5),
                            Text(
                              "Rp ${widget.totalAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 40),

                      // Info VA
                      Text("Metode: ${widget.paymentMethod}", style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Nomor Virtual Account:", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  virtualAccountNumber,
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange),
                                ),
                                InkWell(
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(text: virtualAccountNumber));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Nomor VA disalin!")));
                                  },
                                  child: const Text("SALIN", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const Spacer(),

                      // Instruksi Pembayaran (Dummy)
                      const Text(
                        "Instruksi Pembayaran (Simulasi Debug):",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                      const Text(
                        "Karena ini adalah aplikasi demo, silakan tekan tombol di bawah ini untuk mensimulasikan bahwa Anda telah membayar via M-Banking/ATM.",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Tombol Bayar
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green, // Warna sukses
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _simulatePaymentSuccess,
                          child: const Text("Simulasi: Saya Sudah Bayar"),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
