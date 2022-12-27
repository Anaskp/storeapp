import 'package:flutter/material.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Addresses'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 16,
        ),
        child: ListView.separated(
          itemCount: 2,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Home'),
              subtitle: Text(
                'Home- akjfhjks, jkasdfhkasd, jasdfhkasd dfhkasd',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              thickness: 2,
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {},
            child: Text('Add new address'),
          ),
        ),
      ),
    );
  }
}
