import 'package:borotokar/pages/Login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginQPage extends StatefulWidget {
  const LoginQPage({super.key});

  @override
  State<LoginQPage> createState() => _LoginQPageState();
}

class _LoginQPageState extends State<LoginQPage> {
  var text = RichText(
    text: const TextSpan(
      // Note: Styles for TextSpans must be explicitly defined.
      // Child text spans will inherit styles from parent
      style: TextStyle(fontSize: 14.0, color: Colors.black),

      children: <TextSpan>[
        TextSpan(
          text: 'ثبت نام در بروتوکار به معنای قبول',
          style: TextStyle(fontSize: 10, fontFamily: 'kalameh'),
        ),
        TextSpan(
          text: ' قوانین و مقررات ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10,
            color: Colors.blue,
            fontFamily: 'kalameh',
          ),
        ),
        TextSpan(
          text:
              'استفاده از اپلیکیشن در حال حاضر و تمامی تغییرات بعدی می‌باشد .',
          style: TextStyle(fontSize: 10, fontFamily: 'kalameh'),
        ),
      ],
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Directionality(
      // add this
      textDirection: TextDirection.rtl,
      child: SafeArea(
        top: false,
        child: Scaffold(
          body: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 0, 255, 132), Colors.white],
                tileMode: TileMode.clamp,
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
              ),
            ),
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 12.0,
                          right: 12.0,
                          top: 75,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 250,
                              height: 250,

                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  image: AssetImage("images/borotokar2.png"),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(75),
                              ),
                            ),

                            SizedBox(height: 25),
                            Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      "لمسی به وسعت نیاز های شما !",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade800,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    "برای استفاده از اپلیکیشن وارد شوید .",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade800,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  // Text("کل فرآیند ثبت نام 7 دقیقه طول میکشد .", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // SizedBox(height: Get.height * 0.30,),
                  ]),
                ),
              ],
            ),
          ),

          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Material(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => LoginPage());
                            // Get.to(()=>VideoAuthentication());
                          },

                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(
                                // color: Color.fromARGB(255, 63, 157, 191)
                                color: Colors.green,
                              ),
                            ),

                            backgroundColor: Colors.white,
                          ),
                          child: Text(
                            'وارد شوید',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 15.0,
                  left: 15.0,
                  bottom: 20,
                ),
                child: text,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
