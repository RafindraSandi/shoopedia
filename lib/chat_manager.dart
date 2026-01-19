class ChatManager {
  // Key: Nama Toko, Value: List Chat
  static Map<String, List<Map<String, dynamic>>> chatHistory = {};

  // Ambil pesan berdasarkan nama toko
  static List<Map<String, dynamic>> getMessages(String shopName) {
    if (!chatHistory.containsKey(shopName)) {
      // Default pesan awal kalau belum pernah chat
      chatHistory[shopName] = [
        {"sender": "shop", "text": "Halo kak, ada yang bisa dibantu?"},
      ];
    }
    return chatHistory[shopName]!;
  }

  // Tambah pesan baru
  static void addMessage(String shopName, String text, String sender) {
    if (!chatHistory.containsKey(shopName)) {
      getMessages(shopName);
    }
    chatHistory[shopName]!.add({"sender": sender, "text": text});
  }
}
