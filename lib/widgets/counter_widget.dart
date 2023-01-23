import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';

class CounterWidget extends StatelessWidget {
  CounterWidget({
    Key? key,
    required this.count,
    required this.prodDoc,
    required this.originalPrice,
    required this.salePrice,
  }) : super(key: key);

  int count;
  String prodDoc;
  int originalPrice;
  int salePrice;

  @override
  Widget build(BuildContext context) {
    final cp = Provider.of<CartProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            cp.removeCart(context, prodDoc, count, originalPrice, salePrice);
            // cp.reducePrice(originalPrice, salePrice);
          },
          icon: const Icon(
            Icons.remove,
          ),
        ),
        Text(count.toString()),
        IconButton(
          onPressed: () async {
            cp.addToCart(prodDoc, originalPrice, salePrice);
            // cp.addPrice(originalPrice, salePrice);
          },
          icon: const Icon(
            Icons.add,
          ),
        ),
      ],
    );
  }
}
