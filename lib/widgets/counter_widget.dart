import 'package:flutter/material.dart';

class CounterWidget extends StatelessWidget {
  const CounterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.remove,
          ),
        ),
        const Text('1'),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.add,
          ),
        ),
      ],
    );
  }
}
