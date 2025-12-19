import 'package:borotokar/Congit.dart';
import 'package:borotokar/controller/DataBaseController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeController extends GetxController {
  var types = [].obs;
  var categories = [].obs;
  var popularServices = [].obs;
  var appData = {}.obs;
  var type = {}.obs;
  var popular_services_type = [].obs;
  var isLoading = false.obs;
  final DatabaseController dbController = Get.find<DatabaseController>();
  var isUpdateShow = false.obs;

  @override
  void onInit() {
    super.onInit();
    // fetchServices();
  }

  Future<void> fetchHomeData() async {
    isLoading.value = true;

    final tokenEntity = await dbController.tokendao.findTokenById(1);

    if (tokenEntity != null) {
      final url = Uri.parse(API_URL + '/user/home');

      // تنظیم هدر درخواست
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${tokenEntity.token}',
      };

      // ارسال درخواست GET
      final response = await http.get(url, headers: headers);
      Get.log(response.statusCode.toString());
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        types.value = data['types'];
        types.refresh();
        categories.value = data['categories'];
        categories.refresh();
        popularServices.value = data['popular_services'];
        popularServices.refresh();
        appData.value = data['appdata'];
      } else {
        // Get.snackbar('خطا', 'دریافت اطلاعات با خطا مواجه شد');
      }
    } else {
      // Get.snackbar('خطا', 'اتفاق غیر منتطره ای افتاد');
      // Get.to(() => const LoginPage());
    }
    isLoading.value = false;
    checkForUpdate();
  }

  Future<void> fetchTypeData(int id) async {
    isLoading.value = true;

    final tokenEntity = await dbController.tokendao.findTokenById(1);

    if (tokenEntity != null) {
      final url = Uri.parse(API_URL + '/user/type/${id}');

      // تنظیم هدر درخواست
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${tokenEntity.token}',
      };

      // ارسال درخواست GET
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Get.log(data['type'].toString());
        type.value = data['type'];
        // Get.log(data['type'].toString());
        popular_services_type.value = data['popular_services'];
      } else {
        // Get.snackbar('خطا', 'خطا در بارگذاری اطلاعات نوع');
      }
    } else {
      // Get.snackbar('خطا', 'اتفاق غیر منتطره ای افتاد');
      // Get.to(() => const LoginPage());
    }
    isLoading.value = false;
  }

  Future<void> checkForUpdate() async {
    try {
      if (!isUpdateShow.value) {
        // نسخه فعلی اپ
        final info = await PackageInfo.fromPlatform();
        final currentVersion = info.version;
        // Get.log('Current version: $currentVersion');
        // دریافت نسخه آخر از سرور
        final response = await http.get(
          Uri.parse('https://api.borotokar.com/app_version'),
        );

        Get.log("Response : ${response.body}");
        // بررسی وضعیت پاسخ
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final latestVersion = data['latest_version'];
          final forceUpdate = data['force_update'] ?? false;
          final message = data['message'] ?? 'نسخه جدید منتشر شد!';

          if (_isNewVersion(currentVersion, latestVersion) &&
              !isUpdateShow.value) {
            Future.delayed(Duration.zero, () {
              Get.dialog(
                WillPopScope(
                  onWillPop: () async => !forceUpdate,
                  child: AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    titlePadding: const EdgeInsets.only(
                      top: 24,
                      right: 24,
                      left: 24,
                      bottom: 8,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    title: Row(
                      children: [
                        const Icon(
                          Icons.system_update,
                          color: Colors.green,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'بروزرسانی اپلیکیشن',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                !forceUpdate
                                    ? Colors.green.withOpacity(0.08)
                                    : Colors.red.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: !forceUpdate ? Colors.green : Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  forceUpdate
                                      ? "این بروزرسانی اجباری است و بدون بروزرسانی نمی‌توانید ادامه دهید."
                                      : "می‌توانید بعداً نیز بروزرسانی کنید.",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color:
                                        !forceUpdate
                                            ? Colors.green
                                            : Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      if (!forceUpdate)
                        TextButton(
                          onPressed: () {
                            isUpdateShow.value = true;
                            Get.back();
                          },
                          child: const Text(
                            'بعداً',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          // لینک مارکت یا دانلود مستقیم
                          launchUrlString('https://borotokar.com/');
                        },
                        icon: const Icon(Icons.download, color: Colors.white),
                        label: const Text(
                          'بروزرسانی',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                barrierDismissible: !forceUpdate,
              );
            });
          }
        }
      }
    } catch (e) {
      // خطا در دریافت نسخه جدید
      Get.log('Error checking for updates: $e');
      Get.snackbar(
        'خطا',
        'مشکلی در بررسی بروزرسانی وجود دارد. لطفاً بعداً تلاش کنید.',
      );
    } finally {
      isUpdateShow.value = true; // برای جلوگیری از نمایش مجدد
    }
  }

  // مقایسه نسخه‌ها
  bool _isNewVersion(String current, String latest) {
    List<int> c = current.split('.').map(int.parse).toList();
    List<int> l = latest.split('.').map(int.parse).toList();
    for (int i = 0; i < l.length; i++) {
      if (c.length <= i || l[i] > c[i]) return true;
      if (l[i] < c[i]) return false;
    }
    return false;
  }
}
