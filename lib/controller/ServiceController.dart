import 'dart:convert';
import 'package:borotokar/Congit.dart';
import 'package:borotokar/controller/DataBaseController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Servicecontroller extends GetxController {
  var filteredServices = [].obs;
  var services = [].obs;
  var isLoading = false.obs;
  final DatabaseController dbController = Get.find<DatabaseController>();

  @override
  void onInit() {
    super.onInit();
    // fetchServices();
  }

  void filterServices(String query) {
    if (query.isEmpty) {
      filteredServices.value = services;
    } else {
      filteredServices.value =
          services
              .where(
                (service) => service['title'].toString().toLowerCase().contains(
                  query.toLowerCase(),
                ),
              )
              .toList();
      Get.log(filteredServices.toString());
    }
  }

  void fetchServices() async {
    try {
      isLoading(true);
      final tokenEntity = await dbController.tokendao.findTokenById(1);

      if (tokenEntity != null) {
        final headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${tokenEntity.token}',
        };
        var response = await http.get(
          Uri.parse('$API_URL/user/services'),
          headers: headers,
        );
        if (response.statusCode == 200) {
          var data = json.decode(response.body) as List;
          services.value = data;
          filteredServices.value = services;
        } else {
          // Get.snackbar('خطا', 'مشکلی در دریافت اطلاعات پیش آمده است');
        }
      }
    } catch (e) {
      // Get.snackbar('خطا', 'اتصال به سرور امکان‌پذیر نیست');
    } finally {
      isLoading(false);
    }
  }
}
