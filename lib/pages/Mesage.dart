import 'dart:io';

import 'package:borotokar/controller/ConversationsController%20.dart';
import 'package:borotokar/utils/mesage/mesagelist.dart';
import 'package:borotokar/utils/mesage/suportMesagecart.dart';
import 'package:borotokar/utils/nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MesaggPage extends StatefulWidget {
  const MesaggPage({super.key});

  @override
  State<MesaggPage> createState() => _MesaggPageState();
}

class _MesaggPageState extends State<MesaggPage> {
  final ConversationsController controller =
      Get.find<ConversationsController>();
  int _currentIndexe = 3;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.fetchConversations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (i) async {
        await _showExitDialog();
        // return true;
      },
      child: Directionality(
        // add this
        textDirection: TextDirection.rtl,
        child: SafeArea(
          top: false,
          child: Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                await controller.fetchConversations();
              },
              child: Obx(() {
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
                // if (controller.conversations.isEmpty) {
                //   return const Center(
                //     child: Text(
                //       'هیچ پیامی موجود نیست !!',
                //       style: TextStyle(fontSize: 20),
                //     ),
                //   );
                // }
                // if (controller.conversations.isEmpty) {
                //           return const Center(
                //           child: Text('هیچ پیامی موجود نیست !!', style: TextStyle(fontSize: 20),),
                //           heightFactor: 27,
                //         );}

                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      floating: true,
                      pinned: true,
                      snap: false,
                      automaticallyImplyLeading: false,
                      centerTitle: true,
                      title: const Text('پیام ها'),
                      actions: [],
                    ),
                    controller.conversations.isEmpty
                        ? SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Text(
                              'هیچ پیامی موجود نیست !!',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )
                        : SliverList(
                          delegate: SliverChildBuilderDelegate((context, idx) {
                            final f = controller.conversations[idx];
                            return MesageList(
                              id: f['id'],
                              imageUrl: f['expert']['profile_image'],
                              name:
                                  f['expert']['first_name'] +
                                  " " +
                                  f['expert']['last_name'],
                              lastmessage: (f['messages'].last)['message'],
                              seen: f['seen'],
                            );
                          }, childCount: controller.conversations.length),
                        ),
                  ],
                );
              }),
            ),

            bottomNavigationBar: Mynav(currentIndex: _currentIndexe),
          ),
        ),
      ),
    );
  }

  Future<bool> _showExitDialog() async {
    return (await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text(
                  'آیا از خروج خود اطمینان دارید ؟',
                  textDirection: TextDirection.rtl,
                ),
                // content:  Text('میخواهید از حساب خود خارج شوید ؟', textDirection: TextDirection.rtl),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('خیر', style: TextStyle(color: Colors.white)),
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.red),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => exit(0),
                    child: Text('بله', style: TextStyle(color: Colors.white)),
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.green),
                    ),
                  ),
                ],
              ),
        )) ??
        false;
  }
}
