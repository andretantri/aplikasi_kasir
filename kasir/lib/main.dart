import 'package:flutter/material.dart';
import 'package:kasir/screens/list_supplier_screen.dart';
import 'package:kasir/screens/penjualan_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/list_barang_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kasir Flutter',
      theme: ThemeData(primarySwatch: Colors.green),
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    DashboardScreen(),
    ListBarangScreen(),
    ListSupplierScreen(),
    PenjualanScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Barang'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Supplier'),
          BottomNavigationBarItem(
            icon: Icon(Icons.trolley),
            label: 'Penjualan',
          ),
        ],
        selectedItemColor: Colors.green, // Color for the selected item
        unselectedItemColor: Colors.grey, // Color for unselected items
        backgroundColor: Colors.white, // Background color of the navigation bar
      ),
    );
  }
}
