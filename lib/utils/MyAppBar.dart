import 'package:badges/badges.dart';
import 'package:borotokar/Congit.dart';
import 'package:borotokar/controller/AuthController.dart';
import 'package:borotokar/controller/NotificationController.dart';
import 'package:borotokar/controller/ServiceController.dart';
import 'package:borotokar/pages/Profile.dart';
import 'package:borotokar/pages/notification.dart';
import 'package:borotokar/pages/rigister.dart';
import 'package:borotokar/pages/searchpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MyAppBar extends StatefulWidget {
  const MyAppBar({super.key});

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  final Servicecontroller controller = Get.find<Servicecontroller>();
  final NotificationController _notificationController =
      Get.find<NotificationController>();

  final AuthController authController = Get.find();
  stt.SpeechToText _speech = stt.SpeechToText();
  TextEditingController _controller = TextEditingController();

  bool _isListening = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.fetchServices();
      _notificationController.fetchNotifications(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      snap: false,
      centerTitle: false,
      automaticallyImplyLeading: false,

      title: const Text('لمسی به وسعت نیاز های شما'),

      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 0.0, left: 4.0),
          child: IconButton(
            icon: badges.Badge(
              badgeContent: Obx(
                () => Text(
                  '${_notificationController.unseenNotifications}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              child: Icon(Icons.notifications, size: 35),
            ),
            onPressed: () {
              Get.to(() => NotifPage());
            },
          ),
        ),

        // Padding(
        //   padding: const EdgeInsets.only(right: 0.0, left: 4.0),
        //   child: IconButton(
        //     icon: const Icon(Icons.account_circle, size: 35,),
        //     onPressed: () {
        //       Get.to(()=>ProfilePage());
        //     },
        //   ),
        // ),
        // Padding(
        //   padding: const EdgeInsets.only(right: 0.0, left: 4.0),
        //   child: GestureDetector(
        //     child: Container(
        //       width: 40,
        //       height: 40,

        //       decoration: BoxDecoration(
        //         image: DecorationImage(
        //           image: NetworkImage(
        //             IMG_API_URL + authController.userData['user']['picture'] !=
        //                     null
        //                 ? IMG_API_URL +
        //                     authController.userData['user']['picture']
        //                 : 'https://api.borotokar.com/img/default.png',
        //           ),
        //           fit: BoxFit.cover,
        //         ),
        //         borderRadius: BorderRadius.circular(20),
        //       ),
        //     ),

        //     onTap: () => Get.to(() => ProfilePage()),
        //   ),
        // ),
      ],

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: GestureDetector(
            onTap: () => Get.to(() => SearchPage()),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
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
                  const Icon(Icons.search, color: Colors.green, size: 26),
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
                    child: const Icon(Icons.mic, color: Colors.green, size: 20),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
