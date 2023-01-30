import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/providers/providers.dart';
import 'package:e_store/widgets/counter_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../section/sections.dart';

class ProductDetailScreen extends StatelessWidget {
  ProductDetailScreen({super.key, required this.documentSnapshot});

  DocumentSnapshot documentSnapshot;

  @override
  Widget build(BuildContext context) {
    final cp = Provider.of<CartProvider>(context);
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
                    CachedNetworkImage(
                      imageUrl: documentSnapshot['url'],
                      height: MediaQuery.of(context).size.height / 2,
                    ),
                    Text(
                      documentSnapshot['name'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      '${documentSnapshot['qty']} ${documentSnapshot['qtyMeasure']}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        documentSnapshot['originalPrice'] !=
                                documentSnapshot['salePrice']
                            ? Row(
                                children: [
                                  Text(documentSnapshot['salePrice']),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    documentSnapshot['originalPrice'],
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
                                        '${documentSnapshot['offer']}% off',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Text(documentSnapshot['salePrice']),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () => cp.addProduct(documentSnapshot, context),
                          child: cp.cartItems.containsKey(documentSnapshot.id)
                              ? CounterWidget(
                                  count: cp.cartItems[documentSnapshot.id],
                                  prodDoc: documentSnapshot.id,
                                  originalPrice:
                                      documentSnapshot['originalPrice'],
                                  salePrice: documentSnapshot['salePrice'],
                                )
                              : DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.pink,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 22),
                                    child: Text(
                                      'Add',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
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
                        Text(documentSnapshot['desc']),
                      ],
                    ),
                  ],
                ),
              ),
              ScrollProductSection(
                color: Colors.green[50]!,
                name: documentSnapshot['categories'][0],
                title: 'Similar products',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
