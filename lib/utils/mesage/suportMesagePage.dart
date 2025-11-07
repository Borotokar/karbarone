import 'package:borotokar/controller/ConversationsController%20.dart';
import 'package:borotokar/controller/SuportConversationsController.dart';
import 'package:borotokar/pages/ReportUserPage.dart';
import 'package:borotokar/utils/mesage/msg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shamsi_date/shamsi_date.dart';

class suportMesagePage extends StatefulWidget {
  final int id;
  const suportMesagePage({super.key, required this.id});

  @override
  State<suportMesagePage> createState() => _suportMesagePageState();
}

class _suportMesagePageState extends State<suportMesagePage> {
  final SuportConversationsController controller =
      Get.find<SuportConversationsController>();

  final messageController = TextEditingController();

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchConversationDetails();
      // Get.log();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.fetchConversationDetails();
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
            Widget mesagess = Container(
              width: Get.width,
              height: Get.height * 0.76,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: ListView(
                children:
                    controller.messages.map<Widget>((m) {
                      return MsgCard(
                        sender: m['sender_type'] == "user" ? true : false,
                        text: m['message'],
                        time: converttime(m['created_at']),
                      );
                    }).toList(),
                // ,☻
              ),
            );
            Widget nullMesagess = Container(
              width: Get.width,
              height: Get.height * 0.76,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.support_agent, size: 60, color: Colors.green),
                    SizedBox(height: 16),
                    Text(
                      "هنوز پیامی رد و بدل نشده است.",
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "پیام خود را وارد کنید، همکاران ما در اسرع وقت پاسخگو خواهند بود.",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
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

            return RefreshIndicator(
              onRefresh: () async {
                await controller.conversationDetails();
              },
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    floating: true,
                    pinned: true,
                    snap: false,
                    centerTitle: true,
                    automaticallyImplyLeading: true,

                    title: Text("ارتباط با پشتیبانی"),

                    actions: [],
                  ),

                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child:
                            controller.messages.isNotEmpty
                                ? mesagess
                                : nullMesagess,
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                          // bottom: 10,
                        ),
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
                          ),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
