import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sisfo_mobile_brian/components/card2.dart';
import 'package:sisfo_mobile_brian/services/api_service.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  @override
  void initState() {
    super.initState();
    getAllItems();
  }

  @override
  List<Map<String, dynamic>> items = [];

  Future<void> getAllItems() async {
    try {
      final fetchedItems = await ApiService().getAllPengembalian();
      setState(() {
        items = fetchedItems;
      });
    } catch (e) {
      print("Failed fetch data: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          items.isEmpty
              ? Center(
                child: LoadingAnimationWidget.halfTriangleDot(
                  color: Colors.black,
                  size: 50,
                ),
              )
              : SingleChildScrollView(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Halaman Pengembalian",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ProductCard(
                          imagePath: item['borrowed']['detailBorrow']['item']['item_image'],
                          title: item['borrowed']['detailBorrow']['item']['item_name'],
                          description: item['borrowed']['detailBorrow']['noted'],
                          status: item['status'],
                          id: item['id'],
                          btnText: "hehe",
                          showButton: false,
                        );
                      },
                    ),
                  ],
                ),
              ),
    );
  }
}