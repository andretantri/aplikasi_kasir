// dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'detail_barang_screen.dart';
import 'package:kasir/controller/barang_controller.dart'; // Import BarangController

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final BarangController barangController =
      BarangController(); // Create an instance of BarangController

  // Dummy image URLs for the carousel slider
  final List<String> sliderImages = [
    'https://img.freepik.com/free-vector/mineral-water-bottle-ad-banner-flask-with-drink_107791-2565.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQqKsktUmRKQ-hyuTjzUtF-BaD33VlLvDV66QzO_jvomJPXX2sxPvu6KtSKHRMRM2OBbak&usqp=CAU',
    'https://img.freepik.com/premium-vector/man-drinking-water_118813-8702.jpg?semt=ais_hybrid',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),

            // Slider
            CarouselSlider(
              options: CarouselOptions(
                height: 200.0, // Fixed height for the slider
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction:
                    1.5, // This will make the slider items appear wider by stretching their width
              ),
              items:
                  sliderImages.map((imageUrl) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width:
                              MediaQuery.of(context).size.width *
                              1.5, // Increase the width of the slider
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                8.0,
                              ), // Optional: to add rounded corners
                              child: Image.network(
                                imageUrl,
                                fit:
                                    BoxFit
                                        .cover, // Ensures image is cropped and fills the container
                                height:
                                    200.0, // Set a fixed height for the image
                                width:
                                    MediaQuery.of(context).size.width *
                                    0.9, // Adjust the image width based on the container
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
            ),

            const SizedBox(height: 20),

            // Card Barang (Fetch from API)
            FutureBuilder<List<Map<String, dynamic>>>(
              future:
                  barangController
                      .fetchBarang(), // Use the instance to fetch data
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Tidak ada barang'));
                } else {
                  final barang = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          barang.length, // Jumlah card berdasarkan data barang
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 3 / 2,
                          ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // Navigasi ke halaman detail barang
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => DetailBarangScreen(
                                      namaBarang: barang[index]['nama'],
                                      hargaBarang: barang[index]['harga'],
                                      stokBarang: barang[index]['stok'],
                                    ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 3,
                            child: Center(child: Text(barang[index]['nama'])),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
