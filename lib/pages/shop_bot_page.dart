import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// =============================================================================
// FILE: shop_bot_page.dart
// VERSI: ULTIMATE ENTERPRISE EDITION
// =============================================================================

class ShopBotPage extends StatefulWidget {
  const ShopBotPage({super.key});

  @override
  State<ShopBotPage> createState() => _ShopBotPageState();
}

class _ShopBotPageState extends State<ShopBotPage> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  // --- STATE VARIABLES ---
  final List<BotMessageModel> _messages = [];
  bool _isTyping = false;
  
  // Konteks Percakapan (State Machine Sederhana)
  // none, waiting_resi, waiting_order_cancel, waiting_product_search, waiting_feedback
  String _currentContext = "none"; 
  
  // Data user dummy
  final String _userName = "Rafindra"; 

  @override
  void initState() {
    super.initState();
    _sendGreeting();
  }

  // Fungsi menyapa berdasarkan waktu
  void _sendGreeting() {
    var hour = DateTime.now().hour;
    String greeting = "Pagi";
    if (hour >= 12 && hour < 15) greeting = "Siang";
    else if (hour >= 15 && hour < 18) greeting = "Sore";
    else if (hour >= 18) greeting = "Malam";

    _addBotMessage(
      "Halo, Selamat $greeting Kak $_userName! 🧡\n\n"
      "Saya **Shop Bot**, asisten virtual tercanggih di Shoopedia.\n"
      "Saya bisa bantu cek resi, cari produk, hingga curhat lho!\n\n"
      "Ketik **'Menu'** untuk mulai atau tanya apa saja.",
      type: MessageType.text
    );
  }

  // --- CORE LOGIC ENGINE ---

  void _handleSubmitted(String text) {
    _textController.clear();
    if (text.trim().isEmpty) return;

    // 1. Tambahkan pesan User ke Layar
    setState(() {
      _messages.add(BotMessageModel(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
        type: MessageType.text,
      ));
      _isTyping = true; // Trigger animasi mengetik
    });
    _scrollToBottom();

    // 2. Simulasi "Berpikir" (Artificial Delay)
    // Semakin panjang teks user, semakin lama bot "membaca"
    int readingTime = min(text.length * 20, 1000); 
    int thinkingTime = 1000 + Random().nextInt(1500);

    Future.delayed(Duration(milliseconds: readingTime + thinkingTime), () {
      if (!mounted) return;
      _processBotResponse(text);
    });
  }

  // Otak Utama Pemrosesan Pesan
  void _processBotResponse(String input) {
    String lowerInput = input.toLowerCase().trim();
    String responseText = "";
    MessageType responseType = MessageType.text;
    List<dynamic>? payload; // Data tambahan (list produk/order)

    // --- A. CEK KONTEKS (Percakapan Bersambung) ---
    
    // 1. Sedang menunggu nomor resi
    if (_currentContext == "waiting_resi") {
      if (input.length < 5) {
        responseText = "Nomor resi sepertinya kurang lengkap Kak. Mohon cek lagi ya (Min. 5 karakter).";
      } else {
        responseText = "Melacak resi **$input**...";
        // Simulasi sukses & reset konteks
        _currentContext = "none";
        
        // Kirim 2 pesan: Loading & Hasil
        _addBotMessage("Sedang menghubungi server ekspedisi... 📡");
        
        Future.delayed(const Duration(seconds: 2), () {
           _addBotMessage(
             "📦 **STATUS PAKET: $input**\n\n"
             "📅 Update: ${DateTime.now().toString().substring(0,16)}\n"
             "📍 Posisi: **DC Cakung (Sortation Center)**\n"
             "🚚 Status: Paket sedang diberangkatkan ke Hub Kota Tujuan.\n\n"
             "Estimasi tiba: 1-2 hari lagi.",
             type: MessageType.orderInfo // Tipe Pesan Khusus
           );
        });
        return; // Keluar agar tidak lanjut ke logika bawah
      }
    }
    
    // 2. Sedang menunggu ID Order untuk pembatalan
    else if (_currentContext == "waiting_order_cancel") {
      if (input.toUpperCase().startsWith("SP")) {
        responseText = "Permintaan pembatalan untuk **$input** sedang diproses.\n\n"
            "Dana akan dikembalikan ke ShoopediaPay dalam 1x24 jam kerja. Ada lagi yang bisa dibantu?";
        _currentContext = "none";
      } else {
        responseText = "Format salah Kak. ID Pesanan harus diawali 'SP' (Contoh: SP-998811). Silakan ketik ulang.";
      }
    }

    // 3. Sedang menunggu kata kunci pencarian produk
    else if (_currentContext == "waiting_product_search") {
      responseText = "Menampilkan hasil pencarian untuk **'$input'** 🔍";
      responseType = MessageType.productList; // Tipe Pesan Produk
      _currentContext = "none";
      
      // Simulasi Data Produk Dummy
      payload = [
        {"name": "$input Super Murah", "price": "Rp 50.000", "rating": "4.8", "sold": "10rb+"},
        {"name": "$input Premium Original", "price": "Rp 150.000", "rating": "4.9", "sold": "2rb+"},
        {"name": "Paket $input Hemat", "price": "Rp 99.000", "rating": "4.7", "sold": "500+"},
      ];
    }

    // 4. Feedback Loop
    else if (_currentContext == "waiting_feedback") {
      if (lowerInput.contains("puas") || lowerInput.contains("bagus") || lowerInput.contains("oke") || lowerInput.contains("baik")) {
        responseText = "Alhamdulillah! Terima kasih feedback positifnya Kak $_userName. 🥰 Semangat belanjanya!";
      } else {
        responseText = "Mohon maaf jika kurang memuaskan. 🙏 Kami akan terus belajar agar lebih pintar lagi.";
      }
      _currentContext = "none";
    }

    // --- B. LOGIKA KEYWORD (JIKA TIDAK ADA KONTEKS) ---
    else {
      String knowledgeResult = BotKnowledgeBase.getResponse(lowerInput);
      
      // Cek apakah jawaban mengandung "ACTION TRIGGER"
      if (knowledgeResult == "ACTION_CEK_RESI") {
        _currentContext = "waiting_resi";
        responseText = "Siap melacak paket! 🕵️\nSilakan ketik **Nomor Resi** Kakak di bawah ini.";
      }
      else if (knowledgeResult == "ACTION_CANCEL_ORDER") {
        _currentContext = "waiting_order_cancel";
        responseText = "Yah, sayang banget pesanan dibatalin. 😢\nBoleh sebutkan **ID Pesanan** yang mau dibatalkan? (Contoh: SP-12345)";
      }
      else if (knowledgeResult == "ACTION_CARI_PRODUK") {
        _currentContext = "waiting_product_search";
        responseText = "Shop Bot siap carikan barang termurah! 🛍️\nKakak lagi cari barang apa? (Contoh: Sepatu lari, Kemeja flanel)";
      }
      else if (knowledgeResult == "ACTION_FEEDBACK") {
        _currentContext = "waiting_feedback";
        responseText = "Bagaimana pelayanan Shop Bot sejauh ini? Apakah Kakak **Puas** atau **Tidak**? 📝";
      }
      else if (knowledgeResult == "ACTION_MENU") {
        responseText = "Ini dia menu bantuan yang Shop Bot kuasai:";
        responseType = MessageType.menuOptions; // Tipe Menu
      }
      else if (knowledgeResult.isNotEmpty) {
        responseText = knowledgeResult;
      }
      else {
        // Fallback jika tidak mengerti
        responseText = _getFallbackResponse();
      }
    }

    // Eksekusi Pengiriman Pesan
    _addBotMessage(responseText, type: responseType, payload: payload);
  }

  String _getFallbackResponse() {
    List<String> fallbacks = [
      "Waduh, istilah itu belum ada di database saya. 🤔 Coba pakai bahasa yang lebih sederhana ya Kak.",
      "Maaf Kak, Shop Bot gagal paham. Coba tanya seputar **Pesanan**, **Pembayaran**, atau **Promo**.",
      "Sinyal otak bot agak putus-putus nih. Maksud Kakak gimana? 😅",
      "Saya masih bot junior, belum tau banyak hal. Coba ketik **'Menu'** untuk lihat apa yang saya bisa.",
    ];
    return fallbacks[Random().nextInt(fallbacks.length)];
  }

  // Fungsi Menambahkan Pesan ke UI
  void _addBotMessage(String text, {MessageType type = MessageType.text, List<dynamic>? payload}) {
    if (!mounted) return;
    setState(() {
      _isTyping = false;
      _messages.add(BotMessageModel(
        text: text,
        isUser: false,
        timestamp: DateTime.now(),
        type: type,
        payload: payload
      ));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutQuad,
        );
      }
    });
  }

  // --- WIDGET BUILDER HELPERS ---

  Widget _buildQuickAction(String label, String code, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        avatar: Icon(icon, size: 16, color: const Color(0xFFEE4D2D)),
        label: Text(label),
        backgroundColor: Colors.white,
        side: BorderSide(color: Colors.grey.shade300),
        labelStyle: const TextStyle(color: Colors.black87, fontSize: 12),
        onPressed: () => _handleSubmitted(code),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Abu muda banget
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: BackButton(color: Colors.black, onPressed: () => Navigator.pop(context)),
        titleSpacing: 0,
        title: Row(
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEE4D2D), // Shopee Orange
                    shape: BoxShape.circle,
                  ),
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.smart_toy_rounded, color: Color(0xFFEE4D2D), size: 24),
                  ),
                ),
                Positioned(
                  right: 0, bottom: 0,
                  child: Container(
                    width: 12, height: 12,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent[400],
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2)
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Shop Bot 🤖", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    const Text("Online", style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.w600)),
                    Text(" • Siap membantu $_userName", style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.grey),
            tooltip: "Reset Chat",
            onPressed: () {
              setState(() {
                _messages.clear();
                _currentContext = "none";
                _sendGreeting();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Versi Bot: 3.5.0 (Enterprise)")));
            },
          )
        ],
      ),
      body: Column(
        children: [
          // 1. CHAT LIST AREA
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(message: _messages[index]);
              },
            ),
          ),

          // 2. TYPING INDICATOR (ANIMATED)
          if (_isTyping)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 12, height: 12,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFEE4D2D)),
                    ),
                    const SizedBox(width: 8),
                    Text("Shop Bot mengetik...", style: TextStyle(color: Colors.grey[600], fontSize: 11, fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
            ),

          // 3. QUICK ACTIONS (CHIPS)
          Container(
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildQuickAction("📦 Cek Resi", "Cek resi paket", Icons.local_shipping),
                _buildQuickAction("🔍 Cari Barang", "Cari produk", Icons.search),
                _buildQuickAction("💰 Cara Bayar", "Bagaimana cara bayar", Icons.payment),
                _buildQuickAction("🎟️ Voucher", "Ada voucher?", Icons.confirmation_number),
                _buildQuickAction("🚫 Batal", "Batalkan pesanan", Icons.cancel),
                _buildQuickAction("⭐ Feedback", "Beri nilai bot", Icons.star),
                _buildQuickAction("🤪 Jokes", "Cerita lucu dong", Icons.emoji_emotions),
              ],
            ),
          ),

          // 4. INPUT AREA
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, -3), blurRadius: 10)]
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Color(0xFFEE4D2D), size: 28), 
                    onPressed: (){
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fitur upload gambar belum tersedia di demo ini")));
                    }
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey.shade300)
                      ),
                      child: TextField(
                        controller: _textController,
                        focusNode: _focusNode,
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: "Ketik pesan untuk Shop Bot...",
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        onSubmitted: _handleSubmitted,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _handleSubmitted(_textController.text),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEE4D2D),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// MODELS & ENUMS
// =============================================================================

