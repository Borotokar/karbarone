import 'dart:io';
import 'package:borotokar/Congit.dart';
import 'package:borotokar/controller/HomeController .dart';
import 'package:borotokar/pages/Type.dart';
import 'package:borotokar/utils/Home/Banner.dart';
import 'package:borotokar/utils/Home/catCards.dart';
import 'package:borotokar/utils/MyAppBar.dart';
import 'package:borotokar/utils/Order/ExpertProfile.dart';
import 'package:borotokar/utils/listoftest.dart';
import 'package:borotokar/utils/nav.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:borotokar/utils/Item.dart';
import 'package:borotokar/utils/srbox.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final HomeController homeController = Get.find<HomeController>();
  int _currentIndex = 0;
  int _currentIndexe = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await authController.fetchAndSetUserData();
      if (homeController.types.isEmpty ||
          homeController.appData.isEmpty ||
          homeController.popularServices.isEmpty) {
        await homeController.fetchHomeData();
      } else {
        homeController.isLoading.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        top: false,
        child: Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              await homeController.fetchHomeData();
            },
            child: Obx(() {
              if (homeController.isLoading.value) {
                return Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.greenAccent,
                    size: 50,
                  ),
                );
              }

              List<String> banners =
                  [
                    homeController.appData['baneer1'],
                    homeController.appData['baneer2'],
                    homeController.appData['baneer3'],
                    homeController.appData['baneer4'],
                  ].whereType<String>().toList();

              List<dynamic> experts =
                  [
                    homeController.appData['expert1'],
                    homeController.appData['expert2'],
                    homeController.appData['expert3'],
                    homeController.appData['expert4'],
                  ].where((e) => e != null).toList();

              return CustomScrollView(
                slivers: [
                  MyAppBar(),

                  // دسته‌بندی‌ها با استایل مدرن
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        spacing: 18,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children:
                            homeController.types
                                .map(
                                  (type) => SrBox(
                                    key: ValueKey(type['id']),
                                    text: type['name'],
                                    image: CachedNetworkImage(
                                      imageUrl:
                                          IMG_API_URL + '${type['image']}',
                                      fit: BoxFit.contain,
                                      errorWidget:
                                          (context, url, error) =>
                                              const Icon(Icons.error),
                                    ),
                                    nextPage:
                                        () => Get.to(
                                          () => TypePage(id: type['id']),
                                        ),
                                    widget: Get.width * 0.23,
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ),

                  // عنوان خدمات محبوب
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 8.0,
                        right: 16.0,
                        bottom: 2,
                      ),
                      child: Text(
                        "خدمات محبوب این ماه :",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff222b45),
                        ),
                      ),
                    ),
                  ),

                  // اسلایدر خدمات محبوب
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                      child: CarouselSlider(
                        items:
                            homeController.popularServices.map((card) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.greenAccent.withOpacity(
                                            0.10,
                                          ),
                                          blurRadius: 14,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    child: Card(
                                      elevation: 7,
                                      margin: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      color: Colors.white,
                                      child: Item(
                                        key: ValueKey(card['id']),
                                        image: IMG_API_URL + card['image'],
                                        title: card["title"],
                                        des:
                                            card['des'].length > 30
                                                ? "${card['des'].substring(0, 30)} ..."
                                                : card['des'],
                                        id: card['id'],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                        options: CarouselOptions(
                          height: 250.0,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 5),
                          autoPlayAnimationDuration: const Duration(
                            milliseconds: 800,
                          ),
                          autoPlayCurve: Curves.easeInOut,
                          enlargeCenterPage: true,
                          viewportFraction: 0.78,
                          scrollPhysics: const BouncingScrollPhysics(),
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  // دایره‌های وضعیت اسلایدر
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          homeController.popularServices.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: _currentIndex == index ? 18.0 : 7.0,
                            height: 7.0,
                            margin: const EdgeInsets.symmetric(horizontal: 3.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color:
                                  _currentIndex == index
                                      ? Colors.greenAccent
                                      : Colors.grey.shade300,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // بنر تبلیغاتی و دسته‌بندی‌ها به صورت یکی در میان
                  SliverToBoxAdapter(
                    child: Column(
                      children: buildBannerAndCategories(
                        banners,
                        homeController.categories,
                        experts,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
          bottomNavigationBar: Mynav(currentIndex: _currentIndexe),
        ),
      ),
    );
  }
}

// ساخت بنر تبلیغاتی با ظاهر مدرن و اطلاعات متخصص
Widget buildBannerWidget(
  String bannerUrl,
  List<String> banners,
  List<dynamic> experts,
) {
  return Padding(
    padding: const EdgeInsets.only(
      left: 10.0,
      top: 10.0,
      right: 10.0,
      bottom: 32,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "اینجا محل تبلیغات شماست :",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xff222b45),
          ),
        ),
        const SizedBox(height: 10),
        CarouselSlider.builder(
          itemCount: banners.length,
          itemBuilder: (context, index, realIdx) {
            final expert = (index < experts.length) ? experts[index] : null;
            return GestureDetector(
              onTap:
                  expert == null
                      ? null
                      : () {
                        Get.to(
                          () => EProfile(
                            gallery: expert['gallery'],
                            comments: expert['comments'],
                            telegram_link: expert['telegram_link'],
                            service_id: 1,
                            website_link: expert['website_link'],
                            whatsapp_link: expert['whatsapp_link'],
                            about_me: expert['about_me'],
                            address: expert['address'],
                            eitaa_link: expert['eitaa_link'],
                            expert_id: expert['id'],
                            firstName: expert['first_name'],
                            lastName: expert['last_name'],
                            garanty: expert['guarantee'],
                            image: expert['profile_image'],
                            phone_number: expert['phone_number'],
                            proposal: false,
                            rate: calculateAverageRating(expert['comments']),
                          ),
                        );
                      },
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 6.0,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.13),
                      blurRadius: 18,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.greenAccent.withOpacity(0.18),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      MyBanner(
                        image: IMG_API_URL + banners[index],
                        width: Get.width * 0.96,
                        height: 200,
                      ),
                      if (expert != null)
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.45),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    IMG_API_URL + expert['profile_image'],
                                  ),
                                  radius: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    "${expert['first_name']} ${expert['last_name']}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                    Text(
                                      calculateAverageRating(
                                        expert['comments'],
                                      ).toStringAsFixed(1),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 220,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            enlargeCenterPage: true,
            viewportFraction: 0.82,
            initialPage: 0,
          ),
        ),
      ],
    ),
  );
}

