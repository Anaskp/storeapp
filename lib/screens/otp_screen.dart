import 'package:e_store/screens/screens.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({Key? key}) : super(key: key);

  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  final TextEditingController _fieldFive = TextEditingController();
  final TextEditingController _fieldSix = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
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
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => MainScreen()),
                      (route) => false);
                },
                child: Text('Submit'),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
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
