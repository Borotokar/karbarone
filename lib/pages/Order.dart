import 'package:borotokar/Congit.dart';
import 'package:borotokar/controller/OrderController.dart';
import 'package:borotokar/network/OrderRequest.dart';
import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class SetOrderPage extends StatefulWidget {
  final int id;
  final String city;
  const SetOrderPage({super.key, required this.id, required this.city});

  @override
  State<SetOrderPage> createState() => _SetOrderPageState();
}

class _SetOrderPageState extends State<SetOrderPage> {
  final OrderServiceController controller = Get.find<OrderServiceController>();
  final AddressController = TextEditingController();
  final desController = TextEditingController();

  double latitude = 35.6892;
  double longitude = 51.3890;

  double userlatitude = 0;
  double userlongitude = 0;

  late MapController _mapController;
  LatLng _center = LatLng(35.6892, 51.3890);

  String formatOrderDate(DateTime completionDate) {
    // Parse the completion date to Gregorian

    // Convert to Jalali (Shamsi)
    final jalaliDate = Jalali.fromDateTime(completionDate);

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
    Get.log(weekDay);
    // Format the final string
    String formattedDate =
        '$weekDay ${jalaliDate.day} ${jalaliDate.formatter.mN}';

    return formattedDate;
  }

  void getLocation() async {
    Position? position = await getUserLocation();
    if (position != null) {
      setState(() {
        userlatitude = position.latitude;
        userlongitude = position.longitude;
        _mapController.move(LatLng(userlatitude, userlongitude), 17);
      });

      Get.log("User's Latitude: $userlatitude, Longitude: $userlongitude");
    } else {
      Get.log(
        'Location permissions are not granted or location services are disabled.',
      );
    }
  }

  int activeStep = 0;
  int activeStep2 = 0;
  int reachedStep = 0;
  int upperBound = 1;
  double progress = 0.2;
  Set<int> reachedSteps = <int>{0, 2, 3};

  final _formKey = GlobalKey<FormBuilderState>();
  void increaseProgress() {
    if (progress < 1) {
      setState(() => progress += 0.2);
    } else {
      setState(() => progress = 0);
    }
  }

  int _selectedDateIndex = 0;
  int _selectedTimeIndex = 0;

  Time? _time;
  String _date = "";

  List<DateTime> _getNextWeekDates() {
    final now = Jalali.now();
    List<DateTime> date = List.generate(
      7,
      (index) => now.addDays(index).toDateTime(),
    );
    if (_date == "") {
      final jalaliDate = Jalali.fromDateTime(date[0]);
      _date = "${jalaliDate.year}-${jalaliDate.month}-${jalaliDate.day}";
    }
    return date;
  }

  List<Time> _getTimeSlots() {
    final now = DateTime.now().hour; //;
    Get.log(now.toString());
    List<Time> list = [];
    if (_selectedDateIndex == 0) {
      int from = now % 2 != 0 ? now - 1 : now;
      int to = from + 2;
      for (var i = 1; i < 12; i++) {
        // time = new
        if (to > 24) {
          break;
        }
        list.add(
          new Time(
            'از ${(from).toString().padLeft(2, '')} تا ${(to).toString().padLeft(2, '')}',
            '${(from).toString().padLeft(2, '')}:00',
          ),
        );
        from += 2;
        to += 2;
      }
      if (_time == null) {
        _time = list[0];
      }
      return list;
    }
    int from = 8;
    int to = 10;
    for (var i = 1; i < 9; i++) {
      // time = new
      list.add(
        new Time(
          'از ${(from).toString().padLeft(2, '')} تا ${(to).toString().padLeft(2, '')}',
          '${(from).toString().padLeft(2, '')}:00',
        ),
      );
      from += 2;
      to += 2;
    }
    if (_time == null) {
      _time = list[0];
    }
    // return List.generate(8, (index) => 'از ${(index+8).toString().padLeft(2, '')} تا ${(index+10).toString().padLeft(2, '')}');
    return list;
  }

  final List<Answer> answers = [];

