import 'package:e_store/providers/providers.dart';
import 'package:e_store/screens/main_screen.dart';
import 'package:e_store/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({Key? key, required this.verificationId}) : super(key: key);

  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  final TextEditingController _fieldFive = TextEditingController();
  final TextEditingController _fieldSix = TextEditingController();

  final verificationId;

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;

    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Enter your OTP',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OtpInput(
                        textEditingController: _fieldOne,
                        autofocus: true,
                      ),
                      OtpInput(
                        textEditingController: _fieldTwo,
                        autofocus: false,
                      ),
                      OtpInput(
                        textEditingController: _fieldThree,
                        autofocus: false,
                      ),
                      OtpInput(
                        textEditingController: _fieldFour,
                        autofocus: false,
                      ),
                      OtpInput(
                        textEditingController: _fieldFive,
                        autofocus: false,
                      ),
                      OtpInput(
                        textEditingController: _fieldSix,
                        autofocus: false,
                      ),
                    ],
                  ),
                  const SizedBox(
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
                      onPressed: () {
                        var smsCode = _fieldOne.text +
                            _fieldTwo.text +
                            _fieldThree.text +
                            _fieldFour.text +
                            _fieldFive.text +
                            _fieldSix.text;
                        if (smsCode.length == 6) {
                          verifyOtp(context, smsCode);
                        } else {
                          showSnackBar(context, 'Enter 6-digit OTP');
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      text: 'Didn\'t recieve code ? ',
                      children: [
                        TextSpan(
                            text: 'Resend code',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {}),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void verifyOtp(BuildContext context, String smsCode) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    ap.verifyOTP(
        context: context,
        verificationId: verificationId,
        userOtp: smsCode,
        onSuccess: () async {
          ap.checkExistingUser().then((value) async {
            if (value == true) {
              //user exist

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => MainScreen(),
                  ),
                  (route) => false);
            } else {
              //new user

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => MainScreen(),
                  ),
                  (route) => false);
            }
          });

          // bool isExist =await ap.checkExistingUser();
        });
  }
}

class OtpInput extends StatelessWidget {
  const OtpInput(
      {Key? key, required this.textEditingController, required this.autofocus})
      : super(key: key);

  final TextEditingController textEditingController;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 50,
      child: TextField(
          controller: textEditingController,
          autofocus: autofocus,
          maxLength: 1,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            counter: SizedBox.shrink(),
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            if (value.length == 1) {
              FocusScope.of(context).nextFocus();
            }
          }),
    );
  }
}
