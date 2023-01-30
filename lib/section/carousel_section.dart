// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class CarouselSection extends StatelessWidget {
//   const CarouselSection({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final List<String> imgList = [
//       'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
//       'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
//       'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
//       'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
//       'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
//       'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
//     ];

//     final List<Widget> imageSliders = imgList
//         .map((item) => Container(
//               margin: const EdgeInsets.all(5.0),
//               child: ClipRRect(
//                   borderRadius: const BorderRadius.all(Radius.circular(5.0)),
//                   child: Stack(
//                     children: <Widget>[
//                       CachedNetworkImage(
//                           imageUrl: item, fit: BoxFit.cover, width: 1000.0),
//                       Positioned(
//                         bottom: 10,
//                         left: 10,
//                         child: Text('hello'),
//                       ),
//                     ],
//                   )),
//             ))
//         .toList();

//           return CarouselSlider(
//             options: CarouselOptions(
//               autoPlay: true,
//               aspectRatio: 2.0,
//               enlargeCenterPage: true,
//               enlargeStrategy: CenterPageEnlargeStrategy.height,
//             ),
//             items: imageSliders,
//           );
//   }
// }

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
    var _fireStore = FirebaseFirestore.instance;
    QuerySnapshot snapShot = await _fireStore.collection('carousel').get();

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
                        itemBuilder: (BuildContext context, int index, int) {
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
                                  fit: BoxFit.contain,
                                  width: 1000.0),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: true,
                          aspectRatio: 2.0,
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
