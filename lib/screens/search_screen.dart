import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/screens/product_detail_screen.dart';
import 'package:e_store/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String search = '';

  CollectionReference firestore =
      FirebaseFirestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    final cp = Provider.of<CartProvider>(context);

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8),
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
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              search = value;
                            });
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search for a product',
                            hintStyle: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.search,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: firestore.snapshots(),
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
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot documentSnapshot =
                                  snapshot.data!.docs[index];

                              if ((documentSnapshot['name'])
                                  .toString()
                                  .toLowerCase()
                                  .startsWith(search.toLowerCase())) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                          cp.cartItems.containsKey(
                                                  documentSnapshot.id)
                                              ? CounterWidget(
                                                  count: cp.cartItems[
                                                      documentSnapshot.id],
                                                  prodDoc: documentSnapshot.id,
                                                  originalPrice:
                                                      documentSnapshot[
                                                          'originalPrice'],
                                                  salePrice: documentSnapshot[
                                                      'salePrice'])
                                              : AddButton(
                                                  documentSnapshot:
                                                      documentSnapshot),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
