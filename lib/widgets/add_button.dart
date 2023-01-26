import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../providers/providers.dart';

class AddButton extends StatelessWidget {
  const AddButton({
    Key? key,
    required this.cp,
    required this.documentSnapshot,
  }) : super(key: key);

  final CartProvider cp;
  final DocumentSnapshot<Object?> documentSnapshot;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
          cp.addProduct(documentSnapshot, context);
        },
      ),
    );
  }
}
