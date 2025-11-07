import 'package:borotokar/utils/mesage/mesagePage.dart';
import 'package:borotokar/utils/mesage/suportMesagePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuportMesageCart extends StatelessWidget {
  final int id;
  final String name;
  final String lastmessage;
  final bool seen;
  const SuportMesageCart({
    super.key,
    required this.id,
    this.name = "بروتوکار",
    this.lastmessage = "....",
    this.seen = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => suportMesagePage(id: 0));
      },
      child: Container(
        width: Get.width + 1,
        decoration: BoxDecoration(border: Border.all(width: 0.05)),

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Icon(Icons.account_circle_rounded, size: 60),
                  Container(
                    width: 60,
                    height: 60,

                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/borotokar2.png"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.black38),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          // crossAxisAlignment: CrossAxisAlignment.e,
                          children: [
                            Container(
                              child: Icon(
                                Icons.verified_rounded,
                                color: Colors.blue,
                                size: 18,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${lastmessage.substring(lastmessage.length - 1)}...",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  if (!seen) Icon(Icons.circle, size: 20, color: Colors.blue),
                  Icon(Icons.chevron_right_sharp, size: 35),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
