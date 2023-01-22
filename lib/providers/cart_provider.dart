import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:e_store/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class CartProvider with ChangeNotifier {
  late int _count;
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
          .doc('cart')
          .get();

      if (data.exists) {
        _cartItems = data.data()!;
        _count = _cartItems['cart'].length;
        notifyListeners();
        print('$_count in fetch');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  addToCart(context, String docId) async {
    if (_count > 0) {
      firestore
          .collection('users')
          .doc(_userId)
          .collection('cart')
          .doc('cart')
          .update({'cart.$docId': 2});

      await fetchCart(context);
      notifyListeners();
    } else {
      firestore
          .collection('users')
          .doc(_userId)
          .collection('cart')
          .doc('cart')
          .set({
        'cart': {docId: 2}
      });

      await fetchCart(context);
      notifyListeners();
    }
  }
}
