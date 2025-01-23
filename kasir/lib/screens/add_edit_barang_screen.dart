import 'package:flutter/material.dart';
import 'package:kasir/controller/barang_controller.dart';
import 'package:kasir/widget/button.dart';
import 'package:kasir/widget/textField.dart';

class AddEditBarangScreen extends StatefulWidget {
  final Map<String, dynamic>? data;

  AddEditBarangScreen({this.data});

  @override
  _AddEditBarangScreenState createState() => _AddEditBarangScreenState();
}

class _AddEditBarangScreenState extends State<AddEditBarangScreen> {
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController stokController = TextEditingController();

  final BarangController barangController = BarangController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      barcodeController.text = widget.data!['no_barcode'];
      namaController.text = widget.data!['nama'];
      hargaController.text = widget.data!['harga'].toString();
      stokController.text = widget.data!['stok'].toString();
    }
  }

  Future<void> saveData() async {
    setState(() {
      isLoading = true;
    });

    final data = {
      'no_barcode': barcodeController.text,
      'nama': namaController.text,
      'harga': int.tryParse(hargaController.text) ?? 0,
      'stok': int.tryParse(stokController.text) ?? 0,
    };

    try {
      if (widget.data == null) {
        // Tambah data baru
        await BarangController.addBarang(data);
      } else {
        // Edit data
        await BarangController.updateBarang(barcodeController.text, data);
      }
      Navigator.pop(context, true); // Berhasil, kembali ke list
    } catch (e) {
      showError('Terjadi kesalahan: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data == null ? 'Tambah Barang' : 'Edit Barang'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              CustomTextField(
                controller: barcodeController,
                label: 'No Barcode',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Barcode tidak boleh kosong';
                  }
                  return null;
                },
                readOnly: widget.data != null, // Nonaktifkan input saat edit
              ),
              CustomTextField(
                controller: namaController,
                label: 'Nama',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              CustomTextField(
                controller: hargaController,
                label: 'Harga',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Harga harus berupa angka';
                  }
                  return null;
                },
              ),
              CustomTextField(
                controller: stokController,
                label: 'Stok',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stok tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Stok harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(label: 'Simpan', onPressed: saveData),
            ],
          ),
        ),
      ),
    );
  }
}
