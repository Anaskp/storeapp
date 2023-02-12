import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';

class AddButton extends StatelessWidget {
  const AddButton({
    Key? key,
    required this.documentSnapshot,
  }) : super(key: key);

  final DocumentSnapshot<Object?> documentSnapshot;

  @override
  Widget build(BuildContext context) {
    final cp = Provider.of<CartProvider>(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[500]!,
            offset: const Offset(4, 4),
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
          cp.addProduct(documentSnapshot, context);
        },
      ),
    );
  }
}
