import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/order_provider.dart' show OrderProvider;
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/order_items.dart';

class OrderScreen extends StatelessWidget {
  static String routeName = '/orders';
  const OrderScreen({super.key});

  Future<void> _refreshProduct(BuildContext context) async {
    Provider.of<OrderProvider>(context, listen: false).fatchAndSetOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
      ),
      body: FutureBuilder(
          future: Provider.of<OrderProvider>(context, listen: false)
              .fatchAndSetOrders(),
          builder: (context, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (dataSnapshot.error == null) {
              return Consumer<OrderProvider>(
                builder: (context, value, child) => RefreshIndicator(
                  onRefresh: () => _refreshProduct(context),
                  child: ListView.builder(
                    itemCount: value.getOrder.length,
                    itemBuilder: (context, index) {
                      return OrderItems(
                        orderItem: value.getOrder[index],
                      );
                    },
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text("An error occurred!"),
              );
            }
          }),
      drawer: const AppDrawer(),
    );
  }
}
