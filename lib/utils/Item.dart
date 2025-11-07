import 'dart:math';

import 'package:borotokar/Congit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:borotokar/utils/MyBottomsheet.dart';

import 'package:get/get.dart';

class Item extends StatelessWidget {
  final String image;
  final String title;
  final String des;
  final int id;
  const Item({
    Key? key,
    required this.image,
    required this.title,
    required this.des,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          isDismissible: true,
          MyBottomSheet(id: id, image: image, title: title),
        );
      },
      child: Column(
        children: [
          Container(
            // ignore: prefer_const_constructors
            height: 190,
            // width: 400,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                // height: 100,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title + ":", style: TextStyle(fontSize: 12)),

                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[50],
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                des,
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
