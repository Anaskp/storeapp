import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/model/cart_product_model.dart';

import 'package:e_store/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  int _count = 0;
  int get count => _count;

  int _totalPrice = 0;
  int get totalPrice => _totalPrice;

  int _totalSalePrice = 0;
  int get totalSalePrice => _totalSalePrice;

  Map _cartItems = {};
  Map get cartItems => _cartItems;

  int _offer = 0;
  int get offer => _offer;

  final String _userId = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  getOffer() {
    _offer = (((totalPrice - totalSalePrice) * 100) / totalPrice).floor();
    notifyListeners();
  }

  fetchCart(context) async {
    try {
      QuerySnapshot _myDoc = await firestore
          .collection('users')
          .doc(_userId)
          .collection('cart')
          .get();
      List<DocumentSnapshot> myDocCount = _myDoc.docs;
      List productList = [];
      for (var element in myDocCount) {
        productList.add(element.data());
        _cartItems[element.id] = element['count'];
      }

      for (var i in productList) {
        _totalPrice += int.parse(i['originalPrice']) * (i['count'] as int);
        _totalSalePrice += int.parse(i['salePrice']) * (i['count'] as int);
        notifyListeners();
        getOffer();
      }

      _count = myDocCount.length;
      notifyListeners();
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  addToCart(String productDoc, int originalPrice, int salePrice,
      [Map<String, dynamic>? product]) async {
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

      _cartItems.update(productDoc, (value) => _cartItems[productDoc] + 1);
      notifyListeners();
      addPrice(originalPrice, salePrice);
      getOffer();
    } else {
      firestore
          .collection('users')
          .doc(_userId)
          .collection('cart')
          .doc(productDoc)
          .set(product!);

      _cartItems[productDoc] = 1;
      _count++;

      notifyListeners();
      addPrice(originalPrice, salePrice);
      getOffer();
    }
  }

  removeCart(
    BuildContext context,
    String prodDoc,
    int count,
    int originalPrice,
    int salePrice,
  ) async {
    if (count == 1) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Product will be removed from cart'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    firestore
                        .collection('users')
                        .doc(_userId)
                        .collection('cart')
                        .doc(prodDoc)
                        .delete();
                    _cartItems.remove(prodDoc);
                    Navigator.of(context).pop();

                    _count--;
                    _cartItems.remove(prodDoc);
                    notifyListeners();
                    reducePrice(originalPrice, salePrice);
                    getOffer();
                  },
                  child: Text(
                    'Remove',
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ],
            );
          });
    } else {
      firestore
          .collection('users')
          .doc(_userId)
          .collection('cart')
          .doc(prodDoc)
          .update({'count': FieldValue.increment(-1)});

      _cartItems.update(prodDoc, (value) => _cartItems[prodDoc] - 1);
      notifyListeners();
      reducePrice(originalPrice, salePrice);
      getOffer();
    }
  }

  addPrice(int originalPrice, int salePrice) {
    _totalPrice += originalPrice;
    _totalSalePrice += salePrice;

    notifyListeners();
    getOffer();
  }

  reducePrice(int originalPrice, int salePrice) {
    _totalPrice -= originalPrice;
    _totalSalePrice -= salePrice;

    notifyListeners();
    getOffer();
  }

  addProduct(DocumentSnapshot documentSnapshot, BuildContext context) async {
    CartProductModel cartProductModel = CartProductModel(
      name: documentSnapshot['name'],
      qty: documentSnapshot['qty'],
      qtyMeasure: documentSnapshot['qtyMeasure'],
      originalPrice: documentSnapshot['originalPrice'],
      salePrice: documentSnapshot['salePrice'],
      count: 1,
      image: documentSnapshot['url'],
    );
    addToCart(
      documentSnapshot.id,
      int.parse(documentSnapshot['originalPrice']),
      int.parse(documentSnapshot['salePrice']),
      cartProductModel.toJson(),
    );
  }

  slideRemove(prodDoc, int originalPrice, int salePrice, int prodCount) async {
    _totalPrice -= originalPrice * prodCount;
    _totalSalePrice -= salePrice * prodCount;
    _count--;
    notifyListeners();
    await firestore
        .collection('users')
        .doc(_userId)
        .collection('cart')
        .doc(prodDoc)
        .delete();
    _cartItems.remove(prodDoc);

    notifyListeners();
    getOffer();
  }

  checkout() {
    _count = 0;
    _totalPrice = 0;
    _totalSalePrice = 0;
    _offer = 0;
    _cartItems = {};
    notifyListeners();
  }
}
