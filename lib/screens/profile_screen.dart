import 'package:e_store/screens/screens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                    OrderScreen(),
                    context,
                  ),
                  tileWidget(
                    Icons.home,
                    'Address',
                    ProfileDetailScreen(),
                    context,
                  ),
                  tileWidget(
                    Icons.notifications,
                    'Notifications',
                    ProfileDetailScreen(),
                    context,
                  ),
                ],
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('Log Out'),
                  onPressed: () {},
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
          trailing: Icon(
            Icons.chevron_right,
          ),
          leading: Icon(icon),
        ),
      ),
    );
  }
}
