// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
  });
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _cartItem = {};

  Map<String, CartItem> get cartItem {
    return {..._cartItem};
  }

  int get cartCount {
    return _cartItem.length;
  }

  double get totalCartAmount {
    double total = 0;
    _cartItem.forEach((key, value) {
      total += value.quantity * value.price;
    });
    return total;
  }

  void addItem(
    String productId,
    String title,
    double price,
  ) {
    if (_cartItem.containsKey(productId)) {
      _cartItem.update(
        productId,
        (value) => CartItem(
          id: value.id,
          title: value.title,
          price: value.price,
          quantity: value.quantity + 1,
        ),
      );
    } else {
      _cartItem.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  // removeItem
  void removeItem(String id) {
    _cartItem.remove(id);
    notifyListeners();
  }

  // removeSingleItem using undo
  void removeSingleItem(String productId) {
    if (!_cartItem.containsKey(productId)) {
      return;
    }
    if (_cartItem[productId]!.quantity > 1) {
      _cartItem.update(
        productId,
        (value) => CartItem(
          id: value.id,
          title: value.title,
          price: value.price,
          quantity: value.quantity - 1,
        ),
      );
    } else {
      _cartItem.remove(productId);
    }
    notifyListeners();
  }

  // Clear cart
  void clear() {
    _cartItem = {};
    notifyListeners();
  }
}
