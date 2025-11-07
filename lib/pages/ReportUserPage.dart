import 'dart:convert';
import 'package:borotokar/controller/ConversationsController%20.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class ReportUserPage extends StatefulWidget {
  final int userId;
  final String type;
  const ReportUserPage({super.key, required this.userId, required this.type});

  @override
  State<ReportUserPage> createState() => _ReportUserPageState();
}

class _ReportUserPageState extends State<ReportUserPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final ConversationsController controller =
      Get.find<ConversationsController>();

  // Future<void> _submitReport() async {
  //   if (_formKey.currentState?.saveAndValidate() ?? false) {
  //     final formData = _formKey.currentState!.value;

  //     try {
  //       final response = await http.post(
  //         Uri.parse('https://api.borotokar.com/api/expert/report'),
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Accept': 'application/json',
  //           'Authorization': 'Bearer YOUR_ACCESS_TOKEN', // توکن رو جایگزین کن
  //         },
  //         body: jsonEncode({
  //           'user_id': widget.userId,
  //           'violation_type': formData['violation_type'],
  //           'description': formData['description'] ?? '',
  //         }),
  //       );

  //       if (response.statusCode == 201) {
  //         Get.snackbar('موفقیت', 'گزارش با موفقیت ارسال شد');
  //         Navigator.pop(context);
  //       } else {
  //         final data = jsonDecode(response.body);
  //         Get.snackbar('خطا', data['message'] ?? 'خطا در ارسال گزارش');
  //       }
  //     } catch (e) {
  //       Get.snackbar('خطا', 'مشکلی در اتصال به سرور پیش آمد');
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(title: const Text('گزارش متخصص')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  RichText(
                    textDirection: TextDirection.rtl,
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                      children: [
                        const TextSpan(
                          text: '📢 قوانین و شرایط گزارش تخلف\n\n',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const TextSpan(
                          text:
                              'با تشکر از همراهی شما، لطفاً توجه داشته باشید که این بخش صرفاً جهت گزارش رفتارهای نادرست و تخلفات کاربران طراحی شده است. گزارش‌های ارسالی توسط تیم پشتیبانی بررسی و در صورت لزوم، اقدامات لازم انجام خواهد شد.\n\n',
                        ),
                        const TextSpan(
                          text:
                              'لطفاً در ثبت گزارش، دقت لازم را داشته باشید و از ارائه اطلاعات نادرست خودداری فرمایید. تمام اطلاعات به‌صورت محرمانه بررسی خواهند شد.',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                  // FormBuilderDropdown<String>(
                  //   name: 'violation_type',
                  //   decoration: const InputDecoration(labelText: 'نوع تخلف'),
                  //   items: const [
                  //     DropdownMenuItem(value: 'chat', child: Text('مکالمه')),
                  //     DropdownMenuItem(value: 'profile', child: Text('پروفایل')),
                  //     DropdownMenuItem(value: 'order', child: Text('سفارش')),
                  //   ],
                  // ),
                  const SizedBox(height: 20),
                  FormBuilderTextField(
                    enableSuggestions: true,
                    name: 'description',
                    decoration: const InputDecoration(
                      labelText: 'توضیحات ',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed:
                        () => controller.reportUser(
                          expertId: widget.userId,
                          violationType: widget.type,
                          description:
                              _formKey
                                  .currentState
                                  ?.fields['description']
                                  ?.value,
                        ),
                    child: const Text('ارسال گزارش'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
