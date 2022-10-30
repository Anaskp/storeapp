import 'package:flutter/material.dart';

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
              Container(
                height: 250,
                color: Colors.green[50],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        'Similar products',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 180,
                      width: double.infinity,
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            width: 15,
                          );
                        },
                        shrinkWrap: true,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return const SizedBox(
                              width: 10,
                            );
                          } else {
                            return Container(
                              width: 140,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey[300]!,
                                      blurRadius: 8,
                                      spreadRadius: 0.1),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Image.asset(path)),
                                    ),
                                    Text(
                                      name,
                                      maxLines: 2,
                                    ),
                                    const Text(
                                      '250ml',
                                      style: TextStyle(
                                        fontSize: 11,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          '₹260',
                                        ),
                                        DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey[500]!,
                                                offset: const Offset(4, 4),
                                                blurRadius: 20,
                                                spreadRadius: 1,
                                              ),
                                              const BoxShadow(
                                                color: Colors.white,
                                                offset: Offset(-4, -4),
                                                blurRadius: 20,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                          ),
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.add,
                                              color: Colors.pink,
                                            ),
                                            onPressed: () {},
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
