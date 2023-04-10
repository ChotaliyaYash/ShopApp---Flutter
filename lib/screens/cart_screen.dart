import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart_provider.dart' show CartProvider;
import 'package:shopapp/providers/order_provider.dart';
import 'package:shopapp/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static String routeName = '/cart-screen';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartItems = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: Column(
        children: <Widget>[
          // Card for a product summery
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '₹ ${cartItems.totalCartAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  OrderNowButton(
                    cartItems: cartItems,
                  )
                ],
              ),
            ),
          ),
          // Product summery
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.cartItem.length,
              itemBuilder: (context, index) {
                return CartItems(
                  id: cartItems.cartItem.values.toList()[index].id,
                  price: cartItems.cartItem.values.toList()[index].price,
                  quantity: cartItems.cartItem.values.toList()[index].quantity,
                  title: cartItems.cartItem.values.toList()[index].title,
                  productId: cartItems.cartItem.keys.toList()[index],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class OrderNowButton extends StatefulWidget {
  const OrderNowButton({
    super.key,
    required this.cartItems,
  });

  final CartProvider cartItems;

  @override
  State<OrderNowButton> createState() => _OrderNowButtonState();
}

class _OrderNowButtonState extends State<OrderNowButton> {
  //
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final scaffoldmessenger = ScaffoldMessenger.of(context);

    return TextButton(
      onPressed: (widget.cartItems.totalCartAmount <= 0 || isLoading)
          ? null
          : () async {
              try {
                setState(() {
                  isLoading = true;
                });
                await Provider.of<OrderProvider>(
                  context,
                  listen: false,
                ).addOrder(
                  widget.cartItems.totalCartAmount,
                  widget.cartItems.cartItem.values.toList(),
                );
                scaffoldmessenger.hideCurrentSnackBar();
                scaffoldmessenger.showSnackBar(
                  const SnackBar(
                    content: Text("Order placed successfully"),
                    backgroundColor: Colors.green,
                  ),
                );
                widget.cartItems.clear();
              } catch (e) {
                scaffoldmessenger.hideCurrentSnackBar();
                scaffoldmessenger.showSnackBar(
                  const SnackBar(
                    content: Text("Unable to place order, try again"),
                    backgroundColor: Colors.red,
                  ),
                );
              } finally {
                setState(() {
                  isLoading = false;
                });
              }
            },
      child: isLoading
          ? const CircularProgressIndicator()
          : const Text("ORDER NOW"),
    );
  }
}