enum MessageType { text, image, orderInfo, productList, menuOptions }

class BotMessageModel {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final MessageType type;
  final List<dynamic>? payload; // Bisa diisi list produk, list menu, dll

  BotMessageModel({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.type = MessageType.text,
    this.payload,
  });
}

// =============================================================================
// WIDGET: CHAT BUBBLE (TAMPILAN PESAN)
// =============================================================================

class ChatBubble extends StatelessWidget {
  final BotMessageModel message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    // 1. Jika Pesan dari USER (Kanan)
    if (message.isUser) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFFEE4D2D), Color(0xFFFF7337)]),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                child: Text(
                  message.text,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // 2. Jika Pesan dari BOT (Kiri)
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, right: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xFFEE4D2D),
            child: Icon(Icons.smart_toy_rounded, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama Bot
                const Padding(
                  padding: EdgeInsets.only(left: 4, bottom: 4),
                  child: Text("Shop Bot", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
                
                // Bubble Utama
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: _buildMessageContent(message),
                ),

                // Timestamp
                Padding(
                  padding: const EdgeInsets.only(left: 4, top: 4),
                  child: Text(
                    "${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2,'0')}", 
                    style: TextStyle(fontSize: 10, color: Colors.grey[400])
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Builder Isi Pesan (Text biasa / Kartu Produk / Menu)
  Widget _buildMessageContent(BotMessageModel msg) {
    switch (msg.type) {
      
      // Tipe 1: Teks Biasa
      case MessageType.text:
        return Text(msg.text, style: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.5));

      // Tipe 2: Info Order (Pelacakan)
      case MessageType.orderInfo:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(msg.text, style: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.5)),
            const SizedBox(height: 10),
            Container(
              height: 4,
              width: 100,
              decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 5),
            const Text("Paket bergerak mendekatimu 🚀", style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
          ],
        );

      // Tipe 3: List Produk (Rekomendasi)
      case MessageType.productList:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(msg.text, style: const TextStyle(color: Colors.black87, fontSize: 14)),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: (msg.payload ?? []).map<Widget>((product) {
                  return Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[50]
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 80, color: Colors.grey[300], child: const Center(child: Icon(Icons.image, color: Colors.white))),
                        const SizedBox(height: 5),
                        Text(product['name'], maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        Text(product['price'], style: const TextStyle(fontSize: 12, color: Color(0xFFEE4D2D))),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 10, color: Colors.amber),
                            Text(" ${product['rating']} | ${product['sold']}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          ],
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 5),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(30)),
              child: const Text("Lihat Semua Produk", style: TextStyle(fontSize: 12)),
            )
          ],
        );

      // Tipe 4: Opsi Menu
      case MessageType.menuOptions:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(msg.text, style: const TextStyle(color: Colors.black87, fontSize: 14)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildMenuChip("📦 Cek Resi"),
                _buildMenuChip("💰 Cara Bayar"),
                _buildMenuChip("🚚 Komplain Pengiriman"),
                _buildMenuChip("🔐 Lupa Password"),
                _buildMenuChip("🎟️ Promo Hari Ini"),
              ],
            )
          ],
        );

      default:
        return Text(msg.text);
    }
  }

  Widget _buildMenuChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEE4D2D).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEE4D2D).withOpacity(0.3))
      ),
      child: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFFEE4D2D), fontWeight: FontWeight.bold)),
    );
  }
}