  @override
  void initState() {
    // getLocation();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.fetchService(widget.id);
    });
    _mapController = MapController();

    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    final dates = _getNextWeekDates();
    final timeSlots = _getTimeSlots();
    return Directionality(
      // add this
      textDirection: TextDirection.rtl,
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("ثبت سفارش", style: TextStyle(fontSize: 30)),
            centerTitle: true,
          ),

          body: Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.greenAccent,
                  size: 50,
                ),
              );
            } else {
              return CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      EasyStepper(
                        activeStep: activeStep,
                        stepShape: StepShape.rRectangle,
                        stepBorderRadius: 10,
                        borderThickness: 1,
                        padding: EdgeInsets.all(10),
                        lineStyle: LineStyle(
                          lineLength: Get.width * 0.24,
                          lineType: LineType.dotted,
                        ),

                        stepRadius: 25,
                        finishedStepBorderColor: Colors.greenAccent,
                        finishedStepTextColor: Colors.greenAccent,
                        finishedStepBackgroundColor: Colors.greenAccent,
                        activeStepIconColor: Colors.greenAccent,
                        showLoadingAnimation: true,
                        steps: [
                          EasyStep(
                            customStep: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Opacity(
                                opacity: activeStep >= 0 ? 1 : 0.3,

                                child: Image.asset('images/5.jpg'),
                              ),
                            ),
                            customTitle: const Text(
                              'توضیحات',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          EasyStep(
                            customStep: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Opacity(
                                opacity: activeStep >= 1 ? 1 : 0.3,
                                child: Image.asset('images/6.jpg'),
                              ),
                            ),
                            customTitle: const Text(
                              'آدرس',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          EasyStep(
                            customStep: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Opacity(
                                opacity: activeStep >= 2 ? 1 : 0.3,
                                child: Image.asset('images/8.jpg'),
                              ),
                            ),
                            customTitle: const Text(
                              'ثبت',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                        // onStepReached: (index) => setState(() => activeStep = index),
                      ),

                      if (activeStep == 0)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                FormBuilder(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      Column(
                                        children:
                                            controller.service['questions'].map<
                                              Widget
                                            >((s) {
                                              if (s['type'] == "user") {
                                                return Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Container(
                                                    width: 600,
                                                    decoration:
                                                        const BoxDecoration(
                                                          color: Colors.white10,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                Radius.circular(
                                                                  5,
                                                                ),
                                                              ),
                                                        ),
                                                    child: FormBuilderTextField(
                                                      name: s['question'],
                                                      autocorrect: true,
                                                      enableSuggestions: true,
                                                      onChanged: (val) {
                                                        setState(() {
                                                          // answers.clear();
                                                          int index = answers
                                                              .indexWhere(
                                                                (answer) =>
                                                                    answer
                                                                        .questionId ==
                                                                    s['id'],
                                                              );

                                                          if (index != -1) {
                                                            // اگر آیتم موجود باشد، آن را حذف می‌کنیم
                                                            answers.removeAt(
                                                              index,
                                                            );
                                                          }
                                                          Get.log(
                                                            index.toString(),
                                                          );
                                                          if (val != null) {
                                                            answers.add(
                                                              Answer(
                                                                questionId:
                                                                    s['id'],
                                                                answer: val,
                                                              ),
                                                            );
                                                          } else if (val ==
                                                              null) {
                                                            answers.removeAt(
                                                              index,
                                                            );
                                                          }
                                                        });
                                                      },
                                                      decoration: InputDecoration(
                                                        hintText: s['question'],
                                                        hintStyle: TextStyle(
                                                          overflow:
                                                              TextOverflow
                                                                  .visible,
                                                          fontSize: 10,
                                                        ),
                                                        hintTextDirection:
                                                            TextDirection.rtl,
                                                        border: OutlineInputBorder(
                                                          // borderSide: BorderSide.none,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                Radius.circular(
                                                                  5,
                                                                ),
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Container(
                                                    // width: 600,
                                                    height: 60,
                                                    decoration:
                                                        const BoxDecoration(
                                                          color: Colors.white10,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                Radius.circular(
                                                                  5,
                                                                ),
                                                              ),
                                                        ),
                                                    child: FormBuilderDropdown<
                                                      String
                                                    >(
                                                      name: s['question'],
                                                      decoration: InputDecoration(
                                                        labelText:
                                                            s['question'],

                                                        labelStyle: TextStyle(
                                                          overflow:
                                                              TextOverflow
                                                                  .visible,
                                                          fontSize: 12,
                                                        ),
                                                        border: OutlineInputBorder(
                                                          // borderSide: BorderSide.none,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                Radius.circular(
                                                                  5,
                                                                ),
                                                              ),
                                                        ),
                                                      ),
                                                      onChanged: (val) {
                                                        setState(() {
                                                          int index = answers
                                                              .indexWhere(
                                                                (answer) =>
                                                                    answer
                                                                        .questionId ==
                                                                    s['id'],
                                                              );

                                                          if (index != -1) {
                                                            // اگر آیتم موجود باشد، آن را حذف می‌کنیم
                                                            answers.removeAt(
                                                              index,
                                                            );
                                                          }

                                                          // آیتم جدید را اضافه می‌کنیم
                                                          // answers.add(newAnswer);
                                                          answers.add(
                                                            Answer(
                                                              questionId:
                                                                  s['id'],
                                                              answer: val!,
                                                            ),
                                                          );
                                                        });
                                                        Get.log(
                                                          answers.toString(),
                                                        );
                                                      },
                                                      items:
                                                          s['predefined_answer']
                                                              .map<
                                                                DropdownMenuItem<
                                                                  String
                                                                >
                                                              >(
                                                                (
                                                                  gender,
                                                                ) => DropdownMenuItem<
                                                                  String
                                                                >(
                                                                  alignment:
                                                                      AlignmentDirectional
                                                                          .center,
                                                                  value:
                                                                      gender['answer'],
                                                                  child: Text(
                                                                    gender['answer'],
                                                                  ),
                                                                ),
                                                              )
                                                              .toList(),
                                                    ),
                                                  ),
                                                );
                                              }
                                            }).toList(),
                                      ),

                                      SizedBox(height: 20),

                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            // color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                          ),
                                          child: FormBuilderTextField(
                                            // autofocus: true,
                                            // controller: _filed3,
                                            maxLines: 10,
                                            maxLength: 200,

                                            enableSuggestions: true,
                                            name: 'filed3',

                                            controller: desController,
                                            decoration: InputDecoration(
                                              hintText: 'توضیحات',

                                              hintTextDirection:
                                                  TextDirection.rtl,
                                              border: OutlineInputBorder(
                                                // borderSide: BorderSide.none,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 30),

                                      Container(
                                        height: 80.0,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: dates.length,
                                          itemBuilder: (context, index) {
                                            final date = dates[index];
                                            final jalaliDate =
                                                Jalali.fromDateTime(date);
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _selectedDateIndex = index;
                                                  _date =
                                                      "${jalaliDate.year}-${jalaliDate.month}-${jalaliDate.day}";
                                                });
                                                Get.log(_date);
                                              },
                                              child: Container(
                                                width: 100.0,
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: 8.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      _selectedDateIndex ==
                                                              index
                                                          ? Colors
                                                              .lightGreenAccent
                                                          : Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        10.0,
                                                      ),
                                                ),
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        formatOrderDate(date),
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          color:
                                                              _selectedDateIndex ==
                                                                      index
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 20.0),
                                      // Timeline for Times
                                      Container(
                                        height: 80.0,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: timeSlots.length,
                                          itemBuilder: (context, index) {
                                            final timeSlot = timeSlots[index];
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _selectedTimeIndex = index;
                                                  _time = timeSlot;
                                                });
                                                Get.log(
                                                  _time!.getTime.toString(),
                                                );
                                              },
                                              child: Container(
                                                width: 80.0,
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: 8.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      _selectedTimeIndex ==
                                                              index
                                                          ? Colors
                                                              .lightGreenAccent
                                                          : Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        10.0,
                                                      ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    timeSlot.getTitle,
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      color:
                                                          _selectedTimeIndex ==
                                                                  index
                                                              ? Colors.black
                                                              : Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // SizedBox(height: 340,),
                              ],
                            ),
                          ),
                        ),

                      if (activeStep == 1)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  width: Get.width,
                                  height: 450,

                                  child: FlutterMap(
                                    mapController: _mapController,
                                    options: MapOptions(
                                      initialCenter: LatLng(
                                        latitude,
                                        longitude,
                                      ),

                                      initialZoom: 16.0,
                                      onPositionChanged: (camera, hasGesture) {
                                        setState(() {
                                          _mapController.camera
                                              .latLngToScreenPoint(
                                                LatLng(latitude, longitude),
                                              );
                                          latitude =
                                              _mapController
                                                  .camera
                                                  .center
                                                  .latitude;
                                          longitude =
                                              _mapController
                                                  .camera
                                                  .center
                                                  .longitude;
                                        });
                                      },
                                      // onTap: (tapPosition, point) {
                                      //   setState(() {
                                      //     latitude = point.latitude ;
                                      //     longitude = point.longitude ;
                                      //   });
                                      // },
                                    ),
                                    children: [
                                      TileLayer(
                                        urlTemplate:
                                            "https://map.ir/shiveh/xyz/1.0.0/Shiveh:Shiveh@EPSG:3857@png/{z}/{x}/{y}.png"
                                            "?x-api-key=eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImE5NDQ2YjA3MDk5OTIwNjkxZTZiNzVmNmJmYWQxMDRhMzZmYjVhMTQzYTg3ODZjOTRhYWU4MDFlOTRmNzljNTBkOTU2N2QzMDRlZDUyZDFiIn0.eyJhdWQiOiIyMzY4MiIsImp0aSI6ImE5NDQ2YjA3MDk5OTIwNjkxZTZiNzVmNmJmYWQxMDRhMzZmYjVhMTQzYTg3ODZjOTRhYWU4MDFlOTRmNzljNTBkOTU2N2QzMDRlZDUyZDFiIiwiaWF0IjoxNjkyMjE3MjAwLCJuYmYiOjE2OTIyMTcyMDAsImV4cCI6MTY5NDgwOTIwMCwic3ViIjoiIiwic2NvcGVzIjpbImJhc2ljIl19.o5WQG3NUKRB8TRZyYLrlNIe5GyjSQQrFWfbgEvfBdbEoXcbdDOilAAD7fAYyAd2HPi1U4oub3JdSbRjaEpr_WDzb9MmD2l0ryxe3FHylqtOfQuuMQZzsmMYXzgUvjAiOKYFVHqM1_2cQJ10XgEEedDZq9ayeKJLGO53EmP9EnAQ5W5YVoH4LV6ZhOyRP6XJRksZ56ECo9AU5Jcko2YJIj4durY8iMl4qRY3DqDWPVEeA3n-ZAi1ue-rxUpo0jq4o_cWTxh_FU4GuJgLsTbhxdwE2h0qTlPxdnrYOqLV9Z360S6LU48yhigNQVzcuhtWzJRidORoDxhzte_Q_pEo_8Q",
                                      ),
                                      Center(
                                        child: Icon(
                                          Icons.location_pin,
                                          size: 60,
                                          color: Colors.lightGreenAccent,
                                        ),
                                      ),
                                      MarkerLayer(
                                        markers: [
                                          Marker(
                                            width: 80.0,
                                            height: 80.0,
                                            point: LatLng(
                                              userlatitude,
                                              userlongitude,
                                            ),
                                            rotate: true,
                                            child: Icon(
                                              Icons.my_location,
                                              size: 20.0,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          // Marker(
                                          //   width: 100.0,
                                          //   height: 100.0,
                                          //   point: LatLng(latitude , longitude),
                                          //   child: Icon(Icons.location_on, size: 40.0, color: Colors.red),
                                          // ),
                                        ],
                                      ),
                                      Positioned(
                                        top: 380,
                                        right: 10,
                                        child: FloatingActionButton(
                                          backgroundColor: Colors.white,
                                          onPressed: () {
                                            getLocation();
                                          },
                                          child: Icon(
                                            Icons.my_location,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 20,
                                        left: 20,
                                        child: Container(
                                          color: Colors.white,
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            'مکان انتخابی: \nLat: ${latitude}, Lng: ${longitude}',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),

                                Container(
                                  width: 600,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: FormBuilderTextField(
                                    name: 'سوال دوم',
                                    enableSuggestions: true,

                                    onChanged: (val) {
                                      // Print the text value write into TextField
                                    },
                                    controller: AddressController,
                                    decoration: InputDecoration(
                                      hintText: 'آدرس',
                                      hintTextDirection: TextDirection.rtl,
                                      border: OutlineInputBorder(
                                        // borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),

                      if (activeStep == 2)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Container(
                                  width: 175,
                                  height: 175,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        IMG_API_URL +
                                            controller.service['image'],
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                Text(
                                  "خدمت : ${controller.service['title']}",
                                  style: TextStyle(fontSize: 20),
                                ),
                                const Divider(
                                  height: 10,
                                  thickness: 0.5,
                                  color: Colors.black,
                                ),
                                Text("آدرس : ${AddressController.text}"),
                                const Divider(
                                  height: 10,
                                  thickness: 0.5,
                                  color: Colors.black,
                                ),
                                Text("توضیحات : ${desController.text}"),
                                const Divider(
                                  height: 10,
                                  thickness: 0.5,
                                  color: Colors.black,
                                ),
                                Text("تاریخ : ${_date}"),
                                const Divider(
                                  height: 10,
                                  thickness: 0.5,
                                  color: Colors.black,
                                ),
                                Text("ساعت : ${_time!.getTitle}"),
                                const Divider(
                                  height: 10,
                                  thickness: 0.5,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ]),
                  ),
                ],
              );
            }
          }),

          bottomNavigationBar: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (activeStep != 0) {
                      activeStep -= 1;
                    }
                  });
                },

                style: ElevatedButton.styleFrom(
                  // padding: const EdgeInsets.symmetric(horizontal: 55,vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Colors.grey.shade300,
                ),
                child: Text(
                  'مرحله قبل',
                  style: TextStyle(color: Colors.black45),
                ),
              ),
              SizedBox(width: 10),

              ElevatedButton(
                onPressed: () async {
                  Get.log(_time!.getTime.toString());
                  switch (activeStep) {
                    case 0:
                      if (answers.length != 0) {
                        setState(() {
                          activeStep += 1;
                          getLocation();
                        });
                      } else {
                        Get.snackbar("خطا", "پاسخ به سووالات الزامی است");
                      }
                      break;
                    case 1:
                      if (AddressController.text != "" &&
                          latitude != 35.6892 &&
                          longitude != 51.3890) {
                        setState(() {
                          activeStep += 1;
                        });
                      } else {
                        Get.snackbar("خطا", "وارد کردن آدرس و لوکیشن الزامیست");
                      }

                      break;
                    case 2:
                      final orderRequest = OrderRequest(
                        serviceId: widget.id,
                        lat: latitude,
                        log: longitude,
                        description:
                            desController.text != null
                                ? desController.text
                                : "",
                        address: AddressController.text,
                        city: widget.city,
                        completionDate: _date,
                        completionTime: _time!.getTime,
                        answers: answers,
                      );
                      await controller.submitOrder(orderRequest);
                      break;
                    default:
                  }
                  // if (activeStep==0&&answers.length!=0) {
                  //   setState(() {
                  //     activeStep += 1;
                  //   });
                  // }else{
                  //   Get.snackbar("خطا", "پاسخ به سووالات الزامی است");
                  // }
                  // if (activeStep==1&&AddressController.text!=null) {
                  //   setState(() {
                  //     activeStep += 1;
                  //   });
                  // }else{
                  //   Get.snackbar("خطا", "پاسخ به سووالات الزامی است");
                  // }
                  // if (activeStep != 2) {
                  //   final orderRequest = OrderRequest(serviceId: widget.id,
                  //   lat: latitude, log: longitude,
                  //   description: desController.text != null ? desController.text : "",
                  //   address: AddressController.text ,
                  //   city: widget.city,
                  //   completionDate: _date,
                  //   completionTime: _time!.getTime,
                  //   answers: answers);
                  //   controller.submitOrder(orderRequest);
                  // }
                },

                style: ElevatedButton.styleFrom(
                  // padding: const EdgeInsets.symmetric(horizontal: 55,vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Colors.lightGreenAccent,
                ),
                child: Row(
                  children: [
                    Text(
                      activeStep < 2 ? 'مرحله بعد' : 'ثبت',
                      style: TextStyle(color: Colors.black45),
                    ),
                    Icon(Icons.arrow_forward_ios_outlined, size: 11),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Position?> getUserLocation() async {
  LocationPermission permission;

  // Check if location services are enabled
  // serviceEnabled = await Geolocator.isLocationServiceEnabled();
  // if (!serviceEnabled) {
  //   // Location services are not enabled, return null
  //   return null;
  // }

  // Check if permission is granted
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      Get.snackbar('خطا', 'این اپ برای کارکردن به دسترسی مکان نیاز دارد');
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    Get.snackbar('خطا', 'این اپ برای کارکردن به دسترسی مکان نیاز دارد');
    return null;
  }

  // When permissions are granted, get the current position
  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}

class Time {
  final String title;
  final String time;

  String get getTitle => this.title;
  String get getTime => this.time;
  Time(this.title, this.time);
}
