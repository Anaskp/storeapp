import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';

class CheckoutScreen extends StatelessWidget {
  CheckoutScreen({super.key});

  int subTotal = 0;
  int totalSalePrice = 0;
  int deliveryCharge = 0;
  int packingCharge = 0;
  @override
  Widget build(BuildContext context) {
    final cp = Provider.of<CartProvider>(context, listen: false);

    totalSalePrice = cp.totalSalePrice;
    bool needDiscount = totalSalePrice > 500;

    if (needDiscount == false) {
      deliveryCharge = 30;
      packingCharge = 20;
      subTotal += totalSalePrice + deliveryCharge + packingCharge;
    } else {
      subTotal = totalSalePrice;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please confirm and complete your order',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(
              thickness: 3,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Payment method',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 2,
                  color: Colors.black,
                  style: BorderStyle.solid,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cash On Delivery',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.radio_button_checked,
                        color: Colors.green,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xffe6e6e6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Price'),
                        Text('₹ ${cp.totalPrice}'),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Offer Price'),
                        Text('₹ ${cp.totalSalePrice}'),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Discount'),
                        Text('${cp.offer.toString()} %'),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Delivery'),
                        Text(deliveryCharge.toString()),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Packing',
                        ),
                        Text(packingCharge.toString()),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sub total',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          subTotal.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  checkOut(context);
                },
                child: Text('Checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  checkOut(context) async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    final ap = Provider.of<AuthProvider>(context, listen: false);
    final cp = Provider.of<CartProvider>(context, listen: false);
    var user = FirebaseAuth.instance.currentUser;
    var firestore = FirebaseFirestore.instance;

    QuerySnapshot _myDoc = await firestore
        .collection('users')
        .doc(user!.uid)
        .collection('cart')
        .get();
    List<DocumentSnapshot> myDocCount = _myDoc.docs;
    List productList = [];
    for (var element in myDocCount) {
      productList.add(element.data());
    }

    var now = DateTime.now();
    var date = DateFormat('dd-MM-yyyy').format(now);
    var time = DateFormat.jm().format(now);

    DocumentReference docRef = await firestore
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .add({
      'products': productList,
      'date': date,
      'time': time,
      'totalSalePrice': cp.totalSalePrice,
      'totalPrice': cp.totalPrice,
      'subTotal': subTotal,
      'offer': cp.offer,
      'delivery': deliveryCharge,
      'packing': packingCharge,
      'status': 'Ordered'
    });

    await firestore.collection('orders').doc(docRef.id).set({
      'products': productList,
      'date': date,
      'time': time,
      'totalSalePrice': cp.totalSalePrice,
      'totalPrice': cp.totalPrice,
      'subTotal': subTotal,
      'offer': cp.offer,
      'delivery': deliveryCharge,
      'packing': packingCharge,
      'status': 'Ordered',
      'address': ap.address,
      'mobile': user.phoneNumber,
    });

    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });

    cp.checkout();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => MainScreen(),
        ),
        (route) => false);
  }
}
