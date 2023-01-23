import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/models.dart';
import '../providers/providers.dart';
import '../section/sections.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    UserModel user = UserModel.fromJson(ap.userData);
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Welcome ${user.name}',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CarouselSection(),
            const SizedBox(
              height: 10,
            ),
            ScrollProductSection(
              color: Colors.green[50]!,
              name: 'Fruits',
              title: 'Go Fresh Fruits',
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CategorySection(),
            ),
            const SizedBox(
              height: 10,
            ),
            ScrollProductSection(
              color: Colors.green[50]!,
              title: 'New Arrivals',
            ),
            ScrollProductSection(
              color: Colors.grey[200]!,
              name: 'Vegetables',
              title: 'Your daily greens',
            ),
          ],
        ),
      ),
    );
  }
}
