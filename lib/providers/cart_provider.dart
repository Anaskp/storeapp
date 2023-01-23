import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:e_store/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class CartProvider with ChangeNotifier {
  int _count = 0;
  int get count => _count;

  late Map<String, dynamic> _cartItems;
  Map<String, dynamic> get cartItems => _cartItems;

  final String _userId = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  fetchCart(context) async {
    try {
      var data = await firestore
          .collection('users')
          .doc(_userId)
          .collection('cart')
          .doc()
          .get();

      if (data.exists) {
        _count = firestore
            .collection('users')
            .doc(_userId)
            .collection('cart')
            .snapshots()
            .length as int;
        notifyListeners();
        print('$_count in fetch');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  addToCart(context, String productDoc, [Map<String, dynamic>? product]) async {
    var data = await firestore
        .collection('users')
        .doc(_userId)
        .collection('cart')
        .doc(productDoc)
        .get();
    if (data.exists) {
      firestore
          .collection('users')
          .doc(_userId)
          .collection('cart')
          .doc(productDoc)
          .update({'count': FieldValue.increment(1)});

      _count++;
      await fetchCart(context);
      notifyListeners();
    } else {
      firestore
          .collection('users')
          .doc(_userId)
          .collection('cart')
          .doc(productDoc)
          .set(product!);

      _count++;
      await fetchCart(context);
      notifyListeners();
    }
  }

  removeCart(
    BuildContext context,
    String prodDoc,
    int count,
  ) {
    if (count == 1) {
      firestore
          .collection('users')
          .doc(_userId)
          .collection('cart')
          .doc(prodDoc)
          .delete();
    } else {
      firestore
          .collection('users')
          .doc(_userId)
          .collection('cart')
          .doc(prodDoc)
          .update({'count': FieldValue.increment(-1)});
    }
  }
}