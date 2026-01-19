import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  // Dummy History
  final List<String> _history = ["Kemeja Flannel", "Sepatu Nike", "Skintific", "Laptop Gaming"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 0,
        leading: const BackButton(color: Color(0xFFEE4D2D)),
        title: Container(
          height: 40,
          margin: const EdgeInsets.only(right: 16),
          child: TextField(
            controller: _searchController,
            autofocus: true, // Langsung muncul keyboard pas dibuka
            decoration: InputDecoration(
              hintText: "Cari di Shoopedia...",
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFEE4D2D))),
              suffixIcon: const Icon(Icons.search, color: Color(0xFFEE4D2D)),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Histori Pencarian
          if (_history.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Terakhir Dicari", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () => setState(() => _history.clear()),
                    child: const Text("Hapus", style: TextStyle(color: Colors.grey)),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                children: _history.map((text) => ActionChip(
                  label: Text(text),
                  backgroundColor: Colors.grey[100],
                  onPressed: () {
                    _searchController.text = text; // Isi text field
                  },
                )).toList(),
              ),
            ),
          ],
          const Divider(height: 40),
          // Pencarian Populer
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text("Pencarian Populer", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView(
              children: const [
                ListTile(
                  leading: Icon(Icons.trending_up, color: Colors.red),
                  title: Text("iPhone 15 Pro Max"),
                  subtitle: Text("Populer di Gadget"),
                ),
                ListTile(
                  leading: Icon(Icons.trending_up, color: Colors.red),
                  title: Text("Baju Lebaran 2024"),
                  subtitle: Text("Populer di Fashion"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
