import 'package:e_store/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../section/sections.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      context.watch<ProductProvider>().url,
                      height: MediaQuery.of(context).size.height / 2,
                    ),
                    Text(
                      context.watch<ProductProvider>().name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      '${context.watch<ProductProvider>().qty} ${context.watch<ProductProvider>().qtyMeasure}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(context.watch<ProductProvider>().salePrice),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              context.watch<ProductProvider>().originalPrice,
                              style: TextStyle(
                                fontSize: 10,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.purple,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 5),
                                child: Text(
                                  '${context.watch<ProductProvider>().offer}% off',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.pink,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 22),
                            child: Text(
                              'Add',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ExpansionTile(
                      expandedAlignment: Alignment.centerLeft,
                      tilePadding: EdgeInsets.zero,
                      title: const Text(
                        'About product',
                        style: TextStyle(fontSize: 12),
                      ),
                      children: [
                        Text(context.watch<ProductProvider>().desc),
                      ],
                    ),
                  ],
                ),
              ),
              ScrollProductSection(
                color: Colors.green[50]!,
                name: context.watch<ProductProvider>().category,
                title: 'Similar products',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
