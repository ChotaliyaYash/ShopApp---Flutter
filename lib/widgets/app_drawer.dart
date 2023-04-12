import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth_provider.dart';
import 'package:shopapp/screens/home_screen.dart';
import 'package:shopapp/screens/orders_screen.dart';
import 'package:shopapp/screens/user_product_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text("Hello Friends!"),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          // shop
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            },
          ),
          const Divider(),
          // Orders
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Orders'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            },
          ),
          const Divider(),

          // user product screen
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Manage Products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductScreen.routeName);
            },
          ),
          const Divider(),

          // user product screen
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
