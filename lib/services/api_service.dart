// lib/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<List<dynamic>> fetchPembayaran() async {
    final response = await http.get(Uri.parse('$baseUrl/pembayaran'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['data'] as List<dynamic>;
    } else {
      throw Exception('Failed to load pembayaran');
    }
  }

  Future<List<dynamic>> fetchTotalPembayaran(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/pembayaran'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<dynamic> data = jsonResponse['data'];

      List<dynamic> filteredData = data.where((item) => item['status'] == 'belum lunas' && item['siswa']['akunid'] == userId).toList();

      filteredData.forEach((item) {
        item['spp']['nominal'] = int.parse(item['spp']['nominal'].toString());
      });

      return filteredData;
    } else {
      throw Exception('Failed to load pembayaran');
    }
  }

  Future<void> updateTagihanStatus(String tagihanId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/pembayaran/$tagihanId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'status': 'Lunas',
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update tagihan status');
    }
  }
}
