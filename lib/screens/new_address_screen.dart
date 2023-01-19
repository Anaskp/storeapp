import 'package:e_store/screens/screens.dart';
import 'package:e_store/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';

class NewAddressScreen extends StatelessWidget {
  NewAddressScreen({super.key, this.newUser = false});

  final bool newUser;

  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add new address'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _houseController,
                decoration: InputDecoration(
                  labelText: 'House no. / Building no.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _streetController,
                decoration: InputDecoration(
                  labelText: 'Street name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _pinController,
                maxLength: 6,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Pin-code',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _stateController,
                decoration: InputDecoration(
                  labelText: 'State',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    addAddress(context);
                  },
                  child: const Text('Add new address'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  addAddress(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    if (_houseController.text != '' &&
        _stateController.text != '' &&
        _cityController.text != '' &&
        _pinController.text.length == 6 &&
        _streetController.text != '') {
      // showDialog(
      //     context: context,
      //     builder: (context) {
      //       return Center(child: CircularProgressIndicator());
      //     });
      if (newUser) {
        ap
            .addAddress(
          context,
          _houseController.text,
          _streetController.text,
          _pinController.text,
          _cityController.text,
          _stateController.text,
        )
            .then((value) {
          if (value == true) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MainScreen()),
                (route) => false);
          }
        });
      } else {
        ap
            .addAddress(
                context,
                _houseController.text,
                _streetController.text,
                _pinController.text,
                _cityController.text,
                _stateController.text,
                false)
            .then((value) {
          if (value == true) {
            Navigator.of(context).pop();
          }
        });
      }
    } else {
      showSnackBar(context, 'Complete fields');
    }
  }
}
