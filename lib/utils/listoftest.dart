import 'package:borotokar/Congit.dart';
import 'package:borotokar/utils/Home/catPage.dart';
import 'package:borotokar/utils/MyBottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListCard extends StatelessWidget {
  final image;
  final title;
  final double height;
  final double width;
  final int id;
  final double textSize;
  final bool more;
  final cats;
  const ListCard({
    super.key,
    this.image,
    this.title,
    required this.id,
    this.height = 94,
    this.width = 150,
    this.textSize = 16,
    this.more = false,
    this.cats,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: width + 25,
        height: height + 30,
        child: GestureDetector(
          onTap: () {
            if (more) {
              Get.to(() => CatPage(cat: cats));
            } else {
              Get.bottomSheet(
                isDismissible: true,
                MyBottomSheet(id: id, image: IMG_API_URL + image, title: title),
              );
            }
          },
          child: Column(
            children: [
              moree(),
              Text(
                title,
                style: TextStyle(fontSize: textSize),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget moree() {
    if (more) {
      return SizedBox(
        height: height, // ارتفاع مشخص
        width: width, // عرض متناسب با والد
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(IMG_API_URL + image),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.5), // بالا شفاف
                      Colors.black.withOpacity(0.3), // وسط نیمه‌شفاف
                      Colors.black.withOpacity(0.5), // پایین تیره‌تر
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(IMG_API_URL + image),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      );
    }
  }
}
