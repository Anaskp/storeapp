import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/screens/otp_screen.dart';
import 'package:e_store/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _userId;
  String get userId => _userId!;

  void signInWithPhone(BuildContext context, String phoneNumber) async {
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
              builder: (context) => OtpScreen(verificationId: verId),
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
}
