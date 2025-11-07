import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:borotokar/controller/OrderController.dart';
import 'package:borotokar/utils/Order/ProposalCard.dart';
import 'package:borotokar/utils/Order/prossingCard.dart';
import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/route_manager.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:url_launcher/url_launcher_string.dart';

class POrdersPage extends StatefulWidget {
  const POrdersPage({
    super.key,
    this.title = "danial",
    required this.id,
    this.done = false,
    required this.data,
  });
  final title;
  final int id;
  final data;
  final done;
  @override
  State<POrdersPage> createState() => _POrdersPageState();
}

class _POrdersPageState extends State<POrdersPage> {
  final OrderServiceController controller = Get.find();
  var expert = null;
  var activeStep = 0.obs;
  int activeStep2 = 0;
  int reachedStep = 0;
  int upperBound = 1;
  double progress = 0.2;
  final commentController = TextEditingController();
  Set<int> reachedSteps = <int>{0, 2, 3};
  double rate = 0.0;
  final dashImages = [];
  // final _formKey = GlobalKey<FormBuilderState>();
  double calculateAverageRating(comments) {
    if (comments.isEmpty) {
      return 0.0;
    }

    double totalRating = 0.0;

    for (var comment in comments) {
      totalRating += comment['rating'];
    }

    double averageRating = totalRating / comments.length;
    return averageRating;
  }

  // late double _rating = 2.5;

  // // final double _userRating = 3.0;
  // // final int _ratingBarMode = 1;
  // double _initialRating = 5;
  // // final bool _isRTLMode = false;
  // final bool _isVertical = false;

  void increaseProgress() {
    if (progress < 1) {
      setState(() {
        progress += 0.2;
      });
    } else {
      setState(() {
        progress = 0;
      });
    }
  }

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // controller.fetchOrderDetail(widget.id);
    // });

