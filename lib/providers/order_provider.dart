// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shopapp/providers/cart_provider.dart';
import 'package:shopapp/urls/url.dart';

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
  final String authToken;

  OrderProvider(this.authToken, this._orderItems);

  List<OrderItem> _orderItems = [];

  List<OrderItem> get getOrder {
    return [..._orderItems];
  }

// fatch orders
  Future<void> fatchAndSetOrders() async {
    final url = Uri.parse("${URL.url}/orders.json?auth=$authToken");
    try {
      final response = await http.get(url);
      if (response.body == 'null') {
        return;
      }
      final List<OrderItem> loadedOrder = [];
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      extractData.forEach((orderId, orderData) {
        loadedOrder.add(
          OrderItem(
            id: orderId,
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (e) => CartItem(
                    id: e['id'],
                    title: e['title'],
                    price: e['price'],
                    quantity: e['quantity'],
                  ),
                )
                .toList(),
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
          ),
        );
      });
      _orderItems = loadedOrder.reversed.toList();
      notifyListeners();
    } catch (e) {
      // debugPrint(e.toString());
      rethrow;
    }
  }

// Add order
  Future<void> addOrder(
    double amount,
    List<CartItem> products,
  ) async {
    final url = Uri.parse("${URL.url}/orders.json?auth=$authToken");
    final timestamp = DateTime.now();
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'amount': amount,
          'dateTime': timestamp.toIso8601String(),
          'products': products
              .map((cartProduct) => {
                    'id': cartProduct.id,
                    'title': cartProduct.title,
                    'quantity': cartProduct.quantity,
                    'price': cartProduct.price,
                  })
              .toList(),
        }),
      );
      _orderItems.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          products: products,
          amount: amount,
          dateTime: timestamp,
        ),
      );
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
