import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorait;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorait = false,
  });

  void _setFavValue(bool newValue) {
    isFavorait = newValue;
    notifyListeners();
  }

  Future<void> toggleFavorait() async {
    final oldStatus = isFavorait;
    final url = Uri.parse(
        "https://shopapp-flutter-85c8e-default-rtdb.firebaseio.com/products/$id.json");
    isFavorait = !isFavorait;
    notifyListeners();
    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'isFavorait': isFavorait,
        }),
      );

      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (e) {
      _setFavValue(oldStatus);
    }
  }
}
