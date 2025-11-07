import 'package:borotokar/controller/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Blockedpage extends StatefulWidget {
  const Blockedpage({super.key});

  @override
  State<Blockedpage> createState() => _BlockedpageState();
}

class _BlockedpageState extends State<Blockedpage> {
  AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app, color: Colors.black),
              onPressed: () async {
                await _onWillPop();
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 100.0, color: Colors.red),
              const SizedBox(height: 20.0),
              Text(
                'حساب شما محدود شده است',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 10.0),
              Text(
                'برای رفع محدودیت با پشتیبانی تماس بگیرید',
                style: TextStyle(fontSize: 16.0, color: Colors.black54),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _showBottomSheet(context);
                },
                child: Text('تماس با پشتیبانی'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text(
                  'آیا از خروج از حساب خود اطمینان دارید ؟',
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
                text: 'تیکت‌ها',
                onTap:
                    () => launchUrl(
                      Uri.parse("https://www.borotokar.com/ticket/"),
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
}
