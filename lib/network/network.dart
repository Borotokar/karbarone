import 'dart:convert';
import 'package:borotokar/AppDatabase.dart';
import 'package:borotokar/Congit.dart';
import 'package:borotokar/database/Token.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>?> fetchUserData(String token) async {
  final url = Uri.parse(API_URL + '/user/me');

  // تنظیم هدر درخواست
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  // ارسال درخواست GET
  final response = await http.get(url, headers: headers);

  // بررسی وضعیت پاسخ
  if (response.statusCode == 200) {
    // دیکود کردن پاسخ JSON به Map
    final Map<String, dynamic> data = jsonDecode(response.body);
    return data;
  } else {
    // در صورت خطا
    print('Failed to load user data. Status code: ${response.statusCode}');
    return null;
  }
}

Future<bool> requestOtp(String mobileNumber) async {
  final url = Uri.parse(API_URL + '/user/login');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    body: jsonEncode({'login_id': mobileNumber}),
  );
  final data = jsonDecode(response.body);
  // Get.snackbar('Error', data.toString());
  if (response.statusCode == 200 &&
      data['msg'] == 'کد شما با موفقیت ارسال شد .') {
    // موفقیت‌آمیز بودن ارسال درخواست
    return true;
  } else {
    // خطا در ارسال درخواست
    Get.snackbar('Error', data['msg']);

    return false;
  }
}

Future<dynamic?> verifyOtp(String mobileNumber, String otpCode) async {
  final url = Uri.parse(API_URL + '/user/otp_login');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'login_id': mobileNumber, 'otp': otpCode}),
  );

  final data = jsonDecode(response.body);
  if (response.statusCode == 200) {
    return data;
  } else if (data != null) {
    return null;
  } else {
    Get.snackbar('Error', 'خطای غیر منتظره ای رخ داد');
    return null;
  }
}

Future<void> saveToken(String token) async {
  final database =
      await $FloorAppDatabase.databaseBuilder('AppDatabase.db').build();
  final tokenDao = database.tokenDao;

  final tokenEntity = Token(1, token);
  await tokenDao.insertToken(tokenEntity);
}

Future<bool> registerUser(
  String firstName,
  String lastName,
  String gender,
  String token,
) async {
  final url = Uri.parse(API_URL + '/user/login_rigster');

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode({
      'first_name': firstName,
      'last_name': lastName,
      'sex': gender,
    }),
  );

  if (response.statusCode == 200) {
    // موفقیت‌آمیز بودن ثبت‌نام
    return true;
  } else {
    // خطا در ثبت‌نام
    print('Failed to register user. Status code: ${response.statusCode}');
    return false;
  }
}

Future<bool> editUser(String name, String gender, String token) async {
  final url = Uri.parse(API_URL + '/user/edit');

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode({'name': name, 'sex': gender}),
  );

  if (response.statusCode == 200) {
    // موفقیت‌آمیز بودن ثبت‌نام
    return true;
  } else {
    // خطا در ثبت‌نام
    print('Failed to register user. Status code: ${response.statusCode}');
    return false;
  }
}
