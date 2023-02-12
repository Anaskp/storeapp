import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/screens/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var orders = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('orders')
        .orderBy('date', descending: true)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
            stream: orders,
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
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.receipt_long,
                          size: 80,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'No Orders',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasData) {
                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot documentSnapshot =
                          snapshot.data!.docs[index];
                      String title = '';
                      for (var i = 0;
                          i < documentSnapshot['products'].length;
                          i++) {
                        title =
                            '${title + documentSnapshot['products'][i]['name']} ';
                      }

                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => OrderDdetailScreen(
                                documentSnapshot: documentSnapshot),
                          ));
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                        '₹ ${documentSnapshot['totalSalePrice'].toString()}'),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Order #${documentSnapshot.id}\n${documentSnapshot['date']} ${documentSnapshot['time']}',
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: documentSnapshot['status'] ==
                                                  'Completed'
                                              ? Colors.green[300]
                                              : Colors.grey[300],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Text(
                                            documentSnapshot['status'],
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        thickness: 3,
                        height: 0,
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text('No orders'),
                  );
                }
              } else {
                return Center(
                  child: Text(snapshot.connectionState.toString()),
                );
              }
            }),
      ),
    );
  }
}
