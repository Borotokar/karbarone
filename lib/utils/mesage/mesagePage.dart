import 'package:borotokar/Congit.dart';
import 'package:borotokar/controller/ConversationsController%20.dart';
import 'package:borotokar/indicator/FetchMoreIndicator.dart';
import 'package:borotokar/pages/ReportUserPage.dart';
import 'package:borotokar/utils/Order/ExpertProfile.dart';
import 'package:borotokar/utils/mesage/msg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shamsi_date/shamsi_date.dart';

class MesPage extends StatefulWidget {
  final int id;
  const MesPage({super.key, required this.id});

  @override
  State<MesPage> createState() => _MesPageState();
}

class _MesPageState extends State<MesPage> {
  final ConversationsController controller =
      Get.find<ConversationsController>();
  final messageController = TextEditingController();
  var isBlocked = false.obs;

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

  String converttime(dateTimeStr) {
    DateTime utcDateTime = DateTime.parse(dateTimeStr);

    // تبدیل زمان به منطقه زمانی ایران
    DateTime iranDateTime = utcDateTime.add(Duration(hours: 3, minutes: 30));

    // سپس ساعت را از DateTime استخراج می‌کنیم
    String hour = iranDateTime.hour.toString().padLeft(2, '0'); // ساعت
    String minute = iranDateTime.minute.toString().padLeft(2, '0'); // ثانیه
    String day = Jalali.fromDateTime(iranDateTime).day.toString(); // ثانیه
    String month = Jalali.fromDateTime(iranDateTime).month.toString(); // ثانیه
    String years = Jalali.fromDateTime(iranDateTime).year.toString(); // ثانیه
    Get.log(Jalali.fromDateTime(iranDateTime).day.toString());
    // نمایش ساعت به صورت hh:mm:ss
    String iranTime = '$hour:$minute | $years/$month/$day';

    return iranTime; // خروجی: 23:40:56
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.fetchConversationDetails(widget.id);
      // await controller.fetchBlockedExperts();
      if (controller.conversationDetails['user_block']) {
        isBlocked.value = true;
      }
      if (controller.conversationDetails['expert_block']) {
        isBlocked.value = true;
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.fetchConversations(loading: false);
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      // add this
      textDirection: TextDirection.rtl,
      child: SafeArea(
        top: false,
        child: Scaffold(
          body: Obx(() {
            if (controller.isLoading.value) {
              return Scaffold(
                body: Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.greenAccent,
                    size: 50,
                  ),
                ),
              );
            }

            // for (var i = 0; i < controller.blockingExperts.length; i++) {

            // }

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  snap: false,

                  // centerTitle: true,
                  automaticallyImplyLeading: true,

                  title: GestureDetector(
                    onTap: () async {
                      await controller.fetchConversationDetails(widget.id);
                      if (controller.conversationDetails['expert'] != null) {
                        Get.to(
                          () => EProfile(
                            gallery:
                                controller
                                    .conversationDetails['expert']['gallery'],
                            comments:
                                controller
                                    .conversationDetails['expert']['comments'],
                            telegram_link:
                                controller
                                    .conversationDetails['expert']['telegram_link'],
                            service_id: 1,
                            website_link:
                                controller
                                    .conversationDetails['expert']['website_link'],
                            whatsapp_link:
                                controller
                                    .conversationDetails['expert']['whatsapp_link'],
                            about_me:
                                controller
                                    .conversationDetails['expert']['about_me'],
                            address:
                                controller
                                    .conversationDetails['expert']['address'],
                            eitaa_link:
                                controller
                                    .conversationDetails['expert']['eitaa_link'],
                            expert_id:
                                controller.conversationDetails['expert']['id'],
                            firstName:
                                controller
                                    .conversationDetails['expert']['first_name'],
                            lastName:
                                controller
                                    .conversationDetails['expert']['last_name'],
                            garanty:
                                controller
                                    .conversationDetails['expert']['guarantee'],
                            image:
                                controller
                                    .conversationDetails['expert']['profile_image'],
                            phone_number:
                                controller
                                    .conversationDetails['expert']['phone_number'],
                            proposal: false,
                            rate: calculateAverageRating(
                              controller
                                  .conversationDetails['expert']['comments'],
                            ),
                          ),
                        );
                      }
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                "${IMG_API_URL}${controller.conversationDetails['expert']['profile_image']}",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          controller
                                  .conversationDetails['expert']['first_name'] +
                              " " +
                              controller
                                  .conversationDetails['expert']['last_name'],
                        ),
                      ],
                    ),
                  ),

                  actions: [
                    IconButton(
                      icon: Icon(Icons.settings, size: 27),
                      onPressed: () {
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
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      title: Text('حذف گفتگو'),
                                      onTap: () {
                                        // فراخوانی تابع حذف گفتگو
                                        Navigator.pop(context);
                                        showDialog(
                                          context: context,

                                          builder:
                                              (context) => AlertDialog(
                                                title: Text(
                                                  'آیا از حذف گفتگو اطمینان دارید ؟',
                                                  textDirection:
                                                      TextDirection.rtl,
                                                ),
                                                // content:  Text('میخواهید از حساب خود خارج شوید ؟', textDirection: TextDirection.rtl),
                                                actions: <Widget>[
                                                  ElevatedButton(
                                                    onPressed:
                                                        () => Navigator.of(
                                                          context,
                                                        ).pop(false),
                                                    child: Text(
                                                      'خیر',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    style: const ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStatePropertyAll(
                                                            Colors.red,
                                                          ),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed:
                                                        () => controller
                                                            .deleteConversations(
                                                              widget.id,
                                                            ),
                                                    child: Text(
                                                      'بله',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    style: const ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStatePropertyAll(
                                                            Colors.green,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        ); // اگر تابعش رو داری
                                      },
                                    ),
                                    controller.conversationDetails['user_block']
                                        ? ListTile(
                                          leading: Icon(
                                            Icons.lock_open,
                                            color: Colors.green,
                                          ),
                                          title: Text('آنبلاک'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            controller.unblockExpert(
                                              expertId:
                                                  controller
                                                      .conversationDetails['expert']['id'],
                                            );
                                          },
                                        )
                                        : ListTile(
                                          leading: Icon(
                                            Icons.block,
                                            color: Colors.black,
                                          ),
                                          title: Text('مسدود کردن '),
                                          onTap: () {
                                            Navigator.pop(context);
                                            controller.blockExpert(
                                              expertId:
                                                  controller
                                                      .conversationDetails['expert']['id'],
                                            );
                                          },
                                        ),
                                    ListTile(
                                      leading: Icon(
                                        Icons.report,
                                        color: Colors.orange,
                                      ),
                                      title: Text('گزارش گفتگو'),
                                      onTap: () {
                                        // فراخوانی تابع گزارش
                                        Get.to(
                                          () => ReportUserPage(
                                            userId:
                                                controller
                                                    .conversationDetails['expert']['id'],
                                            type: "chat",
                                          ),
                                        );
                                        // controller.reportConversation(id);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),

                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Container(
                        width: Get.width,
                        height: Get.height * 0.76,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),

                        child: FetchMoreIndicator(
                          onAction: () async {
                            await controller.fetchConversationDetails(
                              widget.id,
                            );
                          },
                          child: ListView(
                            reverse: true,
                            children:
                                controller
                                    .conversationDetails['messages']
                                    .reversed
                                    .map<Widget>((m) {
                                      return MsgCard(
                                        sender:
                                            m['sender_type'] == "user"
                                                ? true
                                                : false,
                                        text: m['message'],
                                        time: converttime(m['created_at']),
                                      );
                                    })
                                    .toList(),
                            // ,☻
                          ),
                        ),
                      ),
                    ),
                    if (isBlocked.value)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),

                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              controller.conversationDetails['expert_block']
                                  ? "متخصص شمارو بلاک کرده"
                                  : 'شما این متخصص را بلاک کرده‌اید',
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: FormBuilderTextField(
                          enableSuggestions: true,
                          name: 'نام',
                          onChanged: (val) {},
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: "پیام را وارد کنید ...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),

                            prefixIcon: GestureDetector(
                              onTap: () {
                                controller.sendMessage(
                                  controller.conversationDetails['id'],
                                  messageController.text,
                                );
                                messageController.text = "";
                              },
                              child: Icon(
                                Icons.send,
                                textDirection: TextDirection.ltr,
                              ),
                            ),
                            // suffixIcon: Icon(Icons.dashboard_customize_outlined, textDirection: TextDirection.ltr , ),
                          ),
                        ),
                      ),
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
}
