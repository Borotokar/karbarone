import 'package:borotokar/controller/NotificationController.dart';
import 'package:borotokar/utils/Notif/NotifBox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotifPage extends StatefulWidget {
  const NotifPage({super.key});

  @override
  State<NotifPage> createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
  final NotificationController _notificationController =
      Get.find<NotificationController>();
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationController.fetchNotifications(true);
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _notificationController.fetchNotifications(true);
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
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: true,
                snap: false,
                centerTitle: true,
                automaticallyImplyLeading: true,

                title: const Text('اعلانات'),

                actions: [],
              ),

              Obx(
                () =>
                    _notificationController.notifications.isEmpty
                        ? SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Text(
                              'هیچ اعلانی  وجود ندارد',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        )
                        : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final notif =
                                  _notificationController.notifications[index];
                              return NotifBox(
                                title: notif['title'],
                                body: notif['message'],
                              );
                            },
                            childCount:
                                _notificationController.notifications.length,
                          ),
                        ),
              ),
            ],
          ),

          // bottomNavigationBar: Mynav(currentIndex: _currentIndexe)
        ),
      ),
    );
  }
}
