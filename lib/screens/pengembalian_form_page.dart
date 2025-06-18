import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sisfo_mobile_brian/screens/main_page.dart';
import 'package:sisfo_mobile_brian/services/api_service.dart';

class ReturnFormPage extends StatefulWidget {
  final int idBorrowed;
  const ReturnFormPage({Key? key, required this.idBorrowed}) : super(key: key);

  @override
  State<ReturnFormPage> createState() => _ReturnFormPageState();
}

class _ReturnFormPageState extends State<ReturnFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController dateReturnController = TextEditingController();
  File? _selectedImageFile; // For Android/iOS
  Uint8List? _selectedImageBytes; // For Web

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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
          _selectedImageFile = null;
        });
      } else {
        setState(() {
          _selectedImageFile = File(pickedFile.path);
          _selectedImageBytes = null;
        });
      }
    }
  }

  Widget _buildImagePreview() {
    if (kIsWeb && _selectedImageBytes != null) {
      return Image.memory(
        _selectedImageBytes!,
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      );
    } else if (_selectedImageFile != null) {
      return Image.file(
        _selectedImageFile!,
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      );
    } else {
      return Text("Belum ada gambar yang dipilih.");
    }
  }

  Future<void> _submit() async {
    final desc = _descriptionController.text.trim();
    final date = dateReturnController.text.trim();
    if (date.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tanggal pengembalian wajib diisi!')),
      );
      return;
    }

    String? itemImagePath;
    if (!kIsWeb) {
      itemImagePath = _selectedImageFile?.path;
    }
    final ApiService api = ApiService();
    try {
      final result = await api.storePengembalian(
        widget.idBorrowed,
        itemImagePath,
        desc,
        date,
      );
      final message = result['message'] ?? 'Pengembalian berhasil!';

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainPage()),
      );
    } catch (e) {
      print("Failed fetch data: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Form Pengembalian')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Deskripsi Pengembalian",
                  border: OutlineInputBorder(),
                ),
                validator:
                    (val) =>
                        val == null || val.isEmpty
                            ? "Deskripsi wajib diisi"
                            : null,
                maxLines: 3,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: dateReturnController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Pengembalian',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context, dateReturnController),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              SizedBox(height: 16),
              Text(
                "Item Image (Opsional)",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _buildImagePreview(),
              SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.photo),
                label: Text("Pilih Gambar dari Galeri"),
              ),
              SizedBox(height: 24),
              ElevatedButton(onPressed: _submit, child: Text('Kirim')),
            ],
          ),
        ),
      ),
    );
  }
}
