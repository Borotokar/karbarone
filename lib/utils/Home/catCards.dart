import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CatCard extends StatelessWidget {
  final String title;
  final Widget listCards;
  const CatCard({Key? key, required this.title, required this.listCards})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 6.0),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(0xff222b45),
              ),
            ),
          ),
          SizedBox(
            height: 150, // یا هر ارتفاع مناسب
            child: listCards,
          ),
        ],
      ),
    );
  }
}
