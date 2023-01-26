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
  String originalPrice;
  String salePrice;

  @override
  Widget build(BuildContext context) {
    final cp = Provider.of<CartProvider>(context);
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              cp.removeCart(context, prodDoc, count, int.parse(originalPrice),
                  int.parse(salePrice));
            },
            icon: const Icon(
              Icons.remove,
            ),
          ),
          Text(count.toString()),
          IconButton(
            onPressed: () async {
              cp.addToCart(
                  prodDoc, int.parse(originalPrice), int.parse(salePrice));
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
    );
  }
}
