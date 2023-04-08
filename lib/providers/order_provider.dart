// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:shopapp/providers/cart_provider.dart';

class OrderItem {
  final String id;
  final List<CartItem> products;
  final double amount;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.products,
    required this.amount,
    required this.dateTime,
  });
}

class OrderProvider with ChangeNotifier {
  List<OrderItem> _orderItems = [];

  List<OrderItem> get getOrder {
    return [..._orderItems];
  }

  void addOrder(
    double amount,
    List<CartItem> products,
  ) {
    _orderItems.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        products: products,
        amount: amount,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
