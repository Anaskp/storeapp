import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_store/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselSection extends StatefulWidget {
  const CarouselSection({Key? key}) : super(key: key);

  @override
  State<CarouselSection> createState() => _CarouselSectionState();
}

class _CarouselSectionState extends State<CarouselSection> {
  int _dataLength = 1;

  @override
  void initState() {
    getImageSliderFromDb();
    super.initState();
  }

  Future getImageSliderFromDb() async {
    var fireStore = FirebaseFirestore.instance;
    QuerySnapshot snapShot = await fireStore.collection('carousel').get();

    setState(() {
      _dataLength = snapShot.docs.length;
    });
    return snapShot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: Column(
        children: [
          if (_dataLength != 0)
            FutureBuilder(
              future: getImageSliderFromDb(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return snapshot.data == null
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        ),
                      )
                    : CarouselSlider.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder:
                            (BuildContext context, int index, int num) {
                          DocumentSnapshot sliderImage = snapshot.data[index];
                          Map data = sliderImage.data() as Map;

                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    SeeAllProduct(name: data['name']),
                              ));
                            },
                            child: Container(
                              margin: const EdgeInsets.all(5.0),
                              child: CachedNetworkImage(
                                placeholder: (context, url) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  );
                                },
                                imageUrl: data['url'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: true,
                          aspectRatio: 2.5,
                          enlargeCenterPage: true,
                          enlargeStrategy: CenterPageEnlargeStrategy.height,
                        ),
                      );
              },
            ),
        ],
      ),
    );
  }
}
