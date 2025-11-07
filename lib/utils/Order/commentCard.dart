import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class CommentCard extends StatelessWidget {
  final name;
  final datetime;
  final body;
  final double starrate;
  const CommentCard({
    super.key,
    this.name,
    this.datetime,
    this.body,
    required this.starrate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 6.0,
        top: 6.0,
        right: 12,
        left: 12,
      ),
      child: Container(
        // width: ,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.white60,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(102, 0, 0, 0),
              blurRadius: 2,
              blurStyle: BlurStyle.inner,
              spreadRadius: 0.6,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 10.0, left: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 10),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(name, style: TextStyle(fontSize: 22)),
                          SizedBox(width: 60),
                          RatingBarIndicator(
                            rating: starrate,
                            itemBuilder:
                                (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber.shade600,
                                ),
                            itemCount: 5,
                            itemSize: 25.0,
                            direction: Axis.horizontal,
                          ),
                        ],
                      ),
                      SizedBox(height: 15),

                      Container(
                        width: 250,
                        child: Text(
                          "${body}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: Row(
            //             mainAxisAlignment: MainAxisAlignment.start,
            //             children: [
            //               Icon(Icons.access_time, size: 15,),
            //               SizedBox(width: 6,),
            //               Text(datetime),
            //             ],
            //           ),
            // )
          ],
        ),
      ),
    );
  }
}
