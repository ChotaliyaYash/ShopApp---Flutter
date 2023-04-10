// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart_provider.dart';
import 'package:shopapp/providers/product_provider.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/screens/product_overview_screen.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/badge.dart';

enum FilterOption {
  Favorites,
  All,
}

class HomeScreen extends StatefulWidget {
  static String routeName = '/';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showOnlyFavourites = false;

  // isInit
  bool isInit = true;
  // loading
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    if (isInit) {
      fatchData();
    }
    isInit = false;
    super.didChangeDependencies();
  }

  Future<void> fatchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<ProductsProvider>(context).fetchAndSetProducts();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to load data, please try again"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop App"),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOption value) {
              setState(() {
                if (value == FilterOption.Favorites) {
                  _showOnlyFavourites = true;
                } else {
                  _showOnlyFavourites = false;
                }
              });
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOption.Favorites,
                child: Text("Only Favorites"),
              ),
              const PopupMenuItem(
                value: FilterOption.All,
                child: Text("Show all"),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
          // Badge
          Consumer<CartProvider>(
            builder: (_, value, child) => Badges(
              value: value.cartCount.toString(),
              child: child!,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  CartScreen.routeName,
                );
              },
            ),
          )
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductOverviewScreen(showFavorites: _showOnlyFavourites),
      drawer: const AppDrawer(),
    );
  }
}
