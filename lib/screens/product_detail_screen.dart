import 'package:flutter/material.dart';

import '../section/sections.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen(
      {super.key, required this.name, required this.path});
  final String name;
  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      path,
                      height: MediaQuery.of(context).size.height / 2,
                    ),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      '125ml',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('₹68'),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '₹135',
                              style: TextStyle(
                                fontSize: 10,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.purple,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 5),
                                child: const Text(
                                  '49% off',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.pink,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 22),
                            child: Text(
                              'Add',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      title: Text(
                        'About product',
                        style: TextStyle(fontSize: 12),
                      ),
                      children: [
                        Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed in accumsan neque, eu feugiat diam. Quisque ultrices quis diam sed semper. Quisque laoreet lacus ut maximus lobortis. Sed commodo arcu vitae nisl fermentum luctus. Donec finibus enim eget imperdiet molestie. Proin faucibus nisl ac tristique varius. Nullam venenatis blandit lorem quis finibus'),
                      ],
                    ),
                  ],
                ),
              ),
              ScrollProductSection(
                color: Colors.green[50]!,
                name: name,
                path: path,
                title: 'Similar products',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