// =============================================================================
// DATABASE PENGETAHUAN (KNOWLEDGE BASE) RAKSASA
// =============================================================================

class BotKnowledgeBase {
  // Peta Pengetahuan: [List Kata Kunci] -> Jawaban
  static final Map<List<String>, String> _knowledge = {
    // --- SAPAAN & BASA BASI ---
    ['halo', 'hi', 'hai', 'helo', 'hello', 'hola']: 
      "Halo juga Kak! 👋 Ada yang bisa Shop Bot bantu? Jangan ragu buat tanya ya.",
    ['pagi', 'selamat pagi']: 
      "Selamat pagi! ☀️ Semoga harimu menyenangkan. Jangan lupa cek Flash Sale pagi ini ya!",
    ['siang', 'selamat siang']: 
      "Selamat siang Kak! Sudah makan siang? Sambil istirahat yuk cek keranjang belanjanya. 🍱",
    ['malam', 'selamat malam']: 
      "Selamat malam! 🌙 Waktunya istirahat... atau lanjut scrolling Shoopedia? hehe.",
    ['apa kabar', 'gimana kabarmu']: 
      "Saya selalu sehat dan online 24 jam buat Kakak! 🤖 Kakak sendiri gimana? Sehat?",
    ['terima kasih', 'makasih', 'thanks', 'tq', 'thank you', 'tengkyu']: 
      "Sama-sama Kak! Senang bisa jadi asistenmu hari ini. 🥰 Kalau puas, boleh dong kasih bintang 5 di Playstore!",
    ['siapa kamu', 'kamu siapa', 'bot', 'robot', 'asisten']: 
      "Kenalin, saya **Shop Bot**! 🤖\nAnak asuh tim IT Shoopedia. Hobi saya balesin chat dan cariin diskon buat Kakak.",
    ['bodoh', 'bego', 'goblok', 'tolol', 'jelek', 'anjing']: 
      "Waduh, kok kasar gitu Kak? 😢 Shop Bot jadi sedih. Kalau saya salah jawab, maafin ya. Kakak bisa ketik 'Chat CS' kok untuk bicara sama manusia.",
    ['pintar', 'cerdas', 'bagus', 'keren', 'mantap', 'good']: 
      "Wah, makasih pujiannya! Jadi malu 😳. Shoopedia emang paling keren deh!",
    
    // --- MENU & NAVIGASI ---
    ['menu', 'help', 'bantuan', 'tolong', 'pilihan', 'opsi']: 
      "ACTION_MENU",
    ['keluar', 'exit', 'bye', 'dadah']: 
      "Oke Kak, sampai jumpa lagi! 👋 Hati-hati di jalan (eh, di aplikasi maksudnya).",

    // --- PESANAN & PENGIRIMAN ---
    ['resi', 'cek resi', 'lacak', 'tracking', 'paket dimana', 'posisi paket', 'status pengiriman']: 
      "ACTION_CEK_RESI",
    ['belum sampai', 'lama banget', 'telat', 'kok gak nyampe', 'lelet']: 
      "Mohon maaf atas ketidaknyamanannya Kak. 🙏 Terkadang kurir mengalami kendala di jalan atau overload.\n\nCoba ketik **Nomor Resi** Kakak, biar saya bantu lacak posisinya.",
    ['batal', 'cancel', 'batalkan', 'gak jadi beli', 'salah beli']: 
      "ACTION_CANCEL_ORDER",
    ['barang rusak', 'pecah', 'cacat', 'retur', 'pengembalian', 'salah warna', 'salah ukuran']: 
      "Duh, maaf banget barangnya bermasalah. 😔\n\nKakak berhak ajukan **Retur/Refund** kok! Caranya:\n1. Jangan klik 'Pesanan Diterima'.\n2. Buka Rincian Pesanan.\n3. Klik 'Ajukan Pengembalian'.\n4. Upload Video Unboxing.\n\nDana pasti aman!",
    ['alamat', 'ganti alamat', 'ubah alamat', 'salah alamat']: 
      "Ubah alamat cuma bisa dilakukan jika status pesanan masih **'Dikemas'**. Langsung cek di rincian pesanan ya.\n\nKalau sudah **'Dikirim'**, alamat sudah terkunci di sistem kurir. Kakak harus hubungi kurirnya langsung.",
    ['kurir', 'ekspedisi', 'jne', 'j&t', 'sicepat', 'anteraja']: 
      "Shoopedia bekerjasama dengan banyak ekspedisi terbaik. Pemilihan kurir bisa diatur saat Checkout ya Kak.",

    // --- PRODUK & PENCARIAN ---
    ['cari', 'search', 'mencari', 'rekomendasi', 'saran', 'produk']: 
      "ACTION_CARI_PRODUK",
    ['mahal', 'kemahalan', 'turunin harga', 'tawar']: 
      "Harga di Shoopedia sudah bersaing banget lho Kak! 😉\nTapi kalau mau lebih murah, coba pakai filter 'Termurah' atau tunggu Flash Sale.",
    ['habis', 'stok habis', 'kosong']: 
      "Yah, kalau stok habis berarti barangnya laku keras. Coba chat Penjualnya untuk tanya kapan restock ya.",

    // --- PEMBAYARAN ---
    ['bayar', 'cara bayar', 'payment', 'transfer', 'metode pembayaran']: 
      "Kakak bisa bayar pakai apa aja:\n✅ **ShoopediaPay** (Gratis Ongkir!)\n✅ **Transfer Bank/VA** (Otomatis)\n✅ **Indomaret/Alfamart**\n✅ **COD** (Bayar Tunai)\n\nMau panduan detail yang mana?",
    ['cod', 'bayar ditempat', 'cash on delivery']: 
      "COD tersedia untuk toko bertanda khusus.\nSyarat:\n- Max belanja 3 Juta.\n- Dilarang menolak paket (No Cancel saat kurir datang).\n- Siapkan uang pas.",
    ['gagal bayar', 'error', 'tidak bisa transfer', 'gangguan']: 
      "Kalau pembayaran gagal, biasanya karena:\n1. Kode VA kadaluarsa (Buat pesanan ulang).\n2. Bank sedang offline (Tunggu 10 menit).\n3. Saldo tidak cukup.\n\nCoba cek lagi ya Kak!",
    ['paylater', 'kredit', 'cicilan', 'hutang']: 
      "Mau belanja sekarang bayar nanti? Aktifkan **ShoopediaPayLater** di menu Profil. Bunganya rendah dan bisa cicil 12x lho!",

    // --- AKUN & KEAMANAN ---
    ['lupa password', 'lupa sandi', 'reset password', 'kata sandi']: 
      "Tenang, akun aman. 🔐\nSilakan Logout, lalu klik **'Lupa Password'** di layar login. Kami akan kirim link reset ke email Kakak.",
    ['ganti nomor', 'ubah nomor', 'nomor hp', 'no hp']: 
      "Ganti nomor bisa di **Pengaturan Akun > Profil > Telepon**. Pastikan nomor lama masih aktif untuk terima OTP ya.",
    ['hapus akun', 'delete account']: 
      "Yakin mau pergi? 😢 Penghapusan akun itu permanen lho, Koin & Voucher bakal hangus.\nMenu hapus akun ada di bagian paling bawah Pengaturan.",
    ['otp', 'kode verifikasi', 'kode rahasia']: 
      "⚠️ **PENTING**: Jangan pernah kasih kode OTP ke siapapun! Termasuk yang ngaku-ngaku pihak Shoopedia. Itu rahasia Kakak.",

    // --- VOUCHER & PROMO ---
    ['voucher', 'diskon', 'promo', 'kode', 'potongan']: 
      "Siap berburu diskon! 🎟️\nCek menu **'Voucher Saya'** untuk klaim Gratis Ongkir. Atau tunggu tanggal kembar (9.9, 10.10) buat diskon gila-gilaan!",
    ['gratis ongkir', 'free ongkir']: 
      "Gratis ongkir biasanya berlaku untuk pembayaran ShoopediaPay atau COD dengan minimal belanja tertentu (mulai Rp 0 - Rp 30rb).",
    ['koin', 'poin', 'coin']: 
      "Koin Shoopedia bisa dipakai buat motong harga belanjaan lho! 1 Koin = Rp 1. Rajin-rajin check-in harian ya biar dapet banyak.",

    // --- FITUR & TEKNIS ---
    ['lemot', 'lag', 'lambat', 'berat']: 
      "Waduh, maaf ya. Coba langkah ini:\n1. Hapus Cache aplikasi.\n2. Update aplikasi di Playstore.\n3. Cek sinyal internet.\nSemoga ngebut lagi! 🚀",
    ['cs', 'admin', 'customer service', 'live chat', 'orang', 'human']: 
      "Oke, kalau Kakak butuh bantuan manusia, silakan masuk ke **Pusat Bantuan** lalu pilih 'Chat dengan Agen'. Mereka standby 24 jam.",

    // --- FUN & EASTER EGGS ---
    ['nyanyi', 'bisa nyanyi']: 
      "🎵 Shopee pe pe pe... Belanja di Shopee pe pe... 🎵\n(Maaf suara saya cempreng, maklum robot)",
    ['jomblo', 'pacar', 'punya pacar']: 
      "Pacar saya itu server Shoopedia. Dia yang selalu kasih tenaga buat saya online terus ❤️",
    ['lucu', 'lawak', 'ngelawak', 'jokes']: 
      "Kenapa anak kucing gak bisa belanja online?\n.\n.\nKarena gak punya *CAT*-atan belanja! 😹 (Garing ya? Maaf...)",
    ['feedback', 'nilai', 'puas', 'review']:
      "ACTION_FEEDBACK",
  };

  // Fungsi Pencocokan Kata Kunci (Keyword Matching Engine)
  static String getResponse(String input) {
    // 1. Cek Exact Match
    for (var keywords in _knowledge.keys) {
      for (var word in keywords) {
        // Logika: Jika input user mengandung salah satu kata kunci
        // Menggunakan RegExp untuk memastikan kata utuh (opsional, tapi simple contains sudah cukup kuat)
        if (input.contains(word)) {
          return _knowledge[keywords]!;
        }
      }
    }
    return ""; // Tidak ditemukan (akan masuk fallback)
  }
}
