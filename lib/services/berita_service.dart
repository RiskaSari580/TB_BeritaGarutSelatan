import 'dart:convert';
import 'package:http/http.dart' as http;

class BeritaService {
  static const String baseUrl =
      'https://685b871689952852c2d9d816.mockapi.io/api/v1/berita';

  /// Ambil semua berita
  static Future<List<dynamic>> fetchBerita() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengambil data berita');
    }
  }

  /// Hapus berita berdasarkan ID
  static Future<bool> deleteBerita(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    return response.statusCode == 200;
  }

  /// (Opsional) Tambah berita
  static Future<bool> tambahBerita(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    return response.statusCode == 201;
  }

  /// (Opsional) Update berita
  static Future<bool> updateBerita(String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    return response.statusCode == 200;
  }
}
