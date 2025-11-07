import 'package:borotokar/utils/listoftest.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CatPage extends StatefulWidget {
  // final String title;
  final dynamic cat;
  const CatPage({super.key, required this.cat});

  @override
  State<CatPage> createState() => _CatPageState();
}

class _CatPageState extends State<CatPage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      // add this
      textDirection: TextDirection.rtl,
      child: SafeArea(
        top: false,
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: true,
                snap: false,
                centerTitle: true,
                automaticallyImplyLeading: true,

                title: Text(widget.cat['name']),

                actions: [],
              ),

              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      widget.cat['slogan'],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Wrap(
                      children:
                          widget.cat['services']
                              .map<Widget>(
                                (s) => ListCard(
                                  title: s['title'],
                                  image: s['image'],
                                  id: s['id'],
                                  height: 100,
                                  textSize: 12,
                                  width: Get.width / 2.7,
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ]),
              ),
            ],
          ),

          // bottomNavigationBar: Mynav(currentIndex: _currentIndexe)
        ),
      ),
    );
  }
}
