import 'package:borotokar/Congit.dart';
import 'package:borotokar/controller/DataBaseController.dart';
import 'package:borotokar/pages/Home.dart';
import 'package:borotokar/pages/Mesage.dart';
import 'package:borotokar/utils/mesage/mesagePage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SuportConversationsController extends GetxController {
  var conversations = {}.obs; // این متغیر لیست واکنش‌پذیر برای ذخیره گفتگوهاست
  var isLoading = false.obs;
  var conversationDetails = {}.obs; // متغیری برای نگهداری جزئیات گفتگو
  var messages = [].obs;
  var seen = 0.obs;
  final DatabaseController dbController = Get.find<DatabaseController>();

  @override
  void onInit() {
    super.onInit();
    // fetchConversationDetails();
  }

  // این تابع پیام را ارسال می‌کند
  Future<void> sendMessage(int conversationId, String messageContent) async {
    final tokenEntity = await dbController.tokendao.findTokenById(1);

    if (tokenEntity != null) {
      final url = '$API_URL/user/s/conversations/$conversationId/messages';

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
        Get.log(response.statusCode.toString());
        if (response.statusCode == 200) {
          // پیام ارسال شد، حالا پیام‌ها را به‌روز می‌کنیم
          fetchConversationDetails();
        } else {
          Get.snackbar('خطا', 'ارسال پیام با خطا مواجه شد');
        }
      } catch (e) {
        Get.snackbar('خطا', 'ارسال پیام با خطا مواجه شد');
      }
    }
  }

  Future<void> fetchConversationDetails() async {
    isLoading.value = true;

    final tokenEntity = await dbController.tokendao.findTokenById(1);

    if (tokenEntity != null) {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${tokenEntity.token}',
      };
      final response = await http.get(
        Uri.parse('$API_URL/user/s/conversations'),
        headers: headers,
      );
      ;

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        Get.log(jsonResponse.toString());
        messages.value = jsonResponse['messages'];
        conversationDetails.value = jsonResponse; // ذخیره جزئیات گفتگو
      } else {
        // Get.snackbar('خطا', 'دریافت جزئیات گفتگو با خطا مواجه شد');
      }
    }
    isLoading.value = false;
  }
}
