import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class PlistCard extends StatelessWidget {
  final icon;
  final String title;
  final image;
  void Function()? onPressed;
  PlistCard({super.key,required  this.icon,required  this.title, required this.onPressed, this.image=null,});

  @override
  Widget build(BuildContext context) {
    return Padding(
                padding: const EdgeInsets.only(right: 10.0, left: 10.0,top: 2, bottom: 5),
                child: GestureDetector(
                  onTap: onPressed,
                  child: Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                      color: const Color.fromARGB(83, 0, 0, 0),
                      blurRadius: 0.1,
                      spreadRadius: 1
                     )
                    ],
                     color: Colors.white
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                          image != null ? Image.asset(image, width: 30,) : icon,
                          SizedBox(width: 10,),
                          Text(title, style: TextStyle(color: Colors.black54, fontSize: 19),),
                          ],
                        ),
                        Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              ));
  }
}