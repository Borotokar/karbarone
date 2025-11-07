import 'package:borotokar/Congit.dart';
import 'package:borotokar/utils/Order/CircularImageLoader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum OrderStatus { Processing, wellDone, Done, Canceled }

class OrderList extends StatelessWidget {
  final String image;
  final String title;
  final String datetime;
  final OrderStatus status;
  final Widget? nextPage;
  final List? bids;

  const OrderList({
    super.key,
    required this.image,
    required this.title,
    required this.datetime,
    required this.status,
    this.nextPage,
    this.bids,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: GestureDetector(
        onTap: () {
          if (nextPage != null) {
            Get.to(nextPage);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.greenAccent.withOpacity(0.10),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: _statusColor(status).withOpacity(0.3),
              width: 1.2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // تصویر سفارش
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    IMG_API_URL + image,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                // اطلاعات سفارش
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // عنوان سفارش
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // وضعیت سفارش
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 17,
                            color: _statusColor(status),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _statusToString(status),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: _statusColor(status),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // تاریخ و زمان
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 15,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            datetime,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // نمایش تعداد پیشنهادها
                      if (status == OrderStatus.Processing)
                        Text(
                          bids != null && bids!.isNotEmpty
                              ? "${bids!.length} پیشنهاد :"
                              : "منتظر پیشنهاد باشید",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      const SizedBox(height: 8),

                      // نمایش متخصصین پیشنهاددهنده
                      if (bids != null && bids!.isNotEmpty)
                        Wrap(
                          spacing: 4,
                          children:
                              bids!.map<Widget>((b) {
                                if (status == OrderStatus.Processing) {
                                  return CircularImageLoader(
                                    imageUrl:
                                        IMG_API_URL +
                                        b['expert']['profile_image'],
                                    size: 30.0,

                                    done:
                                        status == OrderStatus.Done
                                            ? true
                                            : false,
                                  );
                                } else if (status == OrderStatus.wellDone) {
                                  return Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Blue border circle
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.green,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      // Expert profile image
                                      CircularImageLoader(
                                        imageUrl:
                                            IMG_API_URL +
                                            b['expert']['profile_image'],
                                        size: 30.0,
                                        done: true,
                                      ),
                                    ],
                                  );
                                } else if (status == OrderStatus.Done) {
                                  return Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Blue border circle
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.blue,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      // Expert profile image
                                      CircularImageLoader(
                                        imageUrl:
                                            IMG_API_URL +
                                            b['expert']['profile_image'],
                                        size: 30.0,
                                        done: true,
                                      ),
                                    ],
                                  );
                                }
                                return Container();
                              }).toList(),
                        ),
                    ],
                  ),
                ),
                // دکمه جزئیات
                if (status != OrderStatus.Canceled)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        if (nextPage != null) {
                          Get.to(nextPage);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: const [
                            Text(
                              "جزئیات",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 16,
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _statusToString(OrderStatus status) {
    switch (status) {
      case OrderStatus.Processing:
        return "درحال پردازش";
      case OrderStatus.wellDone:
        return "درحال انجام";
      case OrderStatus.Done:
        return "انجام شده";
      case OrderStatus.Canceled:
        return "لغو شده";
    }
  }

  Color _statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.Processing:
        return Colors.orange;
      case OrderStatus.wellDone:
        return Colors.green;
      case OrderStatus.Done:
        return Colors.blue;
      case OrderStatus.Canceled:
        return Colors.redAccent;
    }
  }
}
