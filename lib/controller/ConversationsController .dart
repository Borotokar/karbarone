import 'package:borotokar/Congit.dart';
import 'package:borotokar/controller/DataBaseController.dart';
import 'package:borotokar/pages/Home.dart';
import 'package:borotokar/pages/Mesage.dart';
import 'package:borotokar/utils/mesage/mesagePage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConversationsController extends GetxController {
  var conversations = [].obs; // این متغیر لیست واکنش‌پذیر برای ذخیره گفتگوهاست
  var isLoading = false.obs;
  var conversationDetails = {}.obs; // متغیری برای نگهداری جزئیات گفتگو
  var messages = [].obs;
  var blockingExperts = [].obs;
  var seen = 0.obs;
  final DatabaseController dbController = Get.find<DatabaseController>();

  @override
  void onInit() {
    super.onInit();
    // fetchConversations(); // وقتی کنترلر ایجاد می‌شود، گفتگوها را بارگذاری می‌کند
    // seens(); // وقتی کنترلر ایجاد می‌شود، تعداد پیام‌های خوانده نشده را بارگذاری می‌کند
  }

  // این تابع پیام را ارسال می‌کند
  Future<void> sendMessage(int conversationId, String messageContent) async {
    final tokenEntity = await dbController.tokendao.findTokenById(1);

    if (tokenEntity != null) {
      final url = '$API_URL/user/conversations/$conversationId/messages';

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${tokenEntity.token}',
          },
          body: json.encode({"message": messageContent}),
        );

        if (response.statusCode == 201) {
          // پیام ارسال شد، حالا پیام‌ها را به‌روز می‌کنیم
          fetchConversationDetails(conversationId);
        } else {
          Get.snackbar('خطا', 'خطا در ارسال پیام');
        }
      } catch (e) {
        Get.snackbar('خطا', 'خطا در ارسال پیام');
      }
    }
  }

  Future<void> fetchConversations({loading = true}) async {
    if (loading) {
      isLoading.value = true;
    }

    final tokenEntity = await dbController.tokendao.findTokenById(1);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${tokenEntity?.token}',
    };
    final response = await http.get(
      Uri.parse('$API_URL/user/conversations'),
      headers: headers,
    );

    var jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      conversations.value = jsonResponse; // ذخیره داده‌ها در لیست واکنش‌پذیر
      Get.log(jsonResponse.toString());
    } else {
      // اگر دریافت اطلاعات با خطا مواجه شد
      // Get.snackbar('خطا', 'دریافت اطلاعات با خطا مواجه شد');
    }

    isLoading.value = false;
  }

  Future<void> seens() async {
    // isLoading.value = true;

    final tokenEntity = await dbController.tokendao.findTokenById(1);

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${tokenEntity?.token}',
    };
    final response = await http.get(
      Uri.parse(API_URL + '/user/seen'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      seen.value = jsonResponse['count']; // ذخیره داده‌ها در لیست واکنش‌پذیر
    } else {
      // اگر دریافت اطلاعات با خطا مواجه شد
      // Get.snackbar('خطا', 'دریافت اطلاعات با خطا مواجه شد');
    }

    // isLoading.value = false;
  }

  Future<void> fetchConversationDetails(int id) async {
    isLoading.value = true;

    final tokenEntity = await dbController.tokendao.findTokenById(1);

    if (tokenEntity != null) {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${tokenEntity.token}',
      };
      final response = await http.get(
        Uri.parse('$API_URL/user/conversations/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        Get.log(response.body);
        var jsonResponse = json.decode(response.body);
        messages.value = jsonResponse['messages'];
        conversationDetails.value = jsonResponse; // ذخیره جزئیات گفتگو
      } else {
        // Get.snackbar('خطا', 'Failed to fetch conversation details');
      }
    }
    isLoading.value = false;
  }

  Future<void> reportUser({
    required int expertId,
    required String violationType,
    String? description,
  }) async {
    final tokenEntity = await dbController.tokendao.findTokenById(1);

    String apiUrl = '${API_URL}/user/report';
    if (tokenEntity != null) {
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'Bearer ${tokenEntity.token}', // توکن رو درست جایگزین کن
          },
          body: jsonEncode({
            'expert_id': expertId,
            'type': violationType,
            'description': description ?? '',
          }),
        );
        Get.log(response.body);
        if (response.statusCode == 200) {
          Get.snackbar('موفق', 'گزارش با موفقیت ارسال شد');
        } else {
          final data = jsonDecode(response.body);
          Get.snackbar('خطا', data['message'] ?? 'خطایی رخ داده است');
        }
      } catch (e) {
        // Get.snackbar('خطا', 'در اتصال به سرور مشکلی پیش آمد');
      }
    }
    Get.to(() => MyHomePage());
  }

  Future<void> deleteConversations(int conversationId) async {
    final tokenEntity = await dbController.tokendao.findTokenById(1);

    if (tokenEntity != null) {
      final url = '${API_URL}/user/conversations/$conversationId/delete';

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${tokenEntity.token}',
          },
        );
        Get.log(response.body);
        if (response.statusCode == 200) {
          // پیام ارسال شد، حالا پیام‌ها را به‌روز می‌کنیم
          fetchConversations();
        } else {
          Get.snackbar('خطا', 'خطا در پاک کردن گفتو گو');
        }
      } catch (e) {
        Get.snackbar('خطا', 'خطا در پاک کردن گفتو گو');
      }
    }
    Get.off(() => MesaggPage());
  }

  Future<void> blockExpert({required int expertId}) async {
    final tokenEntity = await dbController.tokendao.findTokenById(1);

    String apiUrl = '${API_URL}/user/block-expert';
    if (tokenEntity != null) {
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'Bearer ${tokenEntity.token}', // توکن رو درست جایگزین کن
          },
          body: jsonEncode({'expert_id': expertId}),
        );
        if (response.statusCode == 200) {
          Get.snackbar('موفق', 'متخصص با موفقیت مسدود شد');
        } else {
          final data = jsonDecode(response.body);
          Get.snackbar('خطا', data['message'] ?? 'خطایی رخ داده است');
        }
      } catch (e) {
        // Get.snackbar('خطا', 'در اتصال به سرور مشکلی پیش آمد');
      }
    }
    Get.to(() => MesaggPage());
  }

  Future<void> unblockExpert({required int expertId}) async {
    final tokenEntity = await dbController.tokendao.findTokenById(1);

    String apiUrl = '${API_URL}/user/unblock-expert';
    if (tokenEntity != null) {
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'Bearer ${tokenEntity.token}', // توکن رو درست جایگزین کن
          },
          body: jsonEncode({'expert_id': expertId}),
        );
        Get.log(response.body);
        if (response.statusCode == 200) {
          Get.snackbar('موفق', 'متخصص با موفقیت رفع مسدود شد');
        } else {
          final data = jsonDecode(response.body);
          Get.snackbar('خطا', data['message'] ?? 'خطایی رخ داده است');
        }
      } catch (e) {
        // Get.snackbar('خطا', 'در اتصال به سرور مشکلی پیش آمد');
      }
    }
    // await fetchBlockedExperts();
    Get.to(() => MesaggPage());
  }

  Future<void> fetchBlockedExperts() async {
    isLoading.value = true;
    final tokenEntity = await dbController.tokendao.findTokenById(1);

    if (tokenEntity != null) {
      final url = Uri.parse(API_URL + '/user/BlockedExperts');

      // تنظیم هدر درخواست
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${tokenEntity.token}',
      };

      try {
        final response = await http.get(url, headers: headers);
        final Map<String, dynamic> data = jsonDecode(response.body);
        // Get.log(response.body.toString());
        if (data['experts'] != null) {
          blockingExperts.value = data['experts'];
        }
      } catch (e) {
        // مدیریت خطا
        print(e);
        // Get.snackbar('خطا', 'مشکلی در اتصال به سرور وجود دارد.');
      } finally {
        isLoading.value = false;
      }
      // ارسال درخواست GET
      // Get.log(userData.toString());
      // isLoading.value = false;
    }
  }
}
