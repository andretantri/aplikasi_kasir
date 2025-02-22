# Aplikasi Kasir

Aplikasi Kasir adalah aplikasi yang dirancang untuk membantu proses penjualan barang dengan fitur-fitur sederhana seperti menambahkan barang, menghitung total harga, menyimpan transaksi, dan melihat riwayat transaksi.

## Fitur Utama

1. **Transaksi Penjualan**
   - Menambahkan barang ke daftar belanjaan secara manual dengan memasukkan nomor barcode.
   - Menghitung total harga barang secara otomatis.
   - Menyimpan transaksi dengan nomor nota unik.

2. **Riwayat Transaksi**
   - Menampilkan daftar riwayat transaksi yang telah dilakukan.
   - Setiap transaksi menampilkan nomor invoice beserta daftar barang dan jumlahnya.

3. **Manajemen Barang**
   - Daftar barang yang tersedia lengkap dengan informasi nama, harga, dan stok barang.

## Teknologi yang Digunakan

- **Frontend**: Flutter
- **Backend API**: Node.js dengan Express
- **Database**: MySQL

## Persyaratan Sistem

- Flutter SDK
- Node.js
- MySQL

## Cara Instalasi

### 1. Clone Repository
```bash
git clone https://github.com/andretantri/aplikasi_kasir.git
cd cashier-app
```

### 2. Setup Backend
1. Pindah ke direktori backend:
   ```bash
   cd backend
   ```
2. Install dependensi:
   ```bash
   npm install
   ```
3. Buat file `.env` dan sesuaikan konfigurasi database:
   ```env
   DB_HOST=localhost
   DB_USER=root
   DB_PASSWORD=yourpassword
   DB_NAME=cashier_db
   ```
4. Jalankan server backend:
   ```bash
   node server.js
   ```

### 3. Setup Frontend
1. Pindah ke direktori aplikasi Flutter:
   ```bash
   cd ../frontend
   ```
2. Install dependensi Flutter:
   ```bash
   flutter pub get
   ```
3. Jalankan aplikasi di emulator atau perangkat fisik:
   ```bash
   flutter run
   ```

## Cara Build APK

1. Jalankan perintah berikut untuk membuat file APK:
   ```bash
   flutter build apk --release
   ```
2. File APK akan tersedia di direktori `build/app/outputs/flutter-apk/app-release.apk`.

## Cara Menambahkan Ikon Aplikasi

1. Ganti ikon aplikasi dengan format `.png` atau `.webp` menggunakan plugin [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons).
2. Tambahkan konfigurasi berikut pada file `pubspec.yaml`:
   ```yaml
   dev_dependencies:
     flutter_launcher_icons: ^0.10.0

   flutter_icons:
     android: true
     ios: true
     image_path: "assets/icon/app_icon.png"
   ```
3. Jalankan perintah berikut:
   ```bash
   flutter pub run flutter_launcher_icons:main
   ```
## BUG
-- Auto Refresh Setelah Edit Barang & Supplier

## Catatan Tambahan

- Pastikan server backend berjalan sebelum mengakses aplikasi.
- Jika ada error, cek kembali konfigurasi database atau koneksi backend.

## Lisensi

Aplikasi ini dibuat untuk keperluan pembelajaran dan pengembangan. Lisensi bebas untuk dimodifikasi dan digunakan.

---

Terima kasih telah menggunakan Aplikasi Kasir!

