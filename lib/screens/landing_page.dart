import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sisfo_mobile_brian/components/bottom_navbar.dart';
import 'package:sisfo_mobile_brian/components/card.dart';
import 'package:sisfo_mobile_brian/screens/login_page.dart';
import 'package:sisfo_mobile_brian/screens/peminjaman_page.dart';
import 'package:sisfo_mobile_brian/screens/profile_page.dart';
import 'package:sisfo_mobile_brian/screens/riwayat_page.dart';
import 'package:sisfo_mobile_brian/services/api_service.dart';

String finalToken = "";

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  void initState() {
    super.initState();
    getAllItems();
  }
  @override
  List<Map<String, dynamic>> items = [];

  Future<void> getAllItems() async {
    try{
      final fetchedItems = await ApiService().getAllItem();
      setState(() {
        items = fetchedItems;
      });
    }catch(e) {
      print("Failed fetch data: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));

    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.account_circle_rounded, size: 40.0),
            SizedBox(width: 10.0),
            Text("Briantoro Falah", style: TextStyle(fontSize: 18.0)),
            Spacer(),
            IconButton(icon: Icon(Icons.logout), onPressed: logout),
          ],
        ),
      ),
      body: items.isEmpty ? Center(
                child: LoadingAnimationWidget.halfTriangleDot(
                  color: Colors.black,
                  size: 50,
                ),
              ) : SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome to the sisfo zetoonik mobile app",
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CarouselSlider(
              items: [
                Image.asset("assets/images/banner-1.jpg"),
                Image.asset("assets/images/banner-2.jpg"),
                Image.asset("assets/images/banner-3.jpg"),
              ],
              options: CarouselOptions(
                height: 180,
                enableInfiniteScroll: true,
                autoPlay: true,
                autoPlayCurve: Curves.bounceIn,
                autoPlayAnimationDuration: Duration(milliseconds: 300),
                viewportFraction: 1,
                enlargeCenterPage: true,
                animateToClosest: true,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return ItemCard(
                  imageUrl: item['item_image'],
                  title: item['item_name'],
                  stock: item['stock'],
                  status: item['status'],
                  id: item['id'],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
