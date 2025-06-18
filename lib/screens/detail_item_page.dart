import 'package:flutter/material.dart';
import 'package:sisfo_mobile_brian/screens/peminjaman_form_page.dart';
import 'package:sisfo_mobile_brian/services/api_service.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DetailItemPage extends StatefulWidget {
  final int id;

  const DetailItemPage({super.key, required this.id});

  @override
  State<DetailItemPage> createState() => _DetailItemPageState();
}

class _DetailItemPageState extends State<DetailItemPage> {
  @override
  void initState() {
    super.initState();
    getItemById(widget.id);
  }

  Map<String, dynamic>? detailItems;
  final baseurl = "http://192.168.56.1:8000";

  Future<void> getItemById(int Id) async {
    try {
      final FetchItemByid = await ApiService().getItemById(Id);
      setState(() {
        detailItems = FetchItemByid;
      });
    } catch (e) {
      print("Failed fetch data: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'unused':
        return Colors.green;
      case 'good':
        return Colors.green;
      case 'used':
        return Colors.red;
      case 'broken':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:
          detailItems == null
              ? Center(
                child: LoadingAnimationWidget.halfTriangleDot(
                  color: Colors.black,
                  size: 50,
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.network(
                        "$baseurl/storage/${detailItems!['item_image'] ?? ''}",
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Icon(
                              Icons.broken_image,
                              size: 100,
                              color: Colors.grey,
                            ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${detailItems!['item_name'] ?? ''}",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            // status
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                  "${detailItems!['status'] ?? ''}",
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "${detailItems!['status'] ?? ''}",
                                style: TextStyle(
                                  color: _getStatusColor(
                                    "${detailItems!['status'] ?? ''}",
                                  ),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            // item condition
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                  "${detailItems!['item_condition'] ?? ''}",
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "${detailItems!['item_condition'] ?? ''}",
                                style: TextStyle(
                                  color: _getStatusColor(
                                    "${detailItems!['item_condition'] ?? ''}",
                                  ),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      "${detailItems!['brand'] ?? ''}",
                      style: TextStyle(color: Colors.black45, fontSize: 16),
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Kode item : ${detailItems!['code_item'] ?? ''}",
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Kategori : ${detailItems!['category'] ?? ''}",
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Tersedia : ${detailItems!['stock'] ?? ''}",
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  ],
                ),
              ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PeminjamanForm(id: detailItems!['id'])),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 37, 37, 37),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Ajukan Peminjaman", style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
