import 'package:borotokar/controller/AuthController.dart';
import 'package:borotokar/pages/Code.dart';
import 'package:borotokar/utils/Profile/Law.dart';
import 'package:borotokar/utils/srbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController authController = Get.find();
  final mobileController = TextEditingController();
  bool law = false;
  var text = RichText(
    text: const TextSpan(
      // Note: Styles for TextSpans must be explicitly defined.
      // Child text spans will inherit styles from parent
      style: TextStyle(fontSize: 14.0, color: Colors.black),
      children: <TextSpan>[
        TextSpan(
          text: 'همه ی ',
          style: TextStyle(fontSize: 16, fontFamily: 'kalameh'),
        ),
        TextSpan(
          text: ' قوانین و مقررات ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.blue,
            fontFamily: 'kalameh',
          ),
        ),
        TextSpan(
          text: 'می‌پذیرم .',
          style: TextStyle(fontSize: 16, fontFamily: 'kalameh'),
        ),
      ],
    ),
  );
  Future<void> _launchURL(String surl) async {
    Uri url = Uri.parse(surl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $surl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      // add this
      textDirection: TextDirection.rtl,
      child: SafeArea(
        top: false,
        child: Scaffold(
          body: Obx(() {
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
                SliverAppBar(
                  title: const Text('ورود به بروتوکار'),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      onPressed: () => _showBottomSheet(context),
                      icon: Icon(Icons.question_mark),
                    ),
                  ],
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: 55),

                    // SrBox(text: "", image: Image.asset('images/borotokar.jpg', fit: BoxFit.contain,) , undertitle: true, height: 350, widget: 350, ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FormBuilder(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "شماره تلفن خود را وارد کنید :",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Column(
                                children: [
                                  Container(
                                    width: 600,
                                    height: 100,
                                    decoration: const BoxDecoration(
                                      color: Colors.white10,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                    child: FormBuilderTextField(
                                      name: '1',
                                      onChanged: (val) {
                                        // Print the text value write into TextField
                                      },
                                      controller: mobileController,
                                      keyboardType: TextInputType.number,
                                      maxLength: 11,
                                      decoration: InputDecoration(
                                        labelText: 'شماره تلفن',
                                        hintTextDirection: TextDirection.rtl,

                                        border: OutlineInputBorder(
                                          // borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Row(
                                    children: [
                                      Checkbox(
                                        value: law,
                                        onChanged: (val) {
                                          setState(() {
                                            law = val!;
                                          });
                                        },
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _launchURL(
                                            "https://borotokar.com/law/",
                                          );
                                        },
                                        child: text,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // SizedBox(height: 10,),
                  ]),
                ),
              ],
            );
          }),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
                if (law) {
                  authController.loginUser1(mobileController.text);
                } else {
                  Get.snackbar('قوانین', 'تیک پذیرش قوانین را بزنید .');
                }
              },

              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 7,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),

                backgroundColor: Colors.lightGreenAccent,
              ),
              child: Text('دریافت کد', style: TextStyle(color: Colors.black45)),
            ),
          ),

          // bottomNavigationBar: Mynav(currentIndex: _currentIndexe)
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

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _navigateToUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