// ساخت دسته‌بندی با لیست افقی سرویس‌ها
Widget buildCategoryWidget(cat) {
  return CatCard(
    title: cat['name'],
    listCards: SizedBox(
      height: 150,
      child: ListView.builder(
        itemCount: cat['services'].length > 5 ? 5 : cat['services'].length,
        scrollDirection: Axis.horizontal,
        cacheExtent: 2000.0,
        itemBuilder: (context, index) {
          final s = cat['services'][index];
          if (index < 4) {
            return ListCard(
              title: s['title'],
              image: s['image'],
              id: s['id'],
              key: ValueKey(s['id']),
            );
          } else if (index == 4) {
            return ListCard(
              key: ValueKey(s['id']),
              title: "مشاهده موارد بیشتر",
              image: s['image'],
              id: s['id'],
              more: true,
              cats: cat,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    ),
  );
}

// بنر و دسته‌بندی‌ها یکی در میان
List<Widget> buildBannerAndCategories(
  List<String> banners,
  List<dynamic> categories,
  List<dynamic> experts,
) {
  List<Widget> combinedList = [];
  int minLength =
      banners.length < categories.length ? banners.length : categories.length;

  for (int i = 0; i < categories.length; i++) {
    if (i == 1 && banners.isNotEmpty) {
      combinedList.add(
        buildBannerWidget(banners[i % banners.length], banners, experts),
      );
    }
    combinedList.add(buildCategoryWidget(categories[i]));
  }
  return combinedList;
}

// محاسبه میانگین امتیاز
double calculateAverageRating(comments) {
  if (comments == null || comments.isEmpty) return 0.0;
  double totalRating = 0.0;
  for (var comment in comments) {
    totalRating += comment['rating'];
  }
  return totalRating / comments.length;
}
