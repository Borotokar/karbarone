import 'dart:convert';
import 'package:borotokar/AppDatabase.dart';
import 'package:borotokar/Congit.dart';
import 'package:borotokar/controller/DataBaseController.dart';
import 'package:borotokar/database/Token.dart';
import 'package:borotokar/network/network.dart';
import 'package:borotokar/pages/BlockedPage.dart';
import 'package:borotokar/pages/Code.dart';
import 'package:borotokar/pages/Home.dart';
import 'package:borotokar/pages/Login.dart';
import 'package:borotokar/pages/LoginQPage.dart';
import 'package:borotokar/pages/rigister.dart';
import 'package:borotokar/service/notification_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class AuthController extends GetxController {
  var isAuthenticated = false.obs;
  var userData = {}.obs;
  var token = ''.obs;
  var isLoading = false.obs;
  var law = "".obs;
  final DatabaseController dbController = Get.find<DatabaseController>();

  @override
  void onInit() async {
    super.onInit();
    await dbController.initDatabase();
    checkToken();
  }

  Future<void> checkToken() async {
    // final Etoken = await dbController.tokendao.getToken();
    final database =
        await $FloorAppDatabase.databaseBuilder('AppDatabase.db').build();
    final Etoken = await database.tokenDao.getToken();

    if (Etoken == null) {
      Get.log("1234");
      isAuthenticated.value = false;

      Get.offAll(() => LoginQPage());
    } else {
      isAuthenticated.value = true;
      token.value = Etoken;
      await fetchAndSetUserData();
      await setFcmToken();
      if (userData['user']['status'] == "pending") {
        Get.off(() => const Blockedpage());
      } else {
        Get.off(() => MyHomePage());
      }
    }
  }

  Future<void> logout() async {
    isLoading.value = true;

    // حذف توکن
    await dbController.tokendao.deleteToken(Token(1, ''));
    isAuthenticated.value = false;
    Get.snackbar('با موفقیت خارج شدید', '');
    Get.offAll(() => LoginQPage());
    isLoading.value = false;
  }

  Future<void> fetchlaw() async {
    isLoading.value = true;

    final url = Uri.parse(API_URL + '/user/law');

    // تنظیم هدر درخواست
    final headers = {'Content-Type': 'application/json'};

    // ارسال درخواست GET
    final response = await http.get(url, headers: headers);
    final Map<String, dynamic> data = jsonDecode(response.body);
    // Get.log(data['law']);
    law.value = data['law'];
    // Get.log(userData.toString());
    isLoading.value = false;
  }

  Future<void> fetchAndSetUserData() async {
    isLoading.value = true;
    final tokenEntity = await dbController.tokendao.findTokenById(1);

    if (tokenEntity != null) {
      final url = Uri.parse(API_URL + '/user/me');

      // تنظیم هدر درخواست
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${tokenEntity.token}',
      };

      try {
        final response = await http.get(url, headers: headers);
        final Map<String, dynamic> data = jsonDecode(response.body);
        userData.value = data;
        Get.log(data['user']['status'].toString());

        if (data['user']['name'] == null) {
          Get.off(() => const Rigister());
        }
      } catch (e) {
        // مدیریت خطا
        print(e);
        Get.log('خطا مشکلی در اتصال به سرور وجود دارد.');
      } finally {
        if (userData.value.isNotEmpty) {
          isLoading(false); // پایان بارگذاری
        }
      }

      // ارسال درخواست GET
      // Get.log(userData.toString());
      // isLoading.value = false;
    }
  }

  Future<void> loginUser1(String mobileNumber) async {
    // درخواست برای دریافت OTP
    isLoading.value = true;
    final otpSent = await requestOtp(mobileNumber);
    if (otpSent) {
      Get.to(() => CodePage(number: mobileNumber));
      isLoading.value = false;
    }
    isLoading.value = false;
  }

  Future<void> loginUser2(String mobileNumber, String otpCode) async {
    isLoading.value = true;
    // درخواست برای تایید OTP و دریافت توکن
    final data = await verifyOtp(mobileNumber, otpCode);
    final token = data['token'];
    if (token != null) {
      // ذخیره توکن
      await saveToken(token);
      isAuthenticated.value = true;
      if (data['status'] == 'rigster') {
        isLoading.value = false;
        Get.offAll(() => Rigister());
      } else if (data['status'] == 'login') {
        Get.snackbar('با موفقیت وارد شدید .', '');
        isLoading.value = false;
        setFcmToken();
        Get.offAll(() => MyHomePage());
      }
    } else if (data['msg'] == "کد وارد شده اشتباه می باشد") {
      isLoading.value = false;
      Get.snackbar('خطا', '${data['msg']}');
      // Get.to(()=>CodePage(number: mobileNumber,));
    }
    isLoading.value = false;
  }

  Future<void> registerUserAndProceed(
    String firstName,
    String lastName,
    String gender,
  ) async {
    isLoading.value = true;

    final tokenEntity = await dbController.tokendao.findTokenById(1);

    if (tokenEntity != null) {
      final success = await registerUser(
        firstName,
        lastName,
        gender,
        tokenEntity.token,
      );
      if (success) {
        // موفقیت‌آمیز بودن ثبت‌نام
        Get.snackbar('موفقیت', 'اطلاعات با موفقیت ثبت شد.');
        Get.offAll(() => MyHomePage());
      } else {
        Get.snackbar('خطا', 'ثبت اطلاعات ناموفق بود.');
      }
    }
    isLoading.value = false;
  }

  Future<void> editUserInfo(String name, String gender) async {
    isLoading.value = true;

    final tokenEntity = await dbController.tokendao.findTokenById(1);

    if (tokenEntity != null) {
      final success = await editUser(name, gender, tokenEntity.token);
      if (success) {
        // موفقیت‌آمیز بودن ثبت‌نام
        Get.snackbar('موفقیت', 'اطلاعات با موفقیت ثبت شد.');
        Get.offAll(() => MyHomePage());
      } else {
        Get.snackbar('خطا', 'ثبت اطلاعات ناموفق بود.');
      }
    }
    isLoading.value = false;
  }

  Future<void> setFcmToken() async {
    final fcmToken = await NotificationService.instance.getToken();
    final tokenEntity = await dbController.tokendao.findTokenById(1);
    if (tokenEntity != null) {
      final url = Uri.parse(API_URL + '/user/set-fcm-token');

      // تنظیم هدر درخواست
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${tokenEntity.token}',
      };

      // ارسال درخواست POST
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({'fcm_token': fcmToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Get.log('FCM token set successfully: ${data['message']}');
      } else {
        Get.log('Error setting FCM token: ${response.statusCode}');
      }
    }
  }
}
