import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  late QueryDocumentSnapshot _querySnapshot;

  QueryDocumentSnapshot get querySnapshot => _querySnapshot;

  Future<bool> showCategoryDetails(String name, context) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    try {
      final products = FirebaseFirestore.instance
          .collection('products')
          .where('categories', arrayContains: name)
          .snapshots();

      _querySnapshot = products as QueryDocumentSnapshot;
      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }

    Navigator.of(context).pop();

    return true;
  }
}
