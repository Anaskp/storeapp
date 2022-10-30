import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Tomato,Mushroom,cucumber, Chocolate, Carrot',
                            maxLines: 2,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('₹291'),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Order #546876542swtfg4ds5\n18/10/22 08:45pm',
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey[300],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                'Cancelled',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            )),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shopping_bag),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Reorder'),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                thickness: 3,
                height: 0,
              );
            },
            itemCount: 10),
      ),
    );
  }
}
