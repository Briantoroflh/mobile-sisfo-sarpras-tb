import 'package:flutter/material.dart';
import 'package:sisfo_mobile_brian/components/bottom_navbar.dart';
import 'package:sisfo_mobile_brian/screens/landing_page.dart';
import 'package:sisfo_mobile_brian/screens/peminjaman_page.dart';
import 'package:sisfo_mobile_brian/screens/profile_page.dart';
import 'package:sisfo_mobile_brian/screens/riwayat_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override

  int _currentIndex = 0;

  final List<Widget> _pages = [
    LandingPage(),
    PeminjamanPage(),
    RiwayatPage()
  ];

  final List<BottomNavBarItem> navItems = [
    BottomNavBarItem(icon: Icons.home, label: 'Beranda'),
    BottomNavBarItem(icon: Icons.arrow_upward, label: 'Peminjaman'),
    BottomNavBarItem(icon: Icons.arrow_downward, label: 'Pengembalian'),
  ];
  Widget build(BuildContext context) {
     return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: navItems,
      ),
    );
  }
}