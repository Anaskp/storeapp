import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:e_store/widgets/widgets.dart';
import 'package:flutter/material.dart';

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
    return Container(
      height: 280,
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
            height: 210,
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
