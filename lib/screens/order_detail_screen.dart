import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderDdetailScreen extends StatelessWidget {
  OrderDdetailScreen({super.key, required this.documentSnapshot});

  DocumentSnapshot documentSnapshot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('#${documentSnapshot.id}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.separated(
            itemBuilder: (context, index) {
              var data = documentSnapshot['products'][index];
              return Card(
                child: ListTile(
                  isThreeLine: true,
                  title: Text(data['name']),
                  leading: CachedNetworkImage(
                    imageUrl: data['image'],
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
                  subtitle: Text(
                    '${data['qty']} ${data['qtyMeasure']}\n₹ ${data['salePrice']}',
                  ),
                  trailing: Text('x ${data['count']}'),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 5,
              );
            },
            itemCount: documentSnapshot['products'].length),
      ),
    );
  }
}
