import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sisfo_mobile_brian/components/card.dart';
import 'package:sisfo_mobile_brian/components/card2.dart';
import 'package:sisfo_mobile_brian/screens/pengembalian_form_page.dart';
import 'package:sisfo_mobile_brian/services/api_service.dart';

class PeminjamanPage extends StatefulWidget {
  const PeminjamanPage({super.key});

  @override
  State<PeminjamanPage> createState() => _PeminjamanPageState();
}

class _PeminjamanPageState extends State<PeminjamanPage> {
  @override
  void initState() {
    super.initState();
    getAllItems();
  }
  @override
  List<Map<String, dynamic>> items = [];

  Future<void> getAllItems() async {
    try{
      final fetchedItems = await ApiService().getAllPeminjaman();
      setState(() {
        items = fetchedItems;
      });
    }catch(e) {
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
                    Text("Halaman Peminjaman", style:  TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),),
                    SizedBox(height: 20,),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final status = item['status'];
                        final showButton = status == 'approved';
                        return ProductCard(
                         imagePath: item['detailBorrow']['item']['item_image'],
                          title: item['detailBorrow']['item']['item_name'],
                          description: item['detailBorrow']['noted'],
                          status: item['status'],
                          id: item['id'],
                          btnText: "Balikin",
                          showButton: showButton,
                          onButtonPressed: (context, id) => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ReturnFormPage(idBorrowed: id),
                              ),
                            )
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
    );
  }
}