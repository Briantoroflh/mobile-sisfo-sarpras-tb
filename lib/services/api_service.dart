import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class ApiService {
  final baseurl = "http://192.168.56.1:8000/api";

  Future<dynamic> Login(String email, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.parse('$baseurl/login');
    var response = await http.post(
      url,
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'password': password},
    );
    var json = convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      await prefs.setString('token', json['token']);
      await prefs.setInt('id', json['data']['id_user']);
      return json;
    } else {
      String errorMessage = json['message'];
      throw Exception(errorMessage);
    }
  }

  Future<List<Map<String, dynamic>>> getAllItem() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var url = Uri.parse('$baseurl/items');
    var response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    var json = convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> items = List<Map<String, dynamic>>.from(
        json['data'],
      );
      return items;
    } else {
      String errorMessage = json['message'];
      throw Exception(errorMessage);
    }
  }

  Future<dynamic> getItemById(int Id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var url = Uri.parse('$baseurl/items/$Id');
    var response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    var json = convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      final itemsById = json['data'];
      return itemsById;
    } else {
      String errorMessage = json['message'];
      throw Exception(errorMessage);
    }
  }

  Future<dynamic> storePeminjaman(
    int idItem,
    int amountItem,
    String usedFor,
    String clas,
    String dateBorrowed,
    String dueDate,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var url = Uri.parse('$baseurl/borrowed');
    var response = await http.post(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {
        'id_items': idItem.toString(),
        'amount': amountItem.toString(),
        'used_for': usedFor,
        'class': clas,
        'date_borrowed': dateBorrowed,
        'due_date': dueDate,
      },
    );
    var json = convert.jsonDecode(response.body);
    if (response.statusCode == 201) {
      return json;
    } else {
      String errorMessage = json['message'];
      throw Exception(errorMessage);
    }
  }

  Future<List<Map<String, dynamic>>> getAllPeminjaman() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final id = prefs.getInt('id');
    final url = Uri.parse('$baseurl/borrowed/$id/user');
    var response = await http.get(url, 
      headers: {'Accept':'application/json', 'Authorization': 'Bearer $token'}
    );
    var json = convert.jsonDecode(response.body);
    if(response.statusCode == 200){
      final List<Map<String, dynamic>> items = List<Map<String, dynamic>>.from(
        json['data'],
      );
      return items;
    } else {
      String errorMessage = json['message'];
      throw Exception(errorMessage);
    }
  }

  Future<List<Map<String, dynamic>>> getAllPengembalian() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final id = prefs.getInt('id');
    final url = Uri.parse('$baseurl/return/$id/user');
    var response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    var json = convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> items = List<Map<String, dynamic>>.from(
        json['data'],
      );
      return items;
    } else {
      String errorMessage = json['message'];
      throw Exception(errorMessage);
    }
  }

  Future<dynamic> storePengembalian(
    int idBorrowed,
    String? image,
    String desc,
    String dateReturn
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.parse('$baseurl/return');
    var response = await http.post(url,
      headers: {'Accept':'application/json','Authorization':'Bearer $token'},
      body: {
        'id_borrowed': idBorrowed.toString(),
        'return_image' : image ?? '',
        'description': desc,
        'date_return': dateReturn
      }
    );
    var json = convert.jsonDecode(response.body);
    if(response.statusCode == 201){
      return json;
    } else {
      String errorMessage = json['message'];
      throw Exception(errorMessage);
    }
  }
}
