import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/order_provider.dart' show OrderProvider;
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/order_items.dart';

class OrderScreen extends StatelessWidget {
  static String routeName = '/orders';
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
      ),
      body: orderData.getOrder.isEmpty
          ? const Center(
              child: Text(
                "You has not orderes anything yet!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ListView.builder(
              itemCount: orderData.getOrder.length,
              itemBuilder: (context, index) {
                return OrderItems(
                  orderItem: orderData.getOrder[index],
                );
              },
            ),
      drawer: const AppDrawer(),
    );
  }
}
