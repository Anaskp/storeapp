import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/screens/screens.dart';
import 'package:flutter/material.dart';

class CategorySection extends StatelessWidget {
  CategorySection({Key? key}) : super(key: key);

  final category =
      FirebaseFirestore.instance.collection('category').snapshots();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Explore by Category',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder(
          stream: category,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Something got error'),
                );
              } else if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No categories'),
                );
              } else if (snapshot.hasData) {
                return GridView.builder(
                  itemCount: snapshot.data!.docs.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                        snapshot.data!.docs[index];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CategoryDetailScreen(
                              categoryName: documentSnapshot['name'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                documentSnapshot['name'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: const TextStyle(fontSize: 12),
                              ),
                              Expanded(
                                child: CachedNetworkImage(
                                  imageUrl: documentSnapshot['url'],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('No Categories'),
                );
              }
            } else {
              return Center(
                child: Text(snapshot.connectionState.toString()),
              );
            }
          },
        ),
      ],
    );
  }
}
