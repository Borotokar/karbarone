import 'dart:async';

import 'package:badges/badges.dart';
import 'package:borotokar/controller/ConversationsController%20.dart';
import 'package:borotokar/controller/OrderController.dart';
import 'package:borotokar/pages/Categories.dart';
import 'package:borotokar/pages/Home.dart';
import 'package:borotokar/pages/Mesage.dart';
import 'package:borotokar/pages/Orders.dart';
import 'package:borotokar/pages/Profile.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;

class Mynav extends StatefulWidget {
  var currentIndex;
  Mynav({super.key, this.currentIndex});

  @override
  State<Mynav> createState() => _MynavState();
}

class _MynavState extends State<Mynav> {
  final ConversationsController controller =
      Get.find<ConversationsController>();

  final OrderServiceController orderController =
      Get.find<OrderServiceController>();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.seens();
      orderController.fetchOrders();
    });
    Timer.periodic(Duration(seconds: 50), (Timer timer) async {
      await controller.seens();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomNavigationBar(
      iconSize: 27.0,
      selectedColor: Color(0xff040307),
      strokeColor: Color.fromARGB(139, 4, 3, 7),
      unSelectedColor: Color(0xffacacac),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      // blurEffect: true,
      borderRadius: Radius.circular(15),

      items: [
        CustomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text("خانه", style: TextStyle(fontSize: 10)),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.list),
          title: Text("دسته بندی", style: TextStyle(fontSize: 10)),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.wysiwyg_outlined),
          title: Text("سفارش ها", style: TextStyle(fontSize: 10)),
        ),
        CustomNavigationBarItem(
          icon: badges.Badge(
            showBadge: controller.seen > 0,
            badgeContent: Obx(
              () => Text(
                '${controller.seen}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            child: Icon(Icons.message),
          ),

          title: Text("چت", style: TextStyle(fontSize: 10)),
        ),

        CustomNavigationBarItem(
          icon: Icon(Icons.account_circle_sharp),

          title: Text("پروفایل", style: TextStyle(fontSize: 10)),
        ),
      ],
      currentIndex: widget.currentIndex ?? 0,
      onTap: (index) {
        setState(() {
          if (widget.currentIndex != index) {
            switch (index) {
              case 0:
                Get.off(() => const MyHomePage(), opaque: false);
                break;

              case 1:
                Get.off(() => const CategoriesPage(), opaque: false);
                break;

              case 2:
                Get.off(() => const OrdersPage(), opaque: false);
                break;

              case 3:
                Get.off(() => const MesaggPage(), opaque: false);
                break;

              case 4:
                Get.off(() => const ProfilePage(), opaque: false);
                break;
              default:
            }
          }
        });
      },
    );
  }
}
