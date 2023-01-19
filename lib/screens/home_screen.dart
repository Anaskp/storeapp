import 'package:flutter/material.dart';

import '../section/sections.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: SearchWidget(),
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
