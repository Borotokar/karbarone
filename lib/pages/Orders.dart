import 'dart:async';
import 'dart:io';

import 'package:borotokar/controller/OrderController.dart';
import 'package:borotokar/pages/POrders.dart';
import 'package:borotokar/utils/Order/order_list.dart';
import 'package:borotokar/utils/nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:badges/badges.dart' as badges;

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final OrderServiceController controller = Get.find<OrderServiceController>();
  int _currentIndexe = 2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.fetchOrders();
    });
    Timer.periodic(Duration(seconds: 50), (Timer timer) async {
      await controller.updatefetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: PopScope(
        canPop: false,
        onPopInvoked: (i) async {
          await _showExitDialog();
          // return true;
        },
        child: Directionality(
          // add this
          textDirection: TextDirection.rtl,
          child: DefaultTabController(
            length: 4,
            child: SafeArea(
              top: false,
              child: Scaffold(
                appBar: AppBar(
                  title: Text("سفارشات"),
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                ),

                body: Obx(() {
                  // Get.log(controller.orders.toString());
                  if (controller.isLoading.value) {
                    return Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.greenAccent,
                        size: 50,
                      ),
                    );
                  } else if (controller.orders.isEmpty) {
                    return Center(child: Text('سفارشی ندارید'));
                  } else {
                    final orders = controller.orders;

                    final o1 = [];
                    final o3 = [];
                    final o4 = [];
                    final o5 = [];
                    // Get.log(orders.toString());
                    for (var order in orders) {
                      if (order['status'] == "1" || order['status'] == "2") {
                        o1.add(
                          OrderList(
                            image: order['service']['image'],
                            title: order['service']['title'],
                            datetime: order['completion_date'],
                            status: OrderStatus.Processing,
                            nextPage: POrdersPage(
                              title: order['title'],
                              id: order['id'],
                              data: order,
                            ),
                            bids: order['bids'],
                          ),
                        );
                      }
                      if (order['status'] == "3") {
                        final p = [];
                        if (order['bids'] != []) {
                          p.add(order['bids'].first);
                        }
                        o3.add(
                          OrderList(
                            image: order['service']['image'],
                            title: order['service']['title'],
                            datetime: order['completion_date'],
                            status: OrderStatus.wellDone,
                            nextPage: POrdersPage(
                              title: order['title'],
                              id: order['id'],
                              data: order,
                            ),
                            bids: p,
                          ),
                        );
                        // Get.log(o3.toString());
                      }
                      if (order['status'] == "4") {
                        final p = [];
                        if (order['bids'] != []) {
                          p.add(order['bids'].first);
                        }
                        o4.add(
                          OrderList(
                            image: order['service']['image'],
                            title: order['service']['title'],
                            datetime: order['completion_date'],
                            status: OrderStatus.Done,
                            nextPage: POrdersPage(
                              title: order['title'],
                              id: order['id'],
                              done: true,
                              data: order,
                            ),
                            bids: p,
                          ),
                        );
                      }
                      if (order['status'] == "5") {
                        o5.add(
                          OrderList(
                            image: order['service']['image'],
                            title: order['service']['title'],
                            datetime: order['completion_date'],
                            status: OrderStatus.Canceled,
                            nextPage: null,
                          ),
                        );
                      }
                    }

                    if (o1.isEmpty) {
                      o1.add(
                        Container(
                          width: Get.width,
                          child: Center(
                            child: Column(
                              children: [
                                Image.asset("images/search.png", height: 200),
                                SizedBox(height: 10),
                                Text(
                                  " سفارش درحال پردازش ندارید",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    if (o3.isEmpty) {
                      o3.add(
                        Container(
                          width: Get.width,
                          child: Center(
                            child: Column(
                              children: [
                                Image.asset("images/search.png", height: 200),
                                SizedBox(height: 10),
                                Text(
                                  " سفارش درحال انجام ندارید",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    if (o4.isEmpty) {
                      o4.add(
                        Container(
                          width: Get.width,
                          child: Center(
                            child: Column(
                              children: [
                                Image.asset("images/search.png", height: 200),
                                SizedBox(height: 10),
                                Text(
                                  " سفارش انجام شده ندارید",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    if (o5.isEmpty) {
                      o5.add(
                        Container(
                          width: Get.width,
                          child: Center(
                            child: Column(
                              children: [
                                Image.asset("images/search.png", height: 200),
                                SizedBox(height: 10),
                                Text(
                                  " سفارش لغو شده ندارید",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            width: Get.width,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10.0),
                            ),

                            child: TabBar(
                              dividerHeight: 0,

                              labelPadding: EdgeInsets.all(10),
                              indicator: BoxDecoration(
                                color: Color.fromARGB(255, 50, 204, 129),
                                borderRadius: BorderRadius.circular(10.0),
                              ),

                              labelColor: Colors.white,

                              indicatorWeight: 1,
                              indicatorSize: TabBarIndicatorSize.tab,
                              unselectedLabelColor: Colors.black,
                              tabs: [
                                Tab(
                                  child: Text(
                                    'درحال پردازش',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    'درحال انجام',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    'انجام شده',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    'لغو شده',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Expanded(
                            child: TabBarView(
                              children: [
                                // SizedBox(height: 18,),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: RefreshIndicator(
                                    onRefresh: () async {
                                      await controller.fetchOrders();
                                    },
                                    child: ListView.builder(
                                      itemCount: o1.length,
                                      itemBuilder: (context, index) {
                                        return o1[index];
                                        // return Text("data");
                                      },
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: RefreshIndicator(
                                    onRefresh: () async {
                                      await controller.fetchOrders();
                                    },
                                    child: ListView.builder(
                                      itemCount: o3.length,
                                      itemBuilder: (context, index) {
                                        return o3[index];
                                        // return Text("data");
                                      },
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: RefreshIndicator(
                                    onRefresh: () async {
                                      await controller.fetchOrders();
                                    },
                                    child: ListView.builder(
                                      itemCount: o4.length,
                                      itemBuilder: (context, index) {
                                        return o4[index];
                                        // return Text("data");
                                      },
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: RefreshIndicator(
                                    onRefresh: () async {
                                      await controller.fetchOrders();
                                    },
                                    child: ListView.builder(
                                      itemCount: o5.length,
                                      itemBuilder: (context, index) {
                                        return o5[index];
                                        // return Text("data");
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }),

                bottomNavigationBar: Mynav(currentIndex: _currentIndexe),
              ),
            ),
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
