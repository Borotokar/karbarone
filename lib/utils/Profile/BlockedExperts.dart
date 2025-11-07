import 'package:borotokar/Congit.dart';
import 'package:borotokar/controller/ConversationsController%20.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Blockedexperts extends StatefulWidget {
  const Blockedexperts({super.key});

  @override
  State<Blockedexperts> createState() => _BlockedexpertsState();
}

class _BlockedexpertsState extends State<Blockedexperts> {
  final ConversationsController controller =
      Get.find<ConversationsController>();

  void unblockExpert(int id) {
    setState(() {
      controller.unblockExpert(expertId: id);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('متخصص از بلاک خارج شد')));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.fetchBlockedExperts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
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

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  snap: false,
                  centerTitle: true,
                  automaticallyImplyLeading: true,
                  title: const Text('متخصصین بلاک شده'),
                ),
                if (controller.blockingExperts.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(
                        child: Text(
                          'هیچ متخصصی مسدود نشده است.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final expert = controller.blockingExperts[index]['expert'];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        child: Row(
                          children: [
                            // عکس متخصص (راست)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(
                                IMG_API_URL + expert['profile_image'],
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 14),
                            // نام متخصص (وسط)
                            Expanded(
                              child: Text(
                                "${expert['first_name']} ${expert['last_name']}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            // دکمه رفع بلاک (چپ)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                              onPressed:
                                  () => controller.unblockExpert(
                                    expertId: expert['id'],
                                  ),
                              child: const Text(
                                'رفع بلاک',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }, childCount: controller.blockingExperts.length),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
