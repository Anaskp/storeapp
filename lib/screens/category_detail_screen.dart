import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/providers/products_provider.dart';
import 'package:e_store/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryDetailScreen extends StatefulWidget {
  CategoryDetailScreen({
    Key? key,
    required this.categoryName,
  }) : super(key: key);

  final String categoryName;

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  dynamic products;

  @override
  void initState() {
    setState(() {
      products = FirebaseFirestore.instance
          .collection('products')
          .where('categories', arrayContains: widget.categoryName)
          .snapshots();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.categoryName,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                StreamBuilder(
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
                          child: Text('No Products'),
                        );
                      } else if (snapshot.hasData) {
                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot documentSnapshot =
                                snapshot.data!.docs[index];

                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(
                                        documentSnapshot: documentSnapshot),
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
                                            style: TextStyle(
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
                                                  onPressed: () {},
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
                          },
                        );
                      } else {
                        return const Center(
                          child: Text('No Products'),
                        );
                      }
                    } else {
                      return Center(
                        child: Text(snapshot.connectionState.toString()),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
