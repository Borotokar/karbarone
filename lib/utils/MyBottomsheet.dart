import 'package:borotokar/Congit.dart';
import 'package:borotokar/pages/Home.dart';
import 'package:borotokar/pages/Order.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/route_manager.dart';

class MyBottomSheet extends StatefulWidget {
  final String title;
  final String image;
  final int id;
  const MyBottomSheet({
    super.key,
    required this.title,
    required this.image,
    required this.id,
  });

  @override
  State<MyBottomSheet> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  String selectedCity = "تهران";
  final List<String> cities = [
    'تهران',
    'اصفهان',
    'مشهد',
    'شیراز',
    'تبریز',
    'قم',
    'کرج',
    'اهواز',
    'کرمانشاه',
    'رشت',
    'ارومیه',
    'زاهدان',
    'کرمان',
    'همدان',
    'یزد',
    'اردبیل',
    'بندرعباس',
    'قزوین',
    'سنندج',
    'خرم‌آباد',
    'بوشهر',
    'زنجان',
    'ساری',
    'گرگان',
    'بیرجند',
    'ایلام',
    'یاسوج',
    'بجنورد',
    'شهرکرد',
    'مراغه',
    'سبزوار',
    'کاشان',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Wrap(
          // height: ,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 110,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                SizedBox(height: 4),

                Container(
                  // ignore: prefer_const_constructors
                  height: 200,
                  // child: Column(mainAxisSize: MainAxisSize.max,),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.image),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                ),

                Container(
                  width: double.infinity,
                  // height: 250.5,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 10),
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "پس از ثبت سفارش متخصصین ما در مدت کوتاهی به شما پاسخ خواهند داد .",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        // SizedBox(height: 20),
                        SizedBox(height: 10),

                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                            bottom: 25,
                          ),
                          child: Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,

                                    builder: (context) {
                                      return SizedBox(
                                        // height: 75,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Container(
                                              height: 450,
                                              child: ListView.builder(
                                                itemCount: cities.length,

                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    title: Text(
                                                      cities[index],
                                                      textDirection:
                                                          TextDirection.rtl,
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        selectedCity =
                                                            cities[index];
                                                      });
                                                      Navigator.pop(
                                                        context,
                                                        cities[index],
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },

                                style: ElevatedButton.styleFrom(
                                  // padding: const EdgeInsets.symmetric(horizontal: 55,vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                label: Text(selectedCity),
                                icon: const Icon(Icons.location_on_outlined),
                              ),

                              SizedBox(width: 25),

                              ElevatedButton(
                                onPressed: () {
                                  Get.to(
                                    SetOrderPage(
                                      id: widget.id,
                                      city: selectedCity,
                                    ),
                                  );
                                },

                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 55,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  backgroundColor: Colors.lightGreenAccent,
                                ),
                                child: Text(
                                  'ثبت سفارش',
                                  style: TextStyle(color: Colors.black45),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}
