import 'package:flutter/material.dart';

class DetailBarangScreen extends StatelessWidget {
  final String namaBarang;
  final int hargaBarang;
  final int stokBarang;

  DetailBarangScreen({
    required this.namaBarang,
    required this.hargaBarang,
    required this.stokBarang,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Barang'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama Barang: $namaBarang',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Harga: Rp$hargaBarang', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Stok: $stokBarang', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
