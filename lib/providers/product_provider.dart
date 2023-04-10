// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopapp/modules/http_exceptions.dart';
import 'package:shopapp/modules/product.dart';
import 'package:http/http.dart' as http;
import 'package:shopapp/urls/url.dart';

// ChnageNotifier is to use enable behind the seens context management
class ProductsProvider with ChangeNotifier {
  // product list
  List<Product> _productsItem = [];

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

  // fetch product
  Future<void> fetchAndSetProducts() async {
    // Http request
    final url = Uri.parse("${URL.url}/products.json");
    try {
      final response = await http.get(url);
      if (response.body == 'null') {
        return;
      }
      final List<Product> loadedProduct = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((productId, productData) {
        loadedProduct.add(
          Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavorait: productData['isFavorait'],
          ),
        );
      });
      _productsItem = loadedProduct;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

// add product
  Future<void> addProduct(Product product) async {
    // Http request
    final url = Uri.parse("${URL.url}/products.json");
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            "title": product.title,
            "price": product.price,
            "description": product.description,
            "imageUrl": product.imageUrl,
            "isFavorait": product.isFavorait
          },
        ),
      );
      // local storage
      final newProduct = Product(
        id: json.decode(response.body)["name"],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _productsItem.add(newProduct);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // update Products
  Future<void> updateProduct(String productId, Product product) async {
    final prodIndex =
        _productsItem.indexWhere((element) => element.id == productId);
    if (prodIndex >= 0) {
      // Http request
      final url = Uri.parse("${URL.url}/products/$productId.json");
      try {
        await http.patch(
          url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          }),
        );
      } catch (e) {
        rethrow;
      }
      _productsItem[prodIndex] = product;
      notifyListeners();
    } else {
      return;
    }
  }

  Future<void> deleteProduct(String productId) async {
    // Http request
    final url = Uri.parse("${URL.url}/products/$productId.json");
    final existingProductIndex =
        _productsItem.indexWhere((element) => element.id == productId);
    Product? existingProduct = _productsItem[existingProductIndex];
    _productsItem.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _productsItem.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HTTPExceprion('Could not delete product');
    }
    existingProduct = null;
  }
}
