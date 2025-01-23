import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label; // Label tombol
  final VoidCallback onPressed; // Aksi ketika tombol ditekan
  final Color backgroundColor; // Warna latar tombol
  final Color textColor; // Warna teks tombol

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = Colors.green, // Default warna hijau
    this.textColor = Colors.white, // Default warna teks putih
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor, // Warna latar
        foregroundColor: textColor, // Warna teks
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Sudut melengkung
        ),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
      ),
    );
  }
}
