import 'package:flutter/material.dart';
import 'package:sisfo_mobile_brian/screens/main_page.dart';
import 'package:sisfo_mobile_brian/screens/peminjaman_page.dart';
import 'package:sisfo_mobile_brian/services/api_service.dart';

class PeminjamanForm extends StatefulWidget {
  final int id;

  const PeminjamanForm({super.key, required this.id});

  @override
  State<PeminjamanForm> createState() => _PeminjamanFormState();
}

class _PeminjamanFormState extends State<PeminjamanForm> {
  @override
  void initState() {
    super.initState();

  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController usedForController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  final TextEditingController dateBorrowedController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (picked != null) {
      controller.text = picked.toIso8601String().split("T")[0]; // format Y-m-d
    }
  }

  Future<void> handlePeminjaman() async {
    final amount = int.parse(amountController.text.trim());
    final usedFor = usedForController.text.trim();
    final clas = classController.text.trim();
    final dateBorrow = dateBorrowedController.text.trim();  // ✅ diperbaiki
    final dueDate = dueDateController.text.trim();   
    final idItems = widget.id;
    final ApiService api = ApiService();
    try{
      final result = await api.storePeminjaman(idItems, amount, usedFor, clas, dateBorrow, dueDate );
      final message = result['message'];

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainPage()),
      );

    }catch(e){
      print("Failed fetch data: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                "Form Peminjaman",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Jumlah'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Wajib diisi';
                  if (int.tryParse(value) == null || int.parse(value) < 1) {
                    return 'Jumlah minimal 1';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: usedForController,
                decoration: const InputDecoration(labelText: 'Digunakan Untuk'),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: classController,
                decoration: const InputDecoration(labelText: 'Kelas'),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: dateBorrowedController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Peminjaman',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context, dateBorrowedController),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: dueDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Kembali',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context, dueDateController),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              handlePeminjaman();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 37, 37, 37),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Pinjam", style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
