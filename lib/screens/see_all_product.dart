import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/screens/screens.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../widgets/widgets.dart';

class SeeAllProduct extends StatelessWidget {
  SeeAllProduct({super.key, required this.name});
  String name;

  CollectionReference firestore =
      FirebaseFirestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    final cp = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(name == '' ? 'New Arrivals' : name),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: StreamBuilder(
          stream: name == ''
              ? firestore.orderBy('created', descending: true).snapshots()
              : firestore.where('categories', arrayContains: name).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active ||
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
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                        snapshot.data!.docs[index];

                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(
                              documentSnapshot: documentSnapshot),
                        ));
                      },
                      child: Card(
                        child: ListTile(
                          isThreeLine: true,
                          leading: CachedNetworkImage(
                            imageUrl: documentSnapshot['url'],
                            placeholder: (context, url) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              );
                            },
                            width: 70,
                          ),
                          title: Text(
                            documentSnapshot['name'],
                          ),
                          subtitle: Text(
                            '${documentSnapshot['qty']} ${documentSnapshot['qtyMeasure']}\n₹ ${documentSnapshot['salePrice']}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              cp.cartItems.containsKey(documentSnapshot.id)
                                  ? CounterWidget(
                                      count: cp.cartItems[documentSnapshot.id],
                                      prodDoc: documentSnapshot.id,
                                      originalPrice:
                                          documentSnapshot['originalPrice'],
                                      salePrice: documentSnapshot['salePrice'])
                                  : AddButton(
                                      documentSnapshot: documentSnapshot),
                            ],
                          ),
                        ),
                      ),
                    );
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
          },
        ),
      ),
    );
  }
}
