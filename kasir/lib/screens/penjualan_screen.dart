import 'package:flutter/material.dart';
import 'package:kasir/controller/penjualan_controller.dart';
import 'package:kasir/screens/history_screen.dart';
import 'package:kasir/widget/button.dart';

class PenjualanScreen extends StatefulWidget {
  @override
  _PenjualanScreenState createState() => _PenjualanScreenState();
}

class _PenjualanScreenState extends State<PenjualanScreen> {
  final PenjualanController barangController = PenjualanController();
  final Map<String, Map<String, dynamic>> scannedItems = {};
  int totalItems = 0;
  double totalPrice = 0.0;

  final TextEditingController barcodeController = TextEditingController();

  void addItem(String barcode) async {
    try {
      final product = await barangController.fetchProductByBarcode(barcode);

      if (product != null) {
        setState(() {
          if (scannedItems.containsKey(barcode)) {
            scannedItems[barcode]!['jumlah']++;
          } else {
            scannedItems[barcode] = {
              "nama": product['nama'],
              "harga": product['harga'],
              "no_barcode": product['no_barcode'],
              "jumlah": 1,
            };
          }
          calculateTotals();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Barang dengan barcode $barcode tidak ditemukan!'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void removeItem(String barcode) {
    if (scannedItems.containsKey(barcode)) {
      setState(() {
        if (scannedItems[barcode]!['jumlah'] > 1) {
          scannedItems[barcode]!['jumlah']--;
        } else {
          scannedItems.remove(barcode);
        }
        calculateTotals();
      });
    }
  }

  void calculateTotals() {
    totalItems = 0;
    totalPrice = 0.0;
    scannedItems.forEach((barcode, item) {
      int jumlah = item['jumlah'] ?? 0;
      int harga = item['harga'] ?? 0;
      totalItems += jumlah;
      totalPrice += jumlah * harga;
    });
  }

  void handlePayment() async {
    String noNota = "INV-${DateTime.now().millisecondsSinceEpoch}";
    List<Map<String, dynamic>> items =
        scannedItems.entries.map((entry) {
          return {
            "nama": entry.value['nama'],
            "no_barcode": entry.value['no_barcode'],
            "harga": entry.value['harga'],
            "jumlah": entry.value['jumlah'],
          };
        }).toList();

    try {
      await PenjualanController.saveTransaction(noNota, items);
      setState(() {
        scannedItems.clear();
        totalItems = 0;
        totalPrice = 0.0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pembayaran berhasil! No Nota: $noNota')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaksi'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: barcodeController,
              decoration: InputDecoration(
                labelText: 'Masukkan Barcode',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          CustomButton(
            label: 'Tambah Barang',
            onPressed: () {
              String barcode = barcodeController.text;
              if (barcode.isNotEmpty) {
                addItem(barcode);
                barcodeController.clear();
              }
            },
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: scannedItems.length,
              itemBuilder: (context, index) {
                String barcode = scannedItems.keys.elementAt(index);
                Map<String, dynamic> item = scannedItems[barcode]!;
                return ListTile(
                  title: Text(item['nama']),
                  subtitle: Text('Harga: Rp ${item['harga']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove, color: Colors.red),
                        onPressed: () => removeItem(barcode),
                      ),
                      Text('${item['jumlah']}'),
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.green),
                        onPressed: () => addItem(barcode),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Total Barang:'), Text('$totalItems')],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Total Harga:'), Text('Rp $totalPrice')],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: scannedItems.isEmpty ? null : handlePayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Warna latar
                    foregroundColor: Colors.white, // Warna teks
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 32.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ), // Sudut melengkung
                    ),
                  ),
                  child: Text('Bayar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
