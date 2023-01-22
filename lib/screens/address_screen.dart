import 'package:e_store/model/address_model.dart';
import 'package:e_store/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    AddressModel address = AddressModel.fromJson(ap.address);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 16,
        ),
        child: ListTile(
          leading: Icon(Icons.location_on),
          title: Text(address.house),
          subtitle: Text(
            '${address.street}\n${address.city} ${address.state} ${address.pin}',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NewAddressScreen()));
                },
                icon: Icon(Icons.edit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
