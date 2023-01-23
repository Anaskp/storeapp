import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cp = Provider.of<CartProvider>(context, listen: false);
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search for a product',
                            hintStyle: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.search,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('products')
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
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot documentSnapshot =
                              snapshot.data!.docs[index];
                          // List prodCart =
                          //     cp.checkProductCart(documentSnapshot.id) as List;
                          return Card(
                            child: ListTile(
                                isThreeLine: true,
                                leading: CachedNetworkImage(
                                  imageUrl: documentSnapshot['url'],
                                ),
                                title: Text(
                                  documentSnapshot['name'],
                                ),
                                subtitle: Text(
                                  '${documentSnapshot['qty']} ${documentSnapshot['qtyMeasure']}\n₹ ${documentSnapshot['salePrice']}',
                                ),
                                trailing:
                                    //prodCart[0] == false ?
                                    DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
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
                                      var list = cp.checkProductCart(
                                          documentSnapshot.id);
                                      print(list);
                                      //cp.addProduct(documentSnapshot, context);
                                    },
                                  ),
                                )
                                // : CounterWidget(
                                //     count: prodCart[1],
                                //     prodDoc: documentSnapshot.id,
                                //     originalPrice:
                                //         documentSnapshot['originalPrice'],
                                //     salePrice: documentSnapshot['salePrice'],
                                //   ),
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
            ],
          ),
        ),
      ),
    );
  }
}
