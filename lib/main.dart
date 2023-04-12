import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth_provider.dart';
import 'package:shopapp/providers/cart_provider.dart';
import 'package:shopapp/providers/order_provider.dart';
import 'package:shopapp/providers/product_provider.dart';
import 'package:shopapp/screens/auth_screen.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/screens/edit_product_screen.dart';
import 'package:shopapp/screens/home_screen.dart';
import 'package:shopapp/screens/orders_screen.dart';
import 'package:shopapp/screens/product_detail_screen.dart';
import 'package:shopapp/screens/user_product_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Multiple provider
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          update: (context, value, previous) => ProductsProvider(
            value.token,
            previous == null ? [] : previous.items,
          ),
          create: (_) => ProductsProvider(
            '',
            [],
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
          create: (_) => OrderProvider(
            '',
            [],
          ),
          update: (context, value, previous) => OrderProvider(
            value.token!,
            previous == null ? [] : previous.getOrder,
          ),
        )
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Shop App",
            theme: ThemeData(
              fontFamily: 'Lato',
              colorScheme: const ColorScheme.light(
                primary: Colors.purple,
                secondary: Colors.deepOrange,
              ),
            ),
            home: auth.isAuth ? const HomeScreen() : const AuthScreen(),
            routes: {
              HomeScreen.routeName: (context) => const HomeScreen(),
              ProductDetail.routeName: (context) => const ProductDetail(),
              CartScreen.routeName: (context) => const CartScreen(),
              OrderScreen.routeName: (context) => const OrderScreen(),
              UserProductScreen.routeName: (context) =>
                  const UserProductScreen(),
              EditProductScreen.routeName: (context) =>
                  const EditProductScreen(),
              AuthScreen.routeName: (context) => const AuthScreen(),
            },
          );
        },
      ),
    );
  }
}
