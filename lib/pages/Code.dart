import 'dart:async';

import 'package:borotokar/controller/AuthController.dart';
import 'package:borotokar/pages/Home.dart';
import 'package:borotokar/utils/srbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CodePage extends StatefulWidget {
  final String number;
  const CodePage({super.key, required this.number});

  @override
  State<CodePage> createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> with CodeAutoFill {
  final AuthController authController = Get.find();
  final otpController = TextEditingController();
  var otpCode = "".obs;
  String otp = "";
  late Timer _timer;
  int _start = 120;
  bool _isButtonVisible = false;

  @override
  void initState() {
    _listenOtp();
    _startTimer();
    super.initState();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          _isButtonVisible = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    //  SmsAutoFill().unregisterListener();
    cancel();
    super.dispose();
  }

  @override
  void codeUpdated() {
    setState(() {
      otpCode.value = code!;
      Get.log("object");
    });
  }

  void _listenOtp() async {
    listenForCode();
    final String signature = await SmsAutoFill().getAppSignature;
    Get.log("OTP Listen is called sig : $signature");
    print("OTP Listen is called");
  }

  String get _timeDisplay {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void _resendCode() {
    // اینجا کد ارسال مجدد را اجرا کنید
    setState(() {
      _start = 120;
      _isButtonVisible = false;
      _startTimer();
    });
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

                    // SrBox(text: "", image: Image.asset('images/borotokar.jpg', fit: BoxFit.contain,), undertitle: true, height: 350, widget: 350, ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FormBuilder(
                        child: Column(
                          children: [
                            Text(
                              "کد ارسال شده به شماره ${widget.number} را وارد کنید :",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  // Container(
                                  //                 width: 600,
                                  //                 height: 50,
                                  //                 decoration: const BoxDecoration(
                                  //                   color: Colors.white10,
                                  //                   borderRadius: BorderRadius.all(Radius.circular(5))

                                  //                 )
                                  //                 ,
                                  //                 child: FormBuilderTextField(
                                  //                   name: '1',
                                  //                   onChanged: (val) {
                                  //                        // Print the text value write into TextField
                                  //                   },

                                  //                   controller: otpController,
                                  //                   decoration: InputDecoration(
                                  //                     counterText: otpCode,
                                  //                     labelText: 'کد ورود',
                                  //                     hintTextDirection: TextDirection.rtl,
                                  //                     border: OutlineInputBorder(
                                  //                       // borderSide: BorderSide.none,
                                  //                       borderRadius: BorderRadius.all(Radius.circular(5))
                                  //                     ),
                                  //                   ),

                                  //               ),),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: PinFieldAutoFill(
                                      currentCode: otpCode.value,
                                      decoration: BoxLooseDecoration(
                                        radius: Radius.circular(12),
                                        strokeColorBuilder: FixedColorBuilder(
                                          Colors.greenAccent,
                                        ),
                                      ),
                                      codeLength: 5,
                                      // onCodeChanged: (code) {
                                      //   print("OnCodeChanged : $code");
                                      //     otpCode = code!;

                                      // },
                                      onCodeChanged: (code) {
                                        // setState(() {
                                        otpCode.value = code!;
                                        // });
                                      },
                                      onCodeSubmitted: (val) {
                                        print("OnCodeSubmitted : $val");
                                      },
                                      autoFocus: true,
                                    ),
                                  ),

                                  //     SizedBox(height: 10),

                                  // FormBuilderCheckbox(name: "name", title: Text("همه ی قوانین و مقررات می پذیرم !", style: TextStyle(fontSize: 16),)),
                                ],
                              ),
                            ),
                            Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                if (!_isButtonVisible)
                                  Text(
                                    'زمان باقی‌مانده: $_timeDisplay',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                // SizedBox(height: 10),
                                if (_isButtonVisible)
                                  ElevatedButton(
                                    onPressed: () {
                                      authController.loginUser1(widget.number);
                                      _resendCode();
                                    },
                                    child: Text('ارسال مجدد کد'),
                                  ),
                              ],
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
                SmsAutoFill().unregisterListener();
                authController.loginUser2(widget.number, otpCode.value);
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
              child: Text('ورود', style: TextStyle(color: Colors.black45)),
            ),
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
}
