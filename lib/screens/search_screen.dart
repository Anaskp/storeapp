import 'package:e_store/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SearchWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