    super.initState();
  }

  String formatOrderDate(String completionDate, String completionTime) {
    // جدا کردن سال، ماه و روز از رشته
    List<String> parts = completionDate.split('-');
    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int day = int.parse(parts[2]);

    // ایجاد شیء Jalali
    Jalali jalaliDate = Jalali(year, month, day);
    Get.log(jalaliDate.toString());
    // Convert to Jalali (Shamsi)
    // final jalaliDate = Jalali.fromGregorian(Gregorian.fromDateTime(gregorianDate));
    // Extract time
    final time = completionTime.split(":");
    String startHour = time[0];
    String endHour =
        (int.parse(startHour) + 2).toString(); // Assuming job takes 2 hours

    // Get weekday in Persian
    final weekDayMap = {
      1: 'شنبه',
      2: 'یک‌شنبه',
      3: 'دوشنبه',
      4: 'سه‌شنبه',
      5: 'چهارشنبه',
      6: 'پنج‌شنبه',
      7: 'جمعه',
    };
    String weekDay = weekDayMap[jalaliDate.weekDay] ?? '';

    // Format the final string
    String formattedDate =
        '$weekDay ${jalaliDate.day} ${jalaliDate.formatter.mN} از ساعت $startHour تا $endHour';

    return formattedDate;
  }

  // var f = NumberFormat.decimalPattern('vi_VN');
  var formate = NumberFormat("#,###", "en_US");

  var bid = <dynamic>[].obs;
  var bids = [].obs;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      // add this
      textDirection: ui.TextDirection.rtl,
      child: SafeArea(
        top: false,
        child: Scaffold(
          body: Obx(() {
            final order = widget.data;
            bids.value = widget.data['bids'];
            Get.log(bids.toString());
            if (bids.length == 1) {
              bid.value = [widget.data['bids'].first];
            }
            if (order['status'] == "1") {
              activeStep.value = 0;
            }
            if (order['status'] == "2") {
              activeStep.value = 1;
            }
            if (order['status'] == "3") {
              activeStep.value = 2;
            }
            if (widget.done) {
              activeStep.value = 3;
            }
            if (controller.isLoading.value) {
              return Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.greenAccent,
                  size: 50,
                ),
              );
            }

            // if (controller.orderDetail.isEmpty) {
            //   return const Center(child: Text('اطلاعات سفارش یافت نشد ، لطفا دوباره امتحان کنید'));
            // }

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  snap: false,
                  centerTitle: true,
                  automaticallyImplyLeading: true,

                  title: Text(order['service']['title']),

                  actions: [
                    if (!widget.done)
                      GestureDetector(
                        onTap: () {
                          if (!widget.done) {
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (BuildContext context) {
                                return SafeArea(
                                  top: false,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: Icon(
                                            Icons.preview,
                                            color: Colors.green,
                                          ),
                                          title: Text('پیش نمایش سفارش'),
                                          onTap: () {
                                            // فراخوانی تابع حذف گفتگو
                                            Navigator.pop(context);
                                            // اگر تابعش رو داری
                                            Get.dialog(
                                              AlertDialog(
                                                title: Text(
                                                  'پیش نمایش سفارش',
                                                  textAlign: TextAlign.right,
                                                ),
                                                content: SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      fileldCreator(
                                                        "زمان شروع کار",
                                                        formatOrderDate(
                                                          widget
                                                              .data['completion_date'],
                                                          widget
                                                              .data['completion_time'],
                                                        ),
                                                        Icons.date_range,
                                                      ),
                                                      fileldCreator(
                                                        "شهر",
                                                        widget.data['city'],
                                                        Icons
                                                            .location_on_outlined,
                                                      ),
                                                      Column(
                                                        children:
                                                            extractQuestionsAndAnswers(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    child: Text('بستن'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),

                                        ListTile(
                                          leading: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          title: Text('لغو سفارش'),
                                          onTap: () {
                                            // فراخوانی تابع حذف گفتگو
                                            Navigator.pop(context);
                                            // اگر تابعش رو داری
                                            showDialog(
                                              context: context,
                                              useSafeArea: true,

                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    'تأیید لغو سفارش',
                                                    textAlign: TextAlign.right,
                                                  ),
                                                  content: Text(
                                                    'آیا از لغو این سفارش مطمئن هستید؟',
                                                    textAlign: TextAlign.right,
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('خیر'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        controller.cancellOrder(
                                                          order['id'],
                                                        );
                                                      },
                                                      child: Text('بله'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                            // showModalBottomSheet(
                            //   context: context,

                            //   builder: (context) {
                            //     return SafeArea(
                            //       top: false,
                            //       child: SizedBox(
                            //         // height: 75,
                            //         child: Column(
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.end,
                            //           mainAxisAlignment: MainAxisAlignment.end,
                            //           mainAxisSize: MainAxisSize.min,
                            //           children: <Widget>[
                            //             Padding(
                            //               padding: const EdgeInsets.all(8.0),
                            //               child: ElevatedButton(
                            //                 onPressed: () {
                            //                   controller.cancellOrder(
                            //                     order['id'],
                            //                   );
                            //                 },

                            //                 style: ElevatedButton.styleFrom(
                            //                   padding: EdgeInsets.only(
                            //                     right: Get.width / 3,
                            //                     left: Get.width / 3,
                            //                   ),
                            //                   // fixedSize: Size(250, 8),
                            //                   shape: RoundedRectangleBorder(
                            //                     borderRadius:
                            //                         BorderRadius.circular(10.0),
                            //                   ),
                            //                   backgroundColor: Colors.black,
                            //                 ),
                            //                 child: const Text(
                            //                   'لغو سفارش',
                            //                   style: TextStyle(
                            //                     color: Colors.white,
                            //                     fontSize: 19,
                            //                   ),
                            //                 ),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     );
                            //   },
                            // );
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Icon(Icons.dehaze),
                        ),
                      ),
                  ],

                  bottom: AppBar(
                    automaticallyImplyLeading: false,
                    centerTitle: true,

                    title: SizedBox(
                      width: Get.width,

                      child: Column(
                        children: [
                          const SizedBox(height: 25),
                          EasyStepper(
                            activeStep: activeStep.value,
                            lineStyle: LineStyle(
                              lineLength: 80,
                              lineSpace: 0,

                              lineType: LineType.normal,
                              defaultLineColor: Colors.grey.shade300,

                              finishedLineColor: Colors.lightGreenAccent,
                              // lineDotRadius: 1.5,
                            ),

                            activeStepTextColor: Colors.black87,
                            unreachedStepTextColor: Colors.black54,
                            finishedStepTextColor: Colors.black87,

                            enableStepTapping: false,
                            showLoadingAnimation: false,
                            stepRadius: 8,
                            showStepBorder: false,
                            steps: [
                              EasyStep(
                                customStep: CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Colors.grey.shade300,
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor:
                                        activeStep.value >= 0
                                            ? Colors.lightGreenAccent
                                            : Colors.grey.shade300,
                                  ),
                                ),
                                customTitle: const Center(
                                  child: Text(
                                    'درحال پردازش',
                                    style: TextStyle(fontSize: 8),
                                  ),
                                ),
                                // title: ,
                              ),
                              EasyStep(
                                customStep: CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Colors.grey.shade300,
                                  child: CircleAvatar(
                                    radius: 7,
                                    backgroundColor:
                                        activeStep.value >= 1
                                            ? Colors.lightGreenAccent
                                            : Colors.grey.shade300,
                                  ),
                                ),
                                customTitle: const Center(
                                  child: Text(
                                    'مشاهده پیشنهاد',
                                    style: TextStyle(fontSize: 8),
                                  ),
                                ),
                                // topTitle: true,
                              ),
                              EasyStep(
                                customStep: CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Colors.grey.shade300,
                                  child: CircleAvatar(
                                    radius: 7,
                                    backgroundColor:
                                        activeStep.value >= 2
                                            ? Colors.lightGreenAccent
                                            : Colors.grey.shade300,
                                  ),
                                ),
                                customTitle: const Center(
                                  child: Text(
                                    "تماس با متخصص",
                                    style: TextStyle(fontSize: 8),
                                  ),
                                ),
                              ),
                              EasyStep(
                                customStep: CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Colors.grey.shade300,
                                  child: CircleAvatar(
                                    radius: 7,
                                    backgroundColor:
                                        activeStep.value >= 3
                                            ? Colors.lightGreenAccent
                                            : Colors.grey.shade300,
                                  ),
                                ),
                                customTitle: const Center(
                                  child: Text(
                                    "ثبت نظر",
                                    style: TextStyle(fontSize: 8),
                                  ),
                                ),
                              ),
                            ],
                            onStepReached: (index) => activeStep.value = index,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SliverList(
                  delegate: SliverChildListDelegate([
                    if (activeStep.value == 0)
                      const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.admin_panel_settings_outlined),
                                SizedBox(width: 10),
                                Text(
                                  "کمی صبر کنید درحال یافتن یک متخصص برای سفارش شما هستیم",
                                  style: TextStyle(fontSize: 8),
                                ),
                              ],
                            ),

                            ProssingCard(),
                            ProssingCard(),
                            ProssingCard(),
                          ],
                        ),
                      ),

                    if (activeStep.value == 1)
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.admin_panel_settings_outlined),
                                SizedBox(width: 10),
                                Text(
                                  "پیشنهاد های ارسال شده  !",
                                  style: TextStyle(fontSize: 8),
                                ),
                              ],
                            ),

                            Column(
                              children:
                                  bids
                                      .map<Widget>(
                                        (o) => ProposalCard(
                                          type: o['proposal_type']['name'],
                                          expert_id: o['expert']['id'],
                                          service_id: order['service_id'],
                                          about_me: o['expert']['about_me'],
                                          website_link:
                                              o['expert']['website_link'],
                                          garanty: o['expert']['guarantee'],
                                          address: o['expert']['address'],
                                          firstName: o['expert']['first_name'],
                                          lastName: o['expert']['last_name'],
                                          phone_number:
                                              o['expert']['phone_number'],
                                          eitaa_link: o['expert']['eitaa_link'],
                                          telegram_link:
                                              o['expert']['telegram_link'],
                                          whatsapp_link:
                                              o['expert']['whatsapp_link'],
                                          comments: o['expert']['comments'],
                                          gallery: o['expert']['gallery'],
                                          rate: calculateAverageRating(
                                            o['expert']['comments'],
                                          ),
                                          image: o['expert']['profile_image'],
                                          mesage: o['description'],
                                          proposed_price: formate.format(
                                            int.parse(o['proposed_price']),
                                          ),
                                          proposed_type: o['type'],
                                          call: false,
                                          // buttonName: 'ثبت نظر/س',
                                          onPrress: () {
                                            // Get.log(o['order_id'].toString()+"jyfhymf ");
                                            controller.conformExpert(
                                              o['order_id'],
                                              o['expert']['id'],
                                            );
                                            // controller.fetchOrderDetail(
                                            //   o['order_id'],
                                            // );
                                            bid.clear();
                                            bid.add(o);
                                            activeStep.value = 2;
                                            order['status'] = "3";
                                          },
                                        ),
                                      )
                                      .toList(),
                            ),
                          ],
                        ),
                      ),

                    if (activeStep.value == 2)
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.admin_panel_settings_outlined),
                                SizedBox(width: 10),
                                Text(
                                  "هشدار : از دادن اطلاعات نامربوط به افراد خودداری کنید!",
                                  style: TextStyle(fontSize: 8),
                                ),
                              ],
                            ),

                            Column(
                              children:
                                  bid
                                      .map<Widget>(
                                        (o) => ProposalCard(
                                          type: o['proposal_type']['name'],
                                          expert_id: o['expert']['id'],
                                          about_me: o['expert']['about_me'],
                                          service_id: order['service_id'],
                                          website_link:
                                              o['expert']['website_link'],
                                          garanty: o['expert']['guarantee'],
                                          address: o['expert']['address'],
                                          firstName: o['expert']['first_name'],
                                          lastName: o['expert']['last_name'],
                                          phone_number:
                                              o['expert']['phone_number'],
                                          eitaa_link: o['expert']['eitaa_link'],
                                          telegram_link:
                                              o['expert']['telegram_link'],
                                          whatsapp_link:
                                              o['expert']['whatsapp_link'],
                                          comments: o['expert']['comments'],
                                          gallery: o['expert']['gallery'],
                                          rate: calculateAverageRating(
                                            o['expert']['comments'],
                                          ),
                                          image: o['expert']['profile_image'],
                                          mesage: o['description'],
                                          proposed_price: o['proposed_price'],
                                          proposed_type: o['type'],
                                          buttonName: "ثبت نظر",
                                          buttonCancel: "لغو ",
                                          onButtonCancel: () async {
                                            await controller.cancelExpert(
                                              o['order_id'],
                                              o['expert']['id'],
                                            );
                                            activeStep.value = 1;
                                            order['status'] = "2";

                                            bid.clear();
                                            // controller.fetchOrderDetail(
                                            //   o['order_id'],
                                            // );
                                          },
                                          onPrress: () {
                                            setState(() {
                                              activeStep.value = 3;
                                              expert = o;
                                              order['status'] = "4";
                                            });
                                          },
                                        ),
                                      )
                                      .toList(),
                            ),
                          ],
                        ),
                      ),

                    if (activeStep.value == 3)
                      widget.done
                          ? expertProfileWiget(bid, order)
                          : commentWiget(order),
                  ]),
                ),
              ],
            );
          }),

          // bottomNavigationBar: Mynav(currentIndex: _currentIndexe)
        ),
      ),
    );
  }

  Widget commentWiget(order) {
    // Ensure expert is not null and has required fields
    if (expert == null || expert['expert'] == null) {
      return const Center(
        child: Text(
          "اطلاعات متخصص یافت نشد.",
          style: TextStyle(fontSize: 14, color: Colors.red),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.admin_panel_settings_outlined),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "سفارش شما تکمیل شده، لطفا برای بهبود خدمات نظر دهید!",
                  style: TextStyle(fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Row(
            children: [
              Icon(Icons.warning_amber),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "توجه داشته باشید ، نطر شما پس از تایید توسط پشتیبانی در پروفایل متخصص نمایش داده می شود .",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          ProposalCard(
            type: order['bids'].first['proposal_type']['name'],
            service_id: order['service_id'],
            expert_id: expert['expert']['id'],
            about_me: expert['expert']['about_me'],
            website_link: expert['expert']['website_link'],
            garanty: expert['expert']['guarantee'],
            address: expert['expert']['address'],
            firstName: expert['expert']['first_name'],
            lastName: expert['expert']['last_name'],
            phone_number: expert['expert']['phone_number'],
            eitaa_link: expert['expert']['eitaa_link'],
            telegram_link: expert['expert']['telegram_link'],
            whatsapp_link: expert['expert']['whatsapp_link'],
            comments: expert['expert']['comments'],
            gallery: expert['expert']['gallery'],
            rate: calculateAverageRating(expert['expert']['comments']),
            image: expert['expert']['profile_image'],
            mesage: expert['description'],
            proposed_price: expert['proposed_price'],
            proposed_type: expert['type'],
            comment: true,
            rating: RatingBar.builder(
              initialRating: rate > 0 ? rate : 1,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemSize: 25,
              itemCount: 5,
              itemBuilder:
                  (context, _) => const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {
                setState(() {
                  rate = rating;
                });
                Get.log(rate.toString());
              },
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(5),
            ),
            child: FormBuilderTextField(
              enableSuggestions: true,
              name: 'comment',
              controller: commentController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'نظرتون درمورد متخصص ...',
                hintTextDirection: ui.TextDirection.rtl,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (rate == 0.0) {
                  Get.snackbar('خطا', 'لطفا ستاره بدهید .');
                  return;
                }
                if (commentController.text.trim().isEmpty) {
                  commentController.text = "کاربر نظری ثبت نکرده !";
                  // return;
                }
                await controller.submitReview(
                  expert['expert']['id'],
                  commentController.text,
                  rate.toInt(),
                  expert['order_id'],
                );
                setState(() {
                  activeStep.value = 3;
                });
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: Colors.lightGreenAccent,
              ),
              child: const Text(
                'ثبت نظر و اتمام کار',
                style: TextStyle(color: Colors.black87, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  expertProfileWiget(bid, order) {
    if (order['user_review'] != []) {
      commentController.text = order['user_review'][0]['comment'];
      rate = order['user_review'][0]['rating'].toDouble();
    } else {
      commentController.text = "";
      rate = 0.0;
    }
    return Column(
      children: [
        Column(
          children:
              bid
                  .map<Widget>(
                    (o) => ProposalCard(
                      type: o['proposal_type']['name'],

                      done: true,
                      service_id: order['service_id'],
                      expert_id: o['expert']['id'],
                      about_me: o['expert']['about_me'],
                      website_link: o['expert']['website_link'],
                      garanty: o['expert']['guarantee'],
                      address: o['expert']['address'],
                      firstName: o['expert']['first_name'],
                      lastName: o['expert']['last_name'],
                      phone_number: o['expert']['phone_number'],
                      eitaa_link: o['expert']['eitaa_link'],
                      telegram_link: o['expert']['telegram_link'],
                      whatsapp_link: o['expert']['whatsapp_link'],
                      comments: o['expert']['comments'],
                      gallery: o['expert']['gallery'],
                      rate: calculateAverageRating(o['expert']['comments']),
                      image: o['expert']['profile_image'],
                      mesage: o['description'],
                      proposed_price: o['proposed_price'],
                      proposed_type: o['type'],
                      buttonName: "ثبت نظر",
                      onPrress: () {
                        setState(() {
                          activeStep.value = 3;
                          expert = o;
                          order['status'] = "4";
                        });
                      },

                      onCallButton: () async {
                        await controller.click(
                          o['expert']['id'],
                          order['service_id'],
                          () => launchUrlString(
                            "tel://${o['expert']['phone_number']}",
                          ),
                        );
                      },
                    ),
                  )
                  .toList(),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Row(
            children: [
              Icon(Icons.warning_amber),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "توجه داشته باشید ، نطر شما پس از تایید توسط پشتیبانی در پروفایل متخصص نمایش داده می شود .",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),

        // update review Container
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.black12,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "ویرایش نظر",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              RatingBar.builder(
                initialRating: rate,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemSize: 25,
                itemCount: 5,
                itemBuilder:
                    (context, _) => const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {
                  rate = rating;
                  Get.log(rate.toString());
                },
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                enableSuggestions: true,
                name: 'comment',
                controller: commentController,
                decoration: const InputDecoration(
                  labelText: 'نظر شما',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  controller.editReview(
                    order['id'],
                    commentController.text,
                    rate,
                  );
                  setState(() {
                    activeStep.value = 3;
                  });
                },
                child: const Text("ویرایش نظر"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget fileldCreator(String fildName, String data, IconData icon) {
    return Container(
      width: Get.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 15),
                  SizedBox(width: 3),
                  Text(
                    fildName,
                    style: TextStyle(fontSize: 10),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: const Divider(
                    height: 1,
                    thickness: 0.5,
                    color: Colors.black26,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3),
          Align(
            alignment: Alignment.center,
            child: Text(
              data,
              style: TextStyle(fontSize: 12),
              overflow: TextOverflow.visible,
              textAlign: TextAlign.right,
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  List<Widget> extractQuestionsAndAnswers() {
    List<Widget> result = [];

    // دسترسی به لیست answers
    if (widget.data["answers"] != null) {
      List<dynamic> answers = widget.data["answers"];

      for (var answerData in answers) {
        // دسترسی به سوال و جواب
        String question = answerData["question"]["question"];
        String answer = answerData["answer"];
        Get.log(answer);
        // ترکیب سوال و جواب در یک رشته
        // String formattedQA = "سوال: $question\nپاسخ: $answer";
        final formattedQA = fileldCreator("$question", "$answer", Icons.done);
        result.add(formattedQA);
      }
    }

    // پیمایش بر روی لیست answers

    return result;
  }
}
