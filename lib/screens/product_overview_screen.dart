import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/modules/product.dart';
import 'package:shopapp/providers/product_provider.dart';
import 'package:shopapp/widgets/product_item.dart';

class ProductOverviewScreen extends StatelessWidget {
  final bool showFavorites;
  const ProductOverviewScreen({
    super.key,
    required this.showFavorites,
  });

  @override
  Widget build(BuildContext context) {
    // provider setoff // fatching only the products of an productsProvider context
    final productData = Provider.of<ProductsProvider>(context);
    List<Product> products =
        showFavorites ? productData.favoritesItems : productData.items;

    return products.isEmpty
        ? const Center(
            child: Text(
              "No Item to display",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1.5,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              // If we dont want to use context, then we can also use this
              return ChangeNotifierProvider.value(
                value: products[index],
                child: const ProductItem(),
              );
            },
          );
  }
}
