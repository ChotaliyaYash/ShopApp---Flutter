// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/modules/product.dart';
import 'package:shopapp/providers/product_provider.dart';

class ProductDetail extends StatelessWidget {
  static String routeName = "/product-details";
  const ProductDetail({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Getting product id
    String productId = ModalRoute.of(context)!.settings.arguments as String;
    // Getting the specific product details
    ////we puting listen as false because, we only want that the screen renders itself, if we click on the product from product items
    Product product = Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).productFindById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // Price
            Text(
              '₹ ${product.price}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // Description
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Text(
                product.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
