import 'package:flutter/material.dart';
import 'package:kasir/controller/supplier_controller.dart';
import 'add_edit_supplier_screen.dart';

class ListSupplierScreen extends StatefulWidget {
  @override
  _ListSupplierScreenState createState() => _ListSupplierScreenState();
}

class _ListSupplierScreenState extends State<ListSupplierScreen> {
  List<Map<String, dynamic>> supplier = [];

  final SupplierController supplierController = SupplierController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSupplier();
  }

  Future<void> fetchSupplier() async {
    try {
      final data = await supplierController.fetchSupplier();
      setState(() {
        supplier = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showError(e.toString());
    }
  }

  void deleteSupplier(String idSup) async {
    try {
      await supplierController.deleteSupplier(idSup);
      setState(() {
        supplier.removeWhere((item) => item['id_sup'] == idSup);
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
        title: Text('Data Supplier'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              fetchSupplier();
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
              : supplier.isEmpty
              ? Center(
                child: Text('Belum ada Data Supplier'), // Jika data kosong
              )
              : RefreshIndicator(
                onRefresh: fetchSupplier,
                child: ListView.builder(
                  itemCount: supplier.length,
                  itemBuilder: (context, index) {
                    final item = supplier[index];
                    return ListTile(
                      title: Text(item['nama']),
                      subtitle: Text(
                        'ID: ${item['id_sup']} | No HP: ${item['no_hp']}',
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
                                          AddEditSupplierScreen(data: item),
                                ),
                              );
                              if (result != null) {
                                setState(() {
                                  supplier[index] = result;
                                });
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed:
                                () => deleteSupplier(item['id_sup'].toString()),
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
            MaterialPageRoute(builder: (context) => AddEditSupplierScreen()),
          );
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add), // Ikon FAB
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
