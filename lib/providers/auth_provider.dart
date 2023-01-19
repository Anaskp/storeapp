import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/screens/otp_screen.dart';
import 'package:e_store/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/models.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _userId;
  String get userId => _userId!;
  String? _userName;
  String get name => _userName!;
  String? _userEmail;
  String get email => _userEmail!;
  late Map<String, dynamic> _address;
  Map<String, dynamic> get address => _address;

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        });
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await auth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          throw Exception(error.message);
        },
        codeSent: (verId, forceResendingToken) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                verificationId: verId,
                phoneNumber: phoneNumber,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  void verifyOTP(
      {required BuildContext context,
      required String verificationId,
      required String userOtp,
      required Function onSuccess}) async {
    _isLoading = true;
    notifyListeners();

    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);
      User? user = (await auth.signInWithCredential(creds)).user;

      if (user != null) {
        _userId = user.uid;
        onSuccess();
      }

      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot =
        await firestore.collection('users').doc(_userId).get();
    if (snapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> saveUser(BuildContext context, String name, String email,
      [bool newUser = true]) async {
    bool userAdded = false;

    try {
      UserModel user = UserModel(name: name, email: email);
      if (newUser) {
        firestore.collection('users').doc(userId).set(user.toJson());
        userAdded = true;
        _userName = name;
        _userEmail = email;
        notifyListeners();
      } else {
        firestore
            .collection('users')
            .doc(userId)
            .update(user.toJson())
            .then((value) {
          userAdded = true;
          _userName = name;
          _userEmail = email;
          notifyListeners();
        });
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return userAdded;
  }

  Future<bool> addAddress(BuildContext context, String house, String street,
      String pin, String city, String state,
      [bool newUser = true]) async {
    bool addressAdded = false;
    print('infirst ${addressAdded}');

    try {
      AddressModel addressModel = AddressModel(
        house: house,
        street: street,
        pin: pin,
        city: city,
        state: state,
      );

      if (newUser) {
        firestore
            .collection('users')
            .doc(userId)
            .collection('address')
            .doc('address')
            .set(addressModel.toJson())
            .then((value) {
          //_address = addressModel.toJson();
          notifyListeners();
        });
      } else {
        firestore
            .collection('users')
            .doc(userId)
            .collection('address')
            .doc('address')
            .update(addressModel.toJson())
            .then((value) {
          //  _address = addressModel.toJson();
          notifyListeners();
        });
      }

      addressAdded = true;
    } catch (e) {
      showSnackBar(context, e.toString());
    }

    return addressAdded;
  }
}
