import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';

class CounterWidget extends StatelessWidget {
  CounterWidget({Key? key, required this.count, required this.prodDoc})
      : super(key: key);

  int count;
  String prodDoc;

  @override
  Widget build(BuildContext context) {
    final cp = Provider.of<CartProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            cp.removeCart(context, prodDoc, count);
          },
          icon: const Icon(
            Icons.remove,
          ),
        ),
        Text(count.toString()),
        IconButton(
          onPressed: () {
            cp.addToCart(context, prodDoc);
          },
          icon: const Icon(
            Icons.add,
          ),
        ),
      ],
    );
  }
}
