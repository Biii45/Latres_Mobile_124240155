import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://api.tvmaze.com';

  static Future<List<dynamic>> fetchShows() async {
    final res = await http.get(Uri.parse('$_baseUrl/shows'));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as List<dynamic>;
    }
    throw Exception('Gagal memuat daftar show');
  }

  static Future<Map<String, dynamic>> fetchShowDetail(int id) async {
    final res = await http.get(Uri.parse('$_baseUrl/shows/$id'));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Gagal memuat detail show');
  }
}