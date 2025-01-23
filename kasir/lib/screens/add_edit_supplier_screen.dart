import 'package:flutter/material.dart';
import 'package:kasir/controller/supplier_controller.dart';
import 'package:kasir/widget/button.dart';
import 'package:kasir/widget/textField.dart';

class AddEditSupplierScreen extends StatefulWidget {
  final Map<String, dynamic>? data;

  AddEditSupplierScreen({this.data});

  @override
  _AddEditSupplierScreenState createState() => _AddEditSupplierScreenState();
}

class _AddEditSupplierScreenState extends State<AddEditSupplierScreen> {
  final TextEditingController idSupController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController nohpController = TextEditingController();

  final SupplierController supplierController = SupplierController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      idSupController.text = widget.data!['id_sup'].toString();
      namaController.text = widget.data!['nama'];
      alamatController.text = widget.data!['alamat'];
      nohpController.text = widget.data!['no_hp'];
    }
  }

  Future<void> saveData() async {
    setState(() {
      isLoading = true;
    });

    final data = {
      'id_sup': idSupController.text,
      'nama': namaController.text,
      'alamat': alamatController.text,
      'no_hp': nohpController.text,
    };

    try {
      if (widget.data == null) {
        // Tambah data baru
        await SupplierController.addSupplier(data);
      } else {
        // Edit data
        await SupplierController.updateSupplier(idSupController.text, data);
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
        title: Text(widget.data == null ? 'Tambah Supplier' : 'Edit Supplier'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              CustomTextField(
                controller: idSupController,
                label: 'Id Supplier',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Id Supplier tidak boleh kosong';
                  }
                  return null;
                },
                readOnly: widget.data != null, // Nonaktifkan input saat edit
              ),
              CustomTextField(
                controller: namaController,
                label: 'Nama Supplier',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Supplier tidak boleh kosong';
                  }
                  return null;
                },
              ),
              CustomTextField(
                controller: alamatController,
                label: 'Alamat Supplier',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat Supplier tidak boleh kosong';
                  }
                  return null;
                },
              ),
              CustomTextField(
                controller: nohpController,
                label: 'No HP Supplier',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor tidak boleh kosong';
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
