import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shopapp/modules/product.dart';
import 'package:shopapp/providers/cart_provider.dart';
import 'package:shopapp/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<CartProvider>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
            // style: TextStyle(fontSize: 20),
          ),
          // Cart
          trailing: IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              size: 20,
            ),
            onPressed: () {
              cart.addItem(
                product.id,
                product.title,
                product.price,
              );
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Added item to cart"),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: "UNDO",
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).colorScheme.secondary,
          ),
          // Favourates
          leading: Consumer<Product>(
            builder: (ctx, value, _) {
              return IconButton(
                icon: Icon(
                  value.isFavorait ? Icons.favorite : Icons.favorite_border,
                ),
                onPressed: value.toggleFavorait,
                color: Theme.of(context).colorScheme.secondary,
              );
            },
          ),
        ),

        // Image
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetail.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
