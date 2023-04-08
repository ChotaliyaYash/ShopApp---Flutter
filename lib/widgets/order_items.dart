import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopapp/providers/order_provider.dart';

class OrderItems extends StatefulWidget {
  final OrderItem orderItem;
  const OrderItems({
    super.key,
    required this.orderItem,
  });

  @override
  State<OrderItems> createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          // Main showable
          ListTile(
            title: Text('₹ ${widget.orderItem.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy-hh:mm').format(widget.orderItem.dateTime),
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              icon: Icon(
                _expanded ? Icons.expand_less : Icons.expand_more,
              ),
            ),
          ),
          //  show on expanded
          if (_expanded) const Divider(),
          if (_expanded)
            // ignore: sized_box_for_whitespace
            Container(
              height: min(widget.orderItem.products.length * 20 + 100, 180),
              child: ListView(
                children: widget.orderItem.products
                    .map(
                      (products) => ListTile(
                        title: Text(products.title),
                        subtitle:
                            Text('${products.quantity} x ₹ ${products.price}'),
                      ),
                    )
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
