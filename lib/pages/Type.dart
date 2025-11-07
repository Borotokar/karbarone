import 'package:borotokar/Congit.dart';
import 'package:borotokar/controller/HomeController%20.dart';
import 'package:borotokar/pages/Order.dart';
import 'package:borotokar/pages/searchpage.dart';
import 'package:borotokar/utils/Home/catCards.dart';
import 'package:borotokar/utils/Item.dart';
import 'package:borotokar/utils/listoftest.dart';
import 'package:borotokar/utils/nav.dart';
import 'package:borotokar/utils/srbox.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TypePage extends StatefulWidget {
  final int id;
  const TypePage({super.key, required this.id});

  @override
  State<TypePage> createState() => _TypePageState();
}

class _TypePageState extends State<TypePage> {
  final HomeController homeController = Get.find<HomeController>();
  final ScrollController scrollController = ScrollController();
  List<GlobalKey> _sectionKeys = [];
  int _currentIndex = 0;
  int _currentIndexe = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await homeController.fetchTypeData(widget.id);
      _initSectionKeys();
    });
  }

  void _initSectionKeys() {
    final categories = homeController.type['category'];
    if (categories != null && categories is List) {
      setState(() {
        _sectionKeys = List.generate(categories.length, (index) => GlobalKey());
      });
    }
  }

  void scrollToSection(int index) {
    if (index < _sectionKeys.length) {
      final ctx = _sectionKeys[index].currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (homeController.isLoading.value) {
        return SafeArea(
          top: false,
          child: Scaffold(
            body: Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.greenAccent,
                size: 50,
              ),
            ),
          ),
        );
      }

      final categories = homeController.type['category'] ?? [];
      if (_sectionKeys.length != categories.length) {
        _sectionKeys = List.generate(categories.length, (index) => GlobalKey());
      }

      return Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          top: false,
          child: Scaffold(
            body: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  snap: false,
                  centerTitle: true,
                  automaticallyImplyLeading: true,
                  title: Text('خدمات ${homeController.type['name'] ?? ""}'),
                  actions: [],
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(60),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: GestureDetector(
                        onTap: () => Get.to(() => SearchPage()),
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.greenAccent.withOpacity(0.5),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 12),
                              const Icon(
                                Icons.search,
                                color: Colors.green,
                                size: 26,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "جستجو کنید ...",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding: const EdgeInsets.all(6),
                                child: const Icon(
                                  Icons.mic,
                                  color: Colors.green,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    // دسته‌بندی‌ها به صورت افقی
                    Container(
                      height: 120,
                      child: ListView.builder(
                        padding: EdgeInsets.only(right: 15, left: 15, top: 15),
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final c = categories[index];
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SrBox(
                              text: c['name'],
                              widget: 65,
                              image: Image.network(
                                IMG_API_URL + '${c['image']}',
                                fit: BoxFit.contain,
                              ),
                              undertitle: true,
                              nextPage: () {
                                scrollToSection(index);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, right: 8.0),
                      child: Text(
                        "خدمات محبوب ${homeController.type['name'] ?? ""} :",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    // اسلایدر خدمات محبوب
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CarouselSlider(
                        items:
                            homeController.popular_services_type.map<Widget>((
                              card,
                            ) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromARGB(1, 0, 0, 0),
                                          blurRadius: 0.001,
                                          spreadRadius: 0.1,
                                        ),
                                      ],
                                    ),
                                    height:
                                        MediaQuery.of(context).size.height + 10,
                                    width: MediaQuery.of(context).size.width,
                                    child: Card(
                                      color: Colors.white,
                                      child: Item(
                                        image: IMG_API_URL + card['image'],
                                        title: card["title"],
                                        des:
                                            card['des'] != null &&
                                                    card['des'].length > 10
                                                ? "${card['des'].substring(card['des'].length - 10)} ..."
                                                : card['des'] ?? "",
                                        id: card['id'],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                        options: CarouselOptions(
                          height: 275.0,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration: Duration(
                            milliseconds: 800,
                          ),
                          autoPlayCurve: Curves.bounceOut,
                          pauseAutoPlayOnTouch: true,
                          aspectRatio: 2.0,
                          onPageChanged: ((index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          }),
                        ),
                      ),
                    ),
                    // دایره‌های پایین اسلایدر
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: map<Widget>(
                        homeController.popular_services_type,
                        (index, url) {
                          return Container(
                            width: 5.0,
                            height: 5.0,
                            margin: EdgeInsets.symmetric(
                              vertical: 1.0,
                              horizontal: 0.5,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  _currentIndex == index
                                      ? const Color.fromARGB(139, 0, 0, 0)
                                      : Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                    // لیست دسته‌بندی‌ها و سرویس‌ها
                    Container(
                      width: Get.width,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final cat = categories[index];
                          final services = cat['services'] ?? [];
                          return CatCard(
                            key: _sectionKeys[index],
                            title: cat['name'],
                            listCards: ListView(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              children:
                                  services.map<Widget>((s) {
                                    return ListCard(
                                      title: s['title'],
                                      image: s['image'],
                                      id: s['id'],
                                    );
                                  }).toList(),
                            ),
                          );
                        },
                      ),
                    ),
                  ]),
                ),
              ],
            ),
            bottomNavigationBar: Mynav(currentIndex: _currentIndexe),
          ),
        ),
      );
    });
  }
}
