import 'package:borotokar/Congit.dart';
import 'package:borotokar/utils/mesage/mesagePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MesageList extends StatelessWidget {
  final int id;
  final String name;
  final String lastmessage;
  final bool seen;
  final imageUrl;
  const MesageList({
    super.key,
    required this.imageUrl,
    required this.id,
    required this.name,
    required this.lastmessage,
    this.seen = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => MesPage(id: id));
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
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage("$IMG_API_URL$imageUrl"),
                        fit: BoxFit.cover,
                      ),
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
                      // some of laste message
                      Text(
                        lastmessage.length > 20
                            ? "${lastmessage.substring(0, 20)} ..."
                            : "${lastmessage} ...",
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
