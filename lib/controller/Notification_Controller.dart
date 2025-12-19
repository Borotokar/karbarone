import 'dart:async';

import 'package:borotokar/Congit.dart';
import 'package:borotokar/controller/DataBaseController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // برای تبدیل داده‌ها به JSON

class NotificationController extends GetxController {
  var notifications = [].obs; // لیست اعلان‌ها
  var unseenNotifications = 0.obs; // لیست اعلان‌های دیده‌نشده
  var isLoading = false.obs; // وضعیت بارگذاری
  final DatabaseController dbController = Get.find<DatabaseController>();

  @override
  void onInit() async {
    super.onInit();
    // Timer.periodic(Duration(seconds: 10), (Timer timer) async{
    //   fetchNotifications(false);
    // });
  }

  // متد برای دریافت اعلان‌ها از API
  Future<void> fetchNotifications(bool seen) async {
    isLoading(true); // شروع بارگذاری
    final tokenEntity = await dbController.tokendao.findTokenById(1);

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${tokenEntity?.token}',
    };
    String apiUrl = '$API_URL/user/notifs';
    if (seen) {
      apiUrl = '$API_URL/user/notifs?seen=${seen}';
    }

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // اعلان‌های دیده شده و دیده نشده را از پاسخ سرور دریافت می‌کنیم
        notifications.value = data['notif'];
        unseenNotifications.value = data['noseen'].length;
      } else {
        // Get.snackbar('خطا', 'دریافت اعلان‌ها ناموفق بود.');
      }
    } catch (e) {
      // مدیریت خطا
      // Get.snackbar('خطا', 'مشکلی در اتصال به سرور وجود دارد.');
    } finally {
      isLoading(false); // پایان بارگذاری
    }
  }

  // متد برای علامت‌گذاری به عنوان دیده‌شده
}
