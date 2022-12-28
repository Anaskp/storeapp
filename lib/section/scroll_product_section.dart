import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class ScrollProductSection extends StatelessWidget {
  const ScrollProductSection({
    Key? key,
    required this.name,
    required this.path,
    required this.title,
    required this.color,
  }) : super(key: key);

  final String name;
  final String path;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      color: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8),
            child: Text(
              title,
              style: const TextStyle(
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
                  // return ProductCard(
                  //   name: name,
                  //   path: path,
                  // );

                  return SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
