// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:shopapp/modules/product.dart';

// ChnageNotifier is to use enable behind the seens context management
class ProductsProvider with ChangeNotifier {
  // product list
  List<Product> _productsItem = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

// products copy send to other
  List<Product> get items {
    return [..._productsItem];
    // sending the copy of the item
  }

  List<Product> get favoritesItems {
    return _productsItem.where((element) => element.isFavorait).toList();
  }

  // Product find by id
  Product productFindById(String id) {
    return _productsItem.firstWhere((product) => product.id == id);
  }

  void addProduct(Product product) {
    final newProduct = Product(
      id: DateTime.now().toString(),
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    );
    _productsItem.add(newProduct);
    notifyListeners();
  }

  void updateProduct(String productId, Product product) {
    final prodIndex =
        _productsItem.indexWhere((element) => element.id == productId);
    if (prodIndex >= 0) {
      _productsItem[prodIndex] = product;
      notifyListeners();
    } else {
      return;
    }
  }

  void deleteProduct(String productId) {
    _productsItem.removeWhere((element) => element.id == productId);
    notifyListeners();
  }
}
