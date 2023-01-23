import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_store/screens/new_address_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/models.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';

class CartScreen extends StatelessWidget {
  CartScreen({Key? key}) : super(key: key);

  final String _userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final cp = Provider.of<CartProvider>(context);
    AddressModel address = AddressModel.fromJson(ap.address);
    var product = FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('cart')
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: StreamBuilder(
          stream: product,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                  child: Text('No Products'),
                );
              } else if (snapshot.hasData) {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: ((context, index) {
                    DocumentSnapshot documentSnapshot =
                        snapshot.data!.docs[index];

                    return Card(
                      child: ListTile(
                        title: Text(documentSnapshot['name']),
                        subtitle: Text(
                            '${documentSnapshot['qty']} ${documentSnapshot['qtyMeasure']}'),
                        leading: CachedNetworkImage(
                          imageUrl: documentSnapshot['image'],
                          width: 70,
                        ),
                        //  Image.network(
                        //   documentSnapshot['image'],
                        //   width: 70,
                        // ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: CounterWidget(
                                count: documentSnapshot['count'],
                                prodDoc: documentSnapshot.id,
                                originalPrice: int.parse(
                                    documentSnapshot['originalPrice']),
                                salePrice:
                                    int.parse(documentSnapshot['salePrice']),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(((int.parse(
                                            documentSnapshot['salePrice'])) *
                                        documentSnapshot['count'])
                                    .toString()),
                                Text(
                                  ((int.parse(documentSnapshot[
                                              'originalPrice'])) *
                                          documentSnapshot['count'])
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[700],
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }),
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
      ),
      bottomNavigationBar: cp.count > 0
          ? Container(
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[400]!,
                    offset: const Offset(0, -5),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${address.house},${address.street},${address.city}, ${address.state}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => NewAddressScreen()));
                          },
                          child: const Text('Change location'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '₹ ${cp.totalPrice.toString()}',
                                style: TextStyle(
                                  fontSize: 10,
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                '₹ ${cp.totalSalePrice.toString()}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5,
                            ),
                            child: Text('Continue to Payment'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : SizedBox.shrink(),
    );
  }
}
