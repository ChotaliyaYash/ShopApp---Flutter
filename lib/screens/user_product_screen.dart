import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/product_provider.dart';
import 'package:shopapp/screens/edit_product_screen.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static String routeName = '/user-product-screen';
  const UserProductScreen({super.key});

  //
  Future<void> _refreshProduct(BuildContext context) async {
    Provider.of<ProductsProvider>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                EditProductScreen.routeName,
                arguments: ["Add Product"],
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: productData.items.isEmpty
          ? const Center(
              child: Text(
                "No producy added yet, Add Now!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
          : RefreshIndicator(
              onRefresh: () {
                return _refreshProduct(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: productData.items.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        UserProductItem(
                          title: productData.items[index].title,
                          imageUrl: productData.items[index].imageUrl,
                          productId: productData.items[index].id,
                        ),
                        const Divider()
                      ],
                    );
                  },
                ),
              ),
            ),
      drawer: const AppDrawer(),
    );
  }
}
