import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/model/cart_product_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../screens/screens.dart';

class ScrollProductSection extends StatefulWidget {
  ScrollProductSection({
    Key? key,
    this.name = '',
    required this.title,
    required this.color,
  }) : super(key: key);

  final String name;
  final String title;
  final Color color;

  @override
  State<ScrollProductSection> createState() => _ScrollProductSectionState();
}

class _ScrollProductSectionState extends State<ScrollProductSection> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> products;

  @override
  void initState() {
    if (widget.name != '') {
      products = FirebaseFirestore.instance
          .collection('products')
          .where('categories', arrayContains: widget.name)
          .snapshots();
    } else {
      products = FirebaseFirestore.instance
          .collection('products')
          .orderBy('created', descending: true)
          .snapshots();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cp = Provider.of<CartProvider>(context, listen: false);
    return Container(
      height: 250,
      color: widget.color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 180,
            width: double.infinity,
            child: StreamBuilder(
                stream: products,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState ==
                          ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Something got error'),
                      );
                    } else if (snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('No products'),
                      );
                    } else if (snapshot.hasData) {
                      return ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            width: 15,
                          );
                        },
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length + 1 <= 10
                            ? snapshot.data!.docs.length + 1
                            : 10,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return const SizedBox(
                              width: 10,
                            );
                          } else {
                            DocumentSnapshot documentSnapshot =
                                snapshot.data!.docs[index - 1];
                            return InkWell(
                              onTap: () async {
                                await context
                                    .read<ProductProvider>()
                                    .showProduct(documentSnapshot.id, context);

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: Image.network(
                                                    documentSnapshot['url'])),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    documentSnapshot[
                                                        'originalPrice'],
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                  Text(
                                                    documentSnapshot[
                                                        'salePrice'],
                                                  ),
                                                ],
                                              ),
                                              DecoratedBox(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey[500]!,
                                                      offset: Offset(4, 4),
                                                      blurRadius: 20,
                                                      spreadRadius: 1,
                                                    ),
                                                    const BoxShadow(
                                                      color: Colors.white,
                                                      offset: Offset(-4, -4),
                                                      blurRadius: 20,
                                                      spreadRadius: 1,
                                                    ),
                                                  ],
                                                ),
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.add,
                                                    color: Colors.pink,
                                                  ),
                                                  onPressed: () {
                                                    cp.addProduct(
                                                        documentSnapshot,
                                                        context);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      int.parse(documentSnapshot['offer']) > 0
                                          ? Positioned(
                                              top: 0,
                                              right: 0,
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    Colors.green[200],
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Text(
                                                    '${documentSnapshot['offer']}%',
                                                    style: const TextStyle(
                                                        color: Colors.black),
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
                        },
                      );
                    } else {
                      return const Center(
                        child: Text('No products'),
                      );
                    }
                  } else {
                    return Center(
                      child: Text(snapshot.connectionState.toString()),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }

  // addProduct(DocumentSnapshot documentSnapshot) async {
  //   final cp = Provider.of<CartProvider>(context, listen: false);

  //   CartProductModel cartProductModel = CartProductModel(
  //     name: documentSnapshot['name'],
  //     qty: documentSnapshot['qty'],
  //     qtyMeasure: documentSnapshot['qtyMeasure'],
  //     originalPrice: documentSnapshot['originalPrice'],
  //     salePrice: documentSnapshot['salePrice'],
  //     count: 1,
  //     image: documentSnapshot['url'],
  //   );
  //   cp.addToCart(
  //     context,
  //     documentSnapshot.id,
  //     int.parse(documentSnapshot['originalPrice']),
  //     int.parse(documentSnapshot['salePrice']),
  //     cartProductModel.toJson(),
  //   );

  // }
}
