import 'package:e_store/providers/auth_provider.dart';
import 'package:e_store/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MobileLogin extends StatelessWidget {
  MobileLogin({Key? key}) : super(key: key);

  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/background.png'),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(
            16,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 200,
                ),
                Text(
                  'Groceries \ndelivered in \n10 minutes',
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Text(
                          '+91',
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                            child: TextField(
                          controller: phoneController,
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 4),
                            counter: SizedBox.shrink(),
                            border: InputBorder.none,
                            hintText: 'Enter your phone number',
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: () async {
                      if (phoneController.text.length == 10) {
                        sendPhoneNumber(context);
                      } else {
                        showSnackBar(context, 'Enter 10 digit mobile number');
                      }
                    },
                    child: const Text('Continue'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void sendPhoneNumber(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    String number = '+91${phoneController.text.trim()}';

    ap.signInWithPhone(context, number);
  }
}
