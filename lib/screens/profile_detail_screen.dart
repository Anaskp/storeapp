import 'package:e_store/screens/screens.dart';
import 'package:e_store/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';

class ProfileDetailScreen extends StatelessWidget {
  ProfileDetailScreen({Key? key, this.newUser = false}) : super(key: key);

  final bool newUser;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile Settings',
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Name'),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Email'),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    saveUser(context);
                  },
                  child: const Text('Submit'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  saveUser(context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    if (_nameController.text != '' && _emailController.text != '') {
      showDialog(
          context: context,
          builder: (context) {
            return Center(child: CircularProgressIndicator());
          });
      if (newUser) {
        ap
            .saveUser(
          context,
          _nameController.text,
          _emailController.text,
        )
            .then((value) {
          if (value == true) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NewAddressScreen(
                      newUser: true,
                    )));
          }
        });
      } else {
        ap
            .saveUser(
                context, _nameController.text, _emailController.text, false)
            .then((value) {
          Navigator.of(context).pop();
        });
      }
    } else {
      showSnackBar(context, 'Complete fields');
    }
  }
}
