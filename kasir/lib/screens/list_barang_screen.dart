import 'package:flutter/material.dart';
import 'package:kasir/controller/barang_controller.dart';
import 'add_edit_barang_screen.dart';

class ListBarangScreen extends StatefulWidget {
  @override
  _ListBarangScreenState createState() => _ListBarangScreenState();
}

class _ListBarangScreenState extends State<ListBarangScreen> {
  List<Map<String, dynamic>> barang = [];
  final BarangController barangController = BarangController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBarang();
  }

  Future<void> fetchBarang() async {
    try {
      final data = await barangController.fetchBarang();
      setState(() {
        barang = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showError(e.toString());
    }
  }

  void deleteBarang(String noBarcode) async {
    try {
      await barangController.deleteBarang(noBarcode);
      setState(() {
        barang.removeWhere((item) => item['no_barcode'] == noBarcode);
      });
    } catch (e) {
      showError(e.toString());
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Barang'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              fetchBarang();
            },
          ),
        ],
      ),
      body:
          isLoading
              ? Center(
                child:
                    CircularProgressIndicator(), // Menampilkan indikator loading
              )
              : barang.isEmpty
              ? Center(
                child: Text('Belum ada Data Barang'), // Jika data kosong
              )
              : RefreshIndicator(
                onRefresh: fetchBarang,
                child: ListView.builder(
                  itemCount: barang.length,
                  itemBuilder: (context, index) {
                    final item = barang[index];
                    return ListTile(
                      title: Text('${item['no_barcode']}: ${item['nama']}'),
                      subtitle: Text(
                        'Harga: ${item['harga']} | Stok: ${item['stok']}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          AddEditBarangScreen(data: item),
                                ),
                              );
                              if (result != null) {
                                setState(() {
                                  barang[index] = result;
                                });
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => deleteBarang(item['no_barcode']),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman tambah supplier
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditBarangScreen()),
          );
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add), // Ikon FAB
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
