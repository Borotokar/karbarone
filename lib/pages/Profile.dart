import 'dart:io';

import 'package:borotokar/Congit.dart';
import 'package:borotokar/controller/AuthController.dart';
import 'package:borotokar/controller/ProfileController%20.dart';
import 'package:borotokar/pages/Orders.dart';
import 'package:borotokar/utils/Profile/BlockedExperts.dart';
import 'package:borotokar/utils/Profile/PListCard.dart';
import 'package:borotokar/utils/Profile/editpage.dart';
import 'package:borotokar/utils/Profile/Law.dart';
import 'package:borotokar/utils/Profile/address.dart';
import 'package:borotokar/utils/mesage/suportMesagePage.dart';
import 'package:borotokar/utils/mesage/suportMesagecart.dart';
import 'package:borotokar/utils/nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndexe = 4;
  String name = "";
  String phone = "";
  String image = "";

  AuthController authController = Get.find();
  Future<void> _launchURL(String surl) async {
    Uri url = Uri.parse(surl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $surl');
    }
  }

  final ProfileController _profileController = Get.find<ProfileController>();

  void _showImagePicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('انتخاب از گالری'),
                onTap: () {
                  _profileController.pickImage(ImageSource.gallery, context);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('گرفتن عکس با دوربین'),
                onTap: () {
                  _profileController.pickImage(ImageSource.camera, context);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    // authController.fetchAndSetUserData();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await authController.fetchAndSetUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (i) async {
        _showExitDialog();
        // return true;
      },
      child: Directionality(
        // add this
        textDirection: TextDirection.rtl,
        child: SafeArea(
          top: false,
          child: Scaffold(
            appBar: AppBar(
              title: Text("پروفایل", style: const TextStyle(fontSize: 30)),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),

            body: RefreshIndicator(
              onRefresh: () async {
                await authController.fetchAndSetUserData();
              },
              child: Obx(() {
                if (authController.isLoading.value) {
                  return Scaffold(
                    body: Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.greenAccent,
                        size: 50,
                      ),
                    ),
                  );
                }

                return CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),

                            Center(
                              child: Container(
                                width: 160,
                                height: 160,

                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      IMG_API_URL +
                                          authController
                                              .userData['user']['picture'],
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton.outlined(
                                          onPressed: () {
                                            _showImagePicker(context);
                                          },
                                          style: const ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                  Colors.white,
                                                ),
                                            iconColor: MaterialStatePropertyAll(
                                              Colors.black,
                                            ),
                                          ),
                                          icon: const Icon(Icons.edit),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),

                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    authController.userData['user']['name'],
                                    style: const TextStyle(fontSize: 30),
                                  ),
                                  Text(
                                    "شماره تلفن : ${authController.userData['user']['phone_number']} ",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),

                            const Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Text(
                                "پروفایل :",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            PlistCard(
                              icon: const Icon(
                                Icons.account_box_rounded,
                                color: Colors.lightGreen,
                              ),
                              title: "ویرایش اطلاعات",
                              onPressed: () => Get.to(() => const Editpage()),
                            ),
                            //  PlistCard(icon: const FaIcon(FontAwesomeIcons.solidAddressCard, color: Colors.lightGreen,), title: "لیست آدرس ها", onPressed: ()=>Get.to(()=>const AddressPage()),),
                            PlistCard(
                              icon: const Icon(
                                Icons.wysiwyg_outlined,
                                color: Colors.lightGreen,
                              ),
                              title: "لیست سفارشات",
                              onPressed:
                                  () => Get.offAll(() => const OrdersPage()),
                            ),

                            PlistCard(
                              icon: const Icon(
                                Icons.block,
                                color: Colors.lightGreen,
                              ),
                              title: "متخصصین بلاک شده",
                              onPressed: () => Get.to(() => Blockedexperts()),
                            ),

                            const Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Text(
                                "همه جا با بروتوکار :",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            PlistCard(
                              icon: const FaIcon(
                                FontAwesomeIcons.instagram,
                                color: Colors.pink,
                              ),
                              title: "اینستاگرام",
                              onPressed:
                                  () => _launchURL(
                                    "https://www.instagram.com/borotokarofficial/",
                                  ),
                            ),
                            PlistCard(
                              icon: const FaIcon(
                                FontAwesomeIcons.linkedin,
                                color: Colors.blue,
                              ),
                              title: "لینکداین",
                              onPressed:
                                  () => _launchURL(
                                    'https://www.linkedin.com/in/%D9%85%D9%88%D8%B3%D8%B3%D9%87-%D9%BE%DA%98%D9%88%D9%87%D8%B4%DB%8C-%D8%A8%D8%B1%D9%88-%D8%AA%D9%88-%DA%A9%D8%A7%D8%B1-%D8%AF%D8%A7%D9%86%D8%B4-775086332/',
                                  ),
                            ),
                            PlistCard(
                              icon: const FaIcon(
                                FontAwesomeIcons.telegram,
                                color: Colors.blue,
                              ),
                              title: "تلگرام",
                              onPressed:
                                  () => _launchURL(
                                    "t.me/@Borotokarofficial_Admin",
                                  ),
                            ),
                            PlistCard(
                              icon: const FaIcon(
                                FontAwesomeIcons.whatsapp,
                                color: Colors.green,
                              ),
                              title: "واتساپ",
                              onPressed:
                                  () => _launchURL(
                                    'https://wa.me/message/UUI7X6I2DOYLK1',
                                  ),
                            ),
                            PlistCard(
                              icon: const Icon(Icons.web, color: Colors.red),
                              title: "وبلاگ",
                              onPressed:
                                  () => _launchURL(
                                    'https://www.borotokar.com/%d9%85%d8%ac%d9%84%d9%87-%d8%a8%d8%b1%d9%88-%d8%aa%d9%88-%da%a9%d8%a7%d8%b1/',
                                  ),
                            ),
                            PlistCard(
                              icon: const FaIcon(
                                FontAwesomeIcons.blog,
                                color: Colors.red,
                              ),
                              image: "images/eatalogo.png",
                              title: "ایتا",
                              onPressed:
                                  () => _launchURL(
                                    'https://eitaa.com/@borotokar',
                                  ),
                            ),

                            const Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Text(
                                "معرفی بروتوکار :",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            PlistCard(
                              icon: const Icon(
                                Icons.share,
                                color: Colors.lightGreen,
                              ),
                              title: "معرفی به دوستان",
                              onPressed:
                                  () => Share.share(
                                    ' «من با بروتوکار کار می‌کنم و دیگه برای هیچ کاری سردرگم نیستم! 😍 \n از سفارش تعمیرکار و نظافت گرفته تا ده‌ها سرویس دیگه، همه توی یه اپ. \n تو هم نصبش کن و راحت شو 😉 \n borotokar.com',
                                  ),
                            ),

                            const Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Text(
                                "پشتیبانی و تنظیمات:",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            PlistCard(
                              icon: const FaIcon(
                                FontAwesomeIcons.headset,
                                color: Colors.lightGreen,
                              ),
                              title: "پشتیبانی",
                              onPressed: () => _showBottomSheet(context),
                            ),
                            PlistCard(
                              icon: const FaIcon(
                                FontAwesomeIcons.circleInfo,
                                color: Colors.lightGreen,
                              ),
                              title: "شرایط و قوانین",
                              onPressed:
                                  () =>
                                      _launchURL("https://borotokar.com/law/"),
                            ),
                            PlistCard(
                              icon: const FaIcon(
                                FontAwesomeIcons.download,
                                color: Colors.lightGreen,
                              ),
                              title: "اپلیکیشن متخصصین بروتوکار",
                              onPressed:
                                  () => _launchURL(
                                    "https://borotokar.com/expert/",
                                  ),
                            ),
                            PlistCard(
                              icon: const Icon(
                                Icons.exit_to_app_outlined,
                                color: Colors.lightGreen,
                              ),
                              title: "خروج",
                              onPressed: () => _onWillPop(),
                            ),

                            const SizedBox(height: 50),
                            const Center(
                              child: Column(
                                children: [
                                  Text("V : 1.5.0"),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("in iran"),
                                      SizedBox(width: 5),
                                      FaIcon(
                                        FontAwesomeIcons.solidHeart,
                                        color: Colors.lightGreen,
                                        size: 13,
                                      ),
                                      SizedBox(width: 5),
                                      Text("made with"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ]),
                    ),
                  ],
                );
              }),
            ),

            bottomNavigationBar: Mynav(currentIndex: _currentIndexe),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 170,
          padding: EdgeInsets.only(bottom: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCircleButton(
                context,
                icon: Icons.phone,
                text: 'تماس',
                onTap: () => launchUrlString('tel:02191010373'),
              ),
              _buildCircleButton(
                context,
                icon: Icons.support_agent,
                text: 'پشتیبانی',
                onTap:
                    () => Get.to(
                      () => suportMesagePage(id: 1),
                    ), // لینک صفحه تیکت‌ها
              ),
              _buildCircleButton(
                context,
                icon: Icons.question_answer,
                text: 'سوالات متداول',
                onTap:
                    () => launchUrl(
                      Uri.parse(
                        'https://www.borotokar.com/%d8%b3%d9%88%d8%a7%d9%84%d8%a7%d8%aa-%d9%85%d8%aa%d8%af%d8%a7%d9%88%d9%84/',
                      ),
                    ), // لینک صفحه سوالات متداول
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCircleButton(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor,
            ),
            padding: EdgeInsets.all(16),
            child: Icon(icon, color: Colors.white),
          ),
          SizedBox(height: 8),
          Text(text),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
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
                    onPressed: () => authController.logout(),
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
