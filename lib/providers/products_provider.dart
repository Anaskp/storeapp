import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  String _name = '';
  String _url = '';
  String _salePrice = '';
  String _originalPrice = '';
  String _desc = '';
  String _offer = '';
  String _qty = '';
  String _qtyMeasure = '';
  String _category = '';
  String _productUid = '';

  String get name => _name;
  String get url => _url;
  String get salePrice => _salePrice;
  String get originalPrice => _originalPrice;
  String get desc => _desc;
  String get offer => _offer;
  String get qty => _qty;
  String get qtyMeasure => _qtyMeasure;
  String get category => _category;
  String get productUid => _productUid;

  Future<bool> showProduct(String uid, context) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(uid)
          .get()
          .then((value) {
        _name = value.data()!['name'];
        _url = value.data()!['url'];
        _originalPrice = value.data()!['originalPrice'];
        _salePrice = value.data()!['salePrice'];
        _desc = value.data()!['desc'];
        _offer = value.data()!['offer'];
        _qty = value.data()!['qty'];
        _qtyMeasure = value.data()!['qtyMeasure'];
        _category = value.data()!['categories'][0];
        _productUid = uid;
        notifyListeners();
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }

    Navigator.of(context).pop();

    return true;
  }
}
