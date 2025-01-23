import 'dart:convert';
import 'package:http/http.dart' as http;

class BarangController {
  static const String baseUrl = 'YOUR_API_URL';

  Future<List<Map<String, dynamic>>> fetchBarang() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/barang'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load barang');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> deleteBarang(String noBarcode) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/barang/$noBarcode'),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete barang');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<void> addBarang(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/barang'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to add barang');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<void> updateBarang(
    String noBarcode,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/barang/$noBarcode'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update barang');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
