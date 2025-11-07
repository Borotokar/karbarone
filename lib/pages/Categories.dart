import 'dart:io';

import 'package:borotokar/Congit.dart';
import 'package:borotokar/controller/HomeController%20.dart';
import 'package:borotokar/utils/DividerWithTextWidget.dart';
import 'package:borotokar/utils/MyAppBar.dart';
import 'package:borotokar/utils/srbox.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:borotokar/utils/nav.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:borotokar/utils/MyBottomsheet.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  int _currentIndexe = 1;
  final HomeController homeController = Get.find<HomeController>();
  TextStyle num2 = const TextStyle(
    color: Colors.black54,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  TextStyle num1 = const TextStyle(color: Colors.black, fontSize: 14);
  ScrollController scrollController = ScrollController();
  List<GlobalKey> _sectionKeys = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (homeController.types.isEmpty ||
          homeController.appData.isEmpty ||
          homeController.popularServices.isEmpty) {
        await homeController.fetchHomeData();
      } else {
        homeController.isLoading.value = false;
      }
    });
    _sectionKeys = List.generate(
      homeController.types.length,
      (index) => GlobalKey(),
    );
  }

  void scrollToSection(int index) {
    if (index < _sectionKeys.length) {
      Scrollable.ensureVisible(
        _sectionKeys[index].currentContext!,
        duration: Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (i) async {
        await _showExitDialog();
        // return true;
      },
      child: Directionality(
        // add this
        textDirection: TextDirection.rtl,
        child: SafeArea(
          top: false,
          child: Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                homeController.fetchHomeData();
              },
              child: CustomScrollView(
                slivers: [
                  MyAppBar(),
                  // Other Sliver Widgets
                  // Container()
                  //  Text("danial")
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 150,
                          child: ListView.builder(
                            padding: EdgeInsets.only(right: 5, left: 5),
                            scrollDirection: Axis.horizontal,
                            itemCount: homeController.types.length,
                            itemBuilder: (context, index) {
                              final type = homeController.types[index];
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: SrBox(
                                  text: type['name'],
                                  image: CachedNetworkImage(
                                    imageUrl: IMG_API_URL + '${type['image']}',
                                    fit: BoxFit.contain,
                                    errorWidget:
                                        (context, url, error) =>
                                            Icon(Icons.error),
                                  ),
                                  nextPage: () => scrollToSection(index),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      Container(
                        width: Get.width,
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: homeController.types.length,
                          itemBuilder: (context, index) {
                            final type = homeController.types[index];
                            Get.log(type.toString());
                            return Container(
                              key: _sectionKeys[index],
                              child: Column(
                                children: [
                                  DividerWithTextWidget(text: type['name']),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 5,
                                      left: 5,
                                    ),
                                    child: StaggeredGrid.count(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 20,
                                      crossAxisSpacing: 20,
                                      children:
                                          type['category']
                                              .map<Widget>(
                                                (cat) => Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        cat['name'],
                                                        style: num2,
                                                        softWrap: true,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children:
                                                            cat['services']
                                                                .map<Widget>(
                                                                  (
                                                                    service,
                                                                  ) => GestureDetector(
                                                                    onTap: () {
                                                                      Get.bottomSheet(
                                                                        MyBottomSheet(
                                                                          id:
                                                                              service['id'],
                                                                          image:
                                                                              IMG_API_URL +
                                                                              service['image'],
                                                                          title:
                                                                              service['title'],
                                                                        ),
                                                                      );
                                                                    },
                                                                    child: Container(
                                                                      margin: EdgeInsets.only(
                                                                        bottom:
                                                                            5,
                                                                      ),
                                                                      child: Text(
                                                                        service['title'],
                                                                        style:
                                                                            num1,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                                .toList(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),

            bottomNavigationBar: Mynav(currentIndex: _currentIndexe),
          ),
        ),
      ),
    );
  }

  Future<bool> _showExitDialog() async {
    return (await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text(
                  'آیا از خروج خود اطمینان دارید ؟',
                  textDirection: TextDirection.rtl,
                ),
                // content:  Text('میخواهید از حساب خود خارج شوید ؟', textDirection: TextDirection.rtl),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('خیر', style: TextStyle(color: Colors.white)),
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.red),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => exit(0),
                    child: Text('بله', style: TextStyle(color: Colors.white)),
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.green),
                    ),
                  ),
                ],
              ),
        )) ??
        false;
  }
}
