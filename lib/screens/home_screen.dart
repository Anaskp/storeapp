import 'package:flutter/material.dart';

import '../section/sections.dart';
import '../widgets/widgets.dart';

class HomeSccreen extends StatelessWidget {
  const HomeSccreen({Key? key}) : super(key: key);

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
              name: 'Chocolate',
              path: 'assets/images/sweet.png',
              title: 'Trending Products near you',
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
              name: 'Biscuit',
              path: 'assets/images/biscuit.png',
              title: 'New Arrivals',
            ),
            ScrollProductSection(
              color: Colors.grey[200]!,
              name: 'Tomato',
              path: 'assets/images/veg.png',
              title: 'Your daily greens',
            ),
          ],
        ),
      ),
    );
  }
}
