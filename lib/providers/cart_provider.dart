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

  final String _userId = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
      }

      for (var i in productList) {
        _totalPrice += int.parse(i['originalPrice']);
        _totalSalePrice += int.parse(i['salePrice']);
        notifyListeners();
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

      addPrice(originalPrice, salePrice);
      notifyListeners();
    } else {
      firestore
          .collection('users')
          .doc(_userId)
          .collection('cart')
          .doc(productDoc)
          .set(product!);

      _count++;
      addPrice(originalPrice, salePrice);
      notifyListeners();
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
                    Navigator.of(context).pop();
                    reducePrice(originalPrice, salePrice);

                    _count--;

                    notifyListeners();
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
      reducePrice(originalPrice, salePrice);
    }
  }

  addPrice(int originalPrice, int salePrice) {
    _totalPrice += originalPrice;
    //print("$totalSalePrice ${salePrice.toString()}");
    _totalSalePrice += salePrice;
    notifyListeners();
  }

  reducePrice(int originalPrice, int salePrice) {
    _totalPrice -= originalPrice;
    _totalSalePrice -= salePrice;
    //print("$totalSalePrice ${salePrice.toString()}");
    notifyListeners();
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

  Future<List> checkProductCart(String productDoc) async {
    List returnList = [];
    var data = await firestore
        .collection('users')
        .doc(_userId)
        .collection('cart')
        .doc(productDoc)
        .get();

    // if (data.exists) {
    //   returnList.add(data.exists);
    //   firestore
    //       .collection('users')
    //       .doc(_userId)
    //       .collection('cart')
    //       .doc(productDoc)
    //       .get()
    //       .then((value) {
    //     var prodCount = value.data()!['count'];
    //     returnList.add(prodCount);
    //     return returnList;
    //   });
    // }

    returnList.add(data.exists);
    firestore
        .collection('users')
        .doc(_userId)
        .collection('cart')
        .doc(productDoc)
        .get()
        .then((value) {
      var prodCount = value.data()!['count'];
      returnList.add(prodCount);
    });

    return returnList;
  }
}
