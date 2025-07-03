import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditBeritaPage extends StatefulWidget {
  final Map berita;

  EditBeritaPage({required this.berita});

  @override
  _EditBeritaPageState createState() => _EditBeritaPageState();
}

class _EditBeritaPageState extends State<EditBeritaPage> {
  late TextEditingController _title;
  late TextEditingController _content;
  late TextEditingController _imageUrl;
  String? selectedCategory;

  final List<String> categories = [
    'Trending',
    'Pemerintahan / Desa',
    'Politik',
    'Bencana Alam',
  ];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.berita['title']);
    _content = TextEditingController(text: widget.berita['content']);
    _imageUrl = TextEditingController(text: widget.berita['imageUrl']);

    // Jika kategori lama tidak ada di daftar baru, fallback ke 'Trending'
    selectedCategory = categories.contains(widget.berita['category'])
        ? widget.berita['category']
        : 'Trending';
  }

  Future<void> _update() async {
    if (_title.text.isEmpty || _content.text.isEmpty || _imageUrl.text.isEmpty || selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Semua field harus diisi')),
      );
      return;
    }

    setState(() => isLoading = true);

    final response = await http.put(
      Uri.parse('https://685b871689952852c2d9d816.mockapi.io/api/v1/berita/${widget.berita['id']}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': _title.text,
        'content': _content.text,
        'imageUrl': _imageUrl.text,
        'category': selectedCategory,
        'createdAt': widget.berita['createdAt'],
      }),
    );

    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Berita berhasil diupdate')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal update berita')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        title: Text('Edit Berita'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📝 Edit Berita',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
                SizedBox(height: 16),
                _buildTextField(_title, 'Judul Berita', Icons.title),
                SizedBox(height: 16),
                _buildTextField(_content, 'Isi Berita', Icons.article, maxLines: 5),
                SizedBox(height: 16),
                _buildTextField(_imageUrl, 'URL Gambar', Icons.image),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: categories
                      .map((cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() => selectedCategory = val);
                  },
                  decoration: InputDecoration(
                    labelText: 'Kategori',
                    prefixIcon: Icon(Icons.category),
                    filled: true,
                    fillColor: Colors.orange[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.save),
                    label: isLoading
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text('Simpan Perubahan'),
                    onPressed: isLoading ? null : _update,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[800],
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.orange[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
