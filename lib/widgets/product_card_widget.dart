import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/providers/providers.dart';
import 'package:e_store/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/screens.dart';

class ProductCard extends StatelessWidget {
  ProductCard({Key? key, required this.documentSnapshot}) : super(key: key);

  DocumentSnapshot documentSnapshot;

  @override
  Widget build(BuildContext context) {
    final cp = Provider.of<CartProvider>(context);
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                ProductDetailScreen(documentSnapshot: documentSnapshot),
          ),
        );
      },
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: CachedNetworkImage(
                        placeholder: (context, url) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          );
                        },
                        imageUrl: documentSnapshot['url'],
                      ),
                    ),
                  ),
                  Text(
                    documentSnapshot['name'],
                    maxLines: 2,
                  ),
                  Text(
                    '${documentSnapshot['qty']} ${documentSnapshot['qtyMeasure']}',
                    style: const TextStyle(
                      fontSize: 11,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          documentSnapshot['originalPrice'] !=
                                  documentSnapshot['salePrice']
                              ? Text(
                                  '₹ ${documentSnapshot['originalPrice']}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey[700],
                                  ),
                                )
                              : const SizedBox.shrink(),
                          Text(
                            '₹ ${documentSnapshot['salePrice']}',
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (cp.cartItems.containsKey(documentSnapshot.id))
                    CounterWidget(
                      count: cp.cartItems[documentSnapshot.id],
                      prodDoc: documentSnapshot.id,
                      originalPrice: documentSnapshot['originalPrice'],
                      salePrice: documentSnapshot['salePrice'],
                    )
                  else
                    Align(
                        alignment: Alignment.center,
                        child: AddButton(documentSnapshot: documentSnapshot)),
                ],
              ),
              int.parse(documentSnapshot['offer']) > 0
                  ? Positioned(
                      top: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Colors.green[200],
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            '${documentSnapshot['offer']}%',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ))
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
