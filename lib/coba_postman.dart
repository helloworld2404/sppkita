// lib/main.dart (or wherever your CobaPostman widget is located)

import 'package:flutter/material.dart';
import 'services/api_service.dart'; // Import the ApiService

class CobaPostman extends StatefulWidget {
  @override
  _CobaPostmanState createState() => _CobaPostmanState();
}

class _CobaPostmanState extends State<CobaPostman> {
  late ApiService apiService;
  late Future<List<dynamic>> futurePembayaran;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(baseUrl: 'http://10.0.2.2:8000/api');
    futurePembayaran = apiService.fetchPembayaran();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pembayaran Data'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futurePembayaran,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final pembayaran = data[index];
                return ListTile(
                  title: Text(pembayaran['siswa']['nama']), // Display student's name
                  subtitle: Text('Tanggal Bayar: ${pembayaran['tanggal_bayar']}'),
                  trailing: Text('Status: ${pembayaran['status']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
