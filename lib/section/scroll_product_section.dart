import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/screens/see_all_product.dart';

import 'package:e_store/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ScrollProductSection extends StatelessWidget {
  ScrollProductSection({
    Key? key,
    this.name = '',
    required this.title,
    required this.color,
  }) : super(key: key);

  final String name;
  final String title;
  final Color color;

  CollectionReference firestore =
      FirebaseFirestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      color: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SeeAllProduct(name: name),
                    ));
                  },
                  child: const Text(
                    'See all',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 210,
            width: double.infinity,
            child: StreamBuilder(
                stream: name == ''
                    ? firestore.orderBy('created', descending: true).snapshots()
                    : firestore
                        .where('categories', arrayContains: name)
                        .snapshots(),
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

                            return ProductCard(
                              documentSnapshot: documentSnapshot,
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
}
