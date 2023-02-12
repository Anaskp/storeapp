import 'package:e_store/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  tileWidget(
                    Icons.person,
                    'Profile',
                    ProfileDetailScreen(),
                    context,
                  ),
                  tileWidget(
                    Icons.shopping_bag,
                    'Orders',
                    const OrderScreen(),
                    context,
                  ),
                  tileWidget(
                    Icons.home,
                    'Address',
                    const AddressScreen(),
                    context,
                  ),
                ],
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text('Log Out'),
                  onPressed: () {
                    final ap =
                        Provider.of<AuthProvider>(context, listen: false);
                    ap.signOut(context).then((value) {
                      if (value == true) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => MobileLogin()),
                            (route) => false);
                      }
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  InkWell tileWidget(
    icon,
    title,
    route,
    context,
  ) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => route));
      },
      child: Card(
        child: ListTile(
          title: Text(title),
          trailing: const Icon(
            Icons.chevron_right,
          ),
          leading: Icon(icon),
        ),
      ),
    );
  }
}
