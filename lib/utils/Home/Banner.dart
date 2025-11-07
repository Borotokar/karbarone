import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyBanner extends StatelessWidget {
  String image;
  double width;
  double height;
  MyBanner({
    super.key,
    required this.image,
    this.width = 150,
    this.height = 100,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Column(
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}
