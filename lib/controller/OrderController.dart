import 'dart:io';

import 'package:borotokar/Congit.dart';
import 'package:borotokar/controller/DataBaseController.dart';
import 'package:borotokar/network/OrderRequest.dart';
import 'package:borotokar/pages/Orders.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderServiceController extends GetxController {
  var service = {}.obs;
  var isLoading = true.obs;
  var orders = [].obs;
  var orderDetail = {}.obs;
  final DatabaseController dbController = Get.find<DatabaseController>();

  Future<void> fetchService(int id) async {
    final tokenEntity = await dbController.tokendao.findTokenById(1);

    if (tokenEntity != null) {
      try {
        isLoading(true);
        final url = Uri.parse(API_URL + '/user/orderservice/$id');

        // تنظیم هدر درخواست
        final headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${tokenEntity.token}',
        };

        // ارسال درخواست GET
        final response = await http.get(url, headers: headers);

        if (response.statusCode == 200) {
          service.value = jsonDecode(response.body)['service'];
          Get.log(service.toString());
        } else {
          // Get.snackbar('خطا', 'خطا در بارگذاری اطلاعات سرویس');
        }
      } catch (e) {
        // Get.snackbar('خطا', 'خطا در بارگذاری اطلاعات سرویس');
      } finally {
        isLoading(false);
      }
    }
  }

  Future<void> submitOrder(OrderRequest orderRequest) async {
    final tokenEntity = await dbController.tokendao.findTokenById(1);

    final url = Uri.parse(API_URL + '/user/order');

    if (tokenEntity != null) {
      isLoading(true);
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',

          'Authorization': 'Bearer ${tokenEntity.token}',
        },
        body: jsonEncode(orderRequest.toJson()),
      );
      final Map<String, dynamic> data = jsonDecode(response.body);
      // Get.log(data.toString());
      if (response.statusCode == 200) {
        // موفقیت‌آمیز بود
        Get.log('Order submitted successfully');
        Get.snackbar("موفقیت", "سفارش با موفقیت اضافه شد.");
        isLoading(false);
        Get.offAll(() => OrdersPage());
      } else {
        // خطا
        Get.log('Failed to submit order: ${response.body}');
        isLoading(false);
      }
    }
  }

  Future<void> fetchOrders() async {
    final url = API_URL + '/user/order';
    final tokenEntity = await dbController.tokendao.findTokenById(1);
    if (tokenEntity != null) {
      try {
        isLoading(true); // نمایش حالت بارگذاری
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${tokenEntity.token}',
          },
        );

        if (response.statusCode == 200) {
          orders.value = json.decode(response.body);
          getTotalUnseenProposalsCount(orders);
        } else {
          // Get.snackbar('خطا', 'دریافت اطلاعات با خطا مواجه شد');
          // Get.log(response.body.toString());
        }
      } catch (error) {
        // Get.snackbar('خطا', 'خطا در بارگذاری اطلاعات: $error');
      } finally {
        isLoading(false); // پایان حالت بارگذاری
      }
    }
  }

  int getTotalUnseenProposalsCount(List<dynamic> orders) {
    int total = 0;

    for (final order in orders) {
      // اگه مقدار وجود داشته باشه و عدد باشه

      if (order['status'] == 2) {
        final unseen = order['unseen_bids_count'];
        Get.log(unseen.toString());
        if (unseen is int) {
          total += unseen;
        }
      }
    }

    return total;
  }

  Future<void> updatefetchOrders() async {
    final url = API_URL + '/user/order';
    final tokenEntity = await dbController.tokendao.findTokenById(1);
    if (tokenEntity != null) {
      try {
        // isLoading(true); // نمایش حالت بارگذاری
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${tokenEntity.token}',
          },
        );

        if (response.statusCode == 200) {
          orders.value = json.decode(response.body);
          // Get.log(orders.toString());
        } else {
          // Get.snackbar('خطا', 'دریافت اطلاعات با خطا مواجه شد');
        }
      } catch (error) {
        // Get.snackbar('خطا', 'خطا در بارگذاری اطلاعات');
      } finally {
        // isLoading(false); // پایان حالت بارگذاری
      }
    }
  }

  Future<void> fetchOrderDetail(int orderId) async {
    final url = API_URL + '/user/order/$orderId';
    final tokenEntity = await dbController.tokendao.findTokenById(1);
    if (tokenEntity != null) {
      try {
        orderDetail.value = {};
        isLoading.value = true; // نمایش حالت بارگذاری
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${tokenEntity.token}',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          orderDetail.value = data;
        } else {
          // Get.snackbar('خطا', 'دریافت اطلاعات با خطا مواجه شد');
        }
      } catch (error) {
        // Get.snackbar('خطا', 'خطا در بارگذاری اطلاعات:');
      } finally {
        isLoading.value = false; // پایان حالت بارگذاری
      }
    }
  }

  Future<void> conformExpert(int orderId, int expert_id) async {
    final url = API_URL + '/user/order/conform/$orderId/$expert_id';
    final tokenEntity = await dbController.tokendao.findTokenById(1);
    if (tokenEntity != null) {
      try {
        orderDetail.value = {};
        isLoading.value = true; // نمایش حالت بارگذاری
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${tokenEntity.token}',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          Get.snackbar('موفقیت', 'متخصص با موفقیت تایید شد !');
        } else {
          // Get.snackbar('خطا', json.decode(response.body).toString());
        }
      } catch (error) {
        // Get.snackbar('خطا', 'An error occurred: $error');
      } finally {
        // isLoading.value = false;
        fetchOrders(); // پایان حالت بارگذاری
      }
    }
  }

  Future<void> cancelExpert(int orderId, int expertId) async {
    final url = API_URL + '/user/order/cancelExpert/$orderId/$expertId';
    final tokenEntity = await dbController.tokendao.findTokenById(1);
    if (tokenEntity != null) {
      try {
        orderDetail.value = {};
        isLoading.value = true; // نمایش حالت بارگذاری
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${tokenEntity.token}',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          Get.snackbar('موفقیت', 'متخصص با موفقیت رد شد !');
        } else {
          // Get.snackbar('خطا', json.decode(response.body).toString());
        }
      } catch (error) {
        // Get.snackbar('Error', 'An error occurred: $error');
      } finally {
        // isLoading.value = false;
        fetchOrders(); // پایان حالت بارگذاری
      }
    }
  }

  Future<void> click(int expert_id, int service_id, Function onSuccess) async {
    final url = API_URL + '/user/order/click/$expert_id/$service_id';
    final tokenEntity = await dbController.tokendao.findTokenById(1);
    if (tokenEntity != null) {
      try {
        isLoading.value = true; // نمایش حالت بارگذاری
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${tokenEntity.token}',
          },
        );
        final data = json.decode(response.body);
        if (response.statusCode == 200) {
          // Get.snackbar('موفقیت', 'متخصص با موفقیت تایید شد !');
          onSuccess();
        } else {
          Get.snackbar('خطا', data['mesage']);
        }
      } catch (error) {
        // Get.snackbar('خطا', 'خطا در بارگذاری اطلاعات: $error');
      } finally {
        isLoading.value = false; // پایان حالت بارگذاری
      }
    }
  }

  Future<void> submitReview(
    int id,
    String comment,
    int rating,
    int orderId,
  ) async {
    isLoading.value = true;
    final tokenEntity = await dbController.tokendao.findTokenById(1);

    if (tokenEntity != null) {
      try {
        // URL را جایگزین کنید
        final String url = API_URL + '/user/reviews/$id';

        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${tokenEntity.token}',
          },
          body: json.encode({
            "comment": comment,
            "rating": rating,
            "order_id": orderId,
          }),
        );
        // final data = json.decode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          // درخواست موفق بود
          Get.snackbar('موفق', 'نظر با موفقیت ارسال شد');
        } else {
          // خطا
          Get.snackbar('خطا', 'خطا در اسال نظر');
        }
      } catch (e) {
        Get.log('خطا در بارگذاری اطلاعات: $e');
      } finally {
        isLoading.value = false;
        Get.off(() => OrdersPage());
      }
    }
  }

  Future<void> editReview(int id, String comment, double rating) async {
    isLoading.value = true;
    final tokenEntity = await dbController.tokendao.findTokenById(1);

    if (tokenEntity != null) {
      try {
        // URL را جایگزین کنید
        final String url = API_URL + '/user/updateReview/$id';

        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${tokenEntity.token}',
          },
          body: json.encode({"comment": comment, "rating": rating}),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          // درخواست موفق بود
          Get.snackbar('موفقیت', 'نظر با موفقیت ویرایش شد');
        } else {
          // خطا
          Get.snackbar('خطا', 'خطا در ارسال نظر');
        }
      } catch (e) {
        // Get.snackbar('Error', 'An error occurred: $e');
      } finally {
        isLoading.value = false;
        Get.off(() => OrdersPage());
        // fetchOrderDetail(id);
      }
    }
  }

  Future<void> cancellOrder(int orderId) async {
    final url = API_URL + '/user/order/cancel/$orderId';
    final tokenEntity = await dbController.tokendao.findTokenById(1);
    if (tokenEntity != null) {
      try {
        isLoading(true); // نمایش حالت بارگذاری
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${tokenEntity.token}',
          },
        );

        if (response.statusCode == 200) {
          Get.snackbar('لغو سفارش موفقیت آمیز بود', '');
          Get.to(() => OrdersPage());
        } else {
          Get.snackbar('خطا', 'خطا در کنسل کردن سفارش');
        }
      } catch (error) {
        Get.log('An error occurred: $error');
      } finally {
        isLoading(false);
      }
    }
  }
}
