import 'package:borotokar/Congit.dart';
import 'package:borotokar/controller/OrderController.dart';
import 'package:borotokar/pages/ReportUserPage.dart';
import 'package:borotokar/utils/DividerWithTextWidget.dart';
import 'package:borotokar/utils/Order/CallCard.dart';
import 'package:borotokar/utils/Order/commentCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class EProfile extends StatefulWidget {
  final String image;
  final String firstName;
  final String lastName;
  final comments;
  final gallery;
  final double rate;
  final String address;
  final String phone_number;
  final String? eitaa_link;
  final String? telegram_link;
  final String? whatsapp_link;
  final String mesage;
  final String proposed_price;
  final String proposed_type;
  final String? website_link;
  final String about_me;
  final String garanty;
  final bool done;
  final int service_id;
  final int expert_id;
  final bool proposal;
  final bool call;

  const EProfile({
    super.key,
    required this.image,
    required this.firstName,
    required this.lastName,
    this.comments,
    this.gallery,
    required this.rate,
    required this.address,
    required this.phone_number,
    required this.eitaa_link,
    required this.telegram_link,
    required this.whatsapp_link,
    this.mesage =
        "لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ، و با استفاده از طراحان گرافیک است، چاپگرها و متون بلکه روزنامه و مجله در ستون و سطرآنچنان که لازم است، و برای شرایط فعلی تکنولوژی مورد نیاز، و کاربردهای متنوع با هدف بهبود ابزارهای کاربردی می باشد، کتابهای زیادی در شصت و سه درصد گذشته حال و آینده، شناخت فراوان جامعه و متخصصان را می طلبد، تا با نرم افزارها شناخت بیشتری را برای طراحان رایانه ای علی الخصوص طراحان خلاقی، و فرهنگ پیشرو در زبان فارسی ایجاد کرد، در این صورت می توان امید داشت که تمام و دشواری موجود در ارائه راهکارها، و شرایط سخت تایپ به پایان رسد و زمان مورد نیاز شامل حروفچینی دستاوردهای اصلی، و جوابگوی سوالات پیوسته اهل دنیای موجود طراحی اساسا مورد استفاده قرار گیرد.",
    this.proposed_price = "0",
    this.proposed_type = "توافقی",
    required this.website_link,
    required this.about_me,
    required this.garanty,
    this.done = false,
    required this.service_id,
    required this.expert_id,
    this.proposal = true,
    this.call = true,
  });

  @override
  State<EProfile> createState() => _EProfileState();
}

class _EProfileState extends State<EProfile> {
  // final garantyText = "حروفچینی دستاوردهای اصلی، و جوابگوی سوالات پیوسته اهل دنیای موجود طراحی اساسا مورد استفاده قرار گیرد.";
  // final messageText = "شناخت فراوان جامعه و متخصصان را می طلبد، تا با نرم افزارها شناخت بیشتری را برای طراحان رایانه ای علی الخصوص طراحان خلاقی، و فرهنگ پیشرو در زبان فارسی ایجاد کرد، در این صورت می توان امید داشت که تمام و دشواری موجود در ارائه راهکارها، و شرایط سخت تایورد .";
  // String text = "لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ، و با استفاده از طراحان گرافیک است، چاپگرها و متون بلکه روزنامه و مجله در ستون و سطرآنچنان که لازم است، و برای شرایط فعلی تکنولوژی مورد نیاز، و کاربردهای متنوع با هدف بهبود ابزارهای کاربردی می باشد، کتابهای زیادی در شصت و سه درصد گذشته حال و آینده، شناخت فراوان جامعه و متخصصان را می طلبد، تا با نرم افزارها شناخت بیشتری را برای طراحان رایانه ای علی الخصوص طراحان خلاقی، و فرهنگ پیشرو در زبان فارسی ایجاد کرد، در این صورت می توان امید داشت که تمام و دشواری موجود در ارائه راهکارها، و شرایط سخت تایپ به پایان رسد و زمان مورد نیاز شامل حروفچینی دستاوردهای اصلی، و جوابگوی سوالات پیوسته اهل دنیای موجود طراحی اساسا مورد استفاده قرار گیرد.لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ، و با استفاده از طراحان گرافیک است، چاپگرها و متون بلکه روزنامه و مجله در ستون و سطرآنچنان که لازم است، و برای شرایط فعلی تکنولوژی مورد نیاز، و کاربردهای متنوع با هدف بهبود ابزارهای کاربردی می باشد، کتابهای زیادی در شصت و سه درصد گذشته حال و آینده، شناخت فراوان جامعه و متخصصان را می طلبد، تا با نرم افزارها شناخت بیشتری را برای طراحان رایانه ای علی الخصوص طراحان خلاقی، و فرهنگ پیشرو در زبان فارسی ایجاد کرد، در این صورت می توان امید داشت که تمام و دشواری موجود در ارائه راهکارها، و شرایط سخت تایپ به پایان رسد و زمان مورد نیاز شامل حروفچینی دستاوردهای اصلی، و جوابگوی سوالات پیوسته اهل دنیای موجود طراحی اساسا مورد استفاده قرار گیرد.";
  ScrollController scrollController = ScrollController();
  final OrderServiceController controller = Get.find();
  final dataKey1 = new GlobalKey();
  final dataKey2 = new GlobalKey();
  final dataKey3 = new GlobalKey();

  void scrollToSection(GlobalKey index) {
    Scrollable.ensureVisible(
      index.currentContext!,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    var expert = Padding(
      padding: const EdgeInsets.only(
        top: 0.0,
        left: 8.0,
        right: 8.0,
        bottom: 8.0,
      ),
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.green.shade100,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(111, 0, 0, 0),
              blurRadius: 0.5,
              blurStyle: BlurStyle.normal,
              spreadRadius: 0.1,
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // SizedBox(width: 4,),
                      Row(
                        children: [
                          Icon(Icons.message_outlined),
                          Text(
                            "  پیام متخصص برای شما  ",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Text(
                        "${widget.proposed_type} : ${widget.proposed_price} تومان",
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(widget.mesage, style: TextStyle(fontSize: 16)),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                width: Get.width,
              ),
            ),
          ],
        ),
      ),
    );
    return Directionality(
      // add this
      textDirection: TextDirection.rtl,
      child: SafeArea(
        top: false,
        child: Scaffold(
          body: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: true,
                snap: false,
                centerTitle: true,
                automaticallyImplyLeading: true,

                title: Text('پروفایل  ${widget.firstName} ${widget.lastName}'),

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
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: Icon(
                                    Icons.report,
                                    color: Colors.orange,
                                  ),
                                  title: Text('گزارش متخصص'),
                                  onTap: () {
                                    // فراخوانی تابع گزارش
                                    Get.to(
                                      () => ReportUserPage(
                                        userId: widget.expert_id,
                                        type: "profile",
                                      ),
                                    );
                                    // controller.reportConversation(id);
                                  },
                                ),
                              ],
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
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.grey[300],
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(111, 0, 0, 0),
                              blurRadius: 0.5,
                              blurStyle: BlurStyle.normal,
                              spreadRadius: 0.1,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Icon(Icons.account_circle_sharp, size: 66, color: Colors.blueGrey.shade300,),
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder:
                                                (context) => Dialog(
                                                  backgroundColor:
                                                      Colors.grey.shade300,
                                                  child: GestureDetector(
                                                    onTap:
                                                        () =>
                                                            Navigator.of(
                                                              context,
                                                            ).pop(),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                        color: Colors
                                                            .grey
                                                            .shade300
                                                            .withOpacity(0.4),
                                                      ),
                                                      padding: EdgeInsets.all(
                                                        8,
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        child: Image.network(
                                                          IMG_API_URL +
                                                              widget.image,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                          );
                                        },
                                        child: Container(
                                          width: 75,
                                          height: 75,

                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                IMG_API_URL + widget.image,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  // Container(child: Icon(Icons.verified_rounded, color: Colors.blue, size: 18,), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(width: 10),

                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${widget.firstName} ${widget.lastName}',
                                        style: TextStyle(fontSize: 22),
                                      ),
                                      Row(
                                        children: [
                                          RatingBarIndicator(
                                            rating: widget.rate,

                                            itemBuilder:
                                                (context, index) => Icon(
                                                  Icons.star,
                                                  color: Colors.amber.shade600,
                                                ),

                                            itemCount: 5,
                                            itemSize: 25.0,
                                            direction: Axis.horizontal,
                                          ),
                                          SizedBox(width: 25),
                                          Container(
                                            child: Center(
                                              child: Text(
                                                " ${widget.comments.length} نظر ",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 20),

                                      Container(
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(
                                                Icons.share_location_sharp,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                              // SizedBox(width: 2,),
                                              if (widget.proposal)
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    4.0,
                                                  ),
                                                  child: Text(
                                                    "در نزدیکی شما",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade200,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // add expert proposal
                  if (widget.proposal) expert,
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 7,
                      left: 8.0,
                      right: 8.0,
                      bottom: 8.0,
                    ),
                    child: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.grey.shade100,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(111, 0, 0, 0),
                            blurRadius: 0.5,
                            blurStyle: BlurStyle.normal,
                            spreadRadius: 0.1,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DefaultTabController(
                            length: 3,
                            child: Column(
                              children: [
                                Container(
                                  height: 40,
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),

                                  child: TabBar(
                                    dividerHeight: 0,

                                    labelPadding: EdgeInsets.all(10),
                                    indicator: BoxDecoration(
                                      color: Colors.green.shade200,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),

                                    labelColor: Colors.white,

                                    indicatorWeight: 1,
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    onTap: (value) {
                                      switch (value) {
                                        case 0:
                                          scrollToSection(dataKey1);
                                          break;
                                        case 1:
                                          scrollToSection(dataKey2);
                                          break;
                                        case 2:
                                          scrollToSection(dataKey3);
                                          break;
                                        default:
                                          scrollToSection(dataKey1);
                                      }
                                    },
                                    unselectedLabelColor: Colors.black,
                                    tabs: const [
                                      Tab(text: 'اطلاعات متخصص'),
                                      Tab(text: 'نظرات'),
                                      Tab(text: 'گالری نمونه کار'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Row(
                          //     children: [
                          //     Icon(Icons.verified_outlined),
                          //     SizedBox(width: 5,),
                          //     Text("همه متخصصین احراز هویت شده اند ."),
                          //     ],
                          //   ),
                          // ),
                          Column(
                            children: [
                              DividerWithTextWidget(
                                text: "درباره من",
                                key: dataKey1,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(widget.about_me),
                              ),
                              DividerWithTextWidget(text: "ضمانت"),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(widget.garanty),
                              ),
                              DividerWithTextWidget(text: "اطلاعات تماس"),
                              if (widget.call)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 120,
                                    child: ListView(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.only(
                                        right: 15,
                                        left: 15,
                                        top: 10,
                                      ),
                                      scrollDirection: Axis.horizontal,
                                      itemExtentBuilder:
                                          (index, dimensions) => 90,
                                      children: [
                                        CallCard(
                                          text: "تماس",
                                          icon: Icons.phone_android,
                                          IconColor: Colors.lightBlueAccent,
                                          onPress:
                                              widget.done == true
                                                  ? () => controller.click(
                                                    widget.expert_id,
                                                    widget.service_id,
                                                    () => launchUrlString(
                                                      "tel://${widget.phone_number}",
                                                    ),
                                                  )
                                                  : () => launchUrlString(
                                                    "tel://${widget.phone_number}",
                                                  ),
                                        ),

                                        CallCard(
                                          text: "پیام",
                                          icon: Icons.sms_outlined,
                                          IconColor: Colors.amber,
                                          onPress:
                                              widget.done == true
                                                  ? () => controller.click(
                                                    widget.expert_id!,
                                                    widget.service_id!,
                                                    () => launchUrlString(
                                                      'sms:${widget.phone_number}',
                                                    ),
                                                  )
                                                  : () => launchUrlString(
                                                    'sms:${widget.phone_number}',
                                                  ),
                                        ),

                                        if (widget.telegram_link != null)
                                          CallCard(
                                            text: "تلگرام",
                                            icon: FontAwesomeIcons.telegram,
                                            IconColor: Colors.blue,
                                            onPress:
                                                widget.done == true
                                                    ? () => controller.click(
                                                      widget.expert_id!,
                                                      widget.service_id!,
                                                      () => launchUrlString(
                                                        'https://t.me/${widget.telegram_link}',
                                                      ),
                                                    )
                                                    : () => launchUrlString(
                                                      'https://t.me/${widget.telegram_link}',
                                                    ),
                                          ),

                                        if (widget.website_link != null)
                                          CallCard(
                                            text: "وبسایت",
                                            icon: Icons.web,
                                            IconColor: Colors.red,
                                            onPress:
                                                widget.done == true
                                                    ? () => controller.click(
                                                      widget.expert_id!,
                                                      widget.service_id!,
                                                      () => launchUrlString(
                                                        'https://${widget.website_link}',
                                                      ),
                                                    )
                                                    : () => launchUrlString(
                                                      'https://${widget.website_link}',
                                                    ),
                                          ),

                                        if (widget.whatsapp_link != null)
                                          CallCard(
                                            text: "واتساپ",
                                            icon: FontAwesomeIcons.whatsapp,
                                            IconColor: Colors.green,
                                            onPress:
                                                widget.done == true
                                                    ? () => controller.click(
                                                      widget.expert_id!,
                                                      widget.service_id!,
                                                      () => launchUrlString(
                                                        'https://wa.me/${widget.whatsapp_link}',
                                                      ),
                                                    )
                                                    : () => launchUrlString(
                                                      'https://wa.me/${widget.whatsapp_link}',
                                                    ),
                                          ),

                                        if (widget.eitaa_link != null)
                                          CallCard(
                                            text: "ایتا",
                                            image: "images/eatalogo.png",
                                            IconColor: Colors.white,
                                            onPress:
                                                widget.done == true
                                                    ? () => controller.click(
                                                      widget.expert_id!,
                                                      widget.service_id!,
                                                      () => launchUrlString(
                                                        'https://eitaa.com/${widget.eitaa_link}',
                                                      ),
                                                    )
                                                    : () => launchUrlString(
                                                      'https://eitaa.com/${widget.eitaa_link}',
                                                    ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),

                              Row(
                                children: [
                                  Icon(
                                    Icons.share_location_sharp,
                                    color: Colors.green,
                                    size: 29,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    widget.address,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(height: 10),

                          DividerWithTextWidget(text: "نظرها", key: dataKey2),

                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              left: 8.0,
                              right: 8.0,
                              bottom: 8.0,
                            ),
                            child: Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                color: Colors.green[100],
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(110, 255, 221, 221),
                                    blurRadius: 0.5,
                                    blurStyle: BlurStyle.normal,
                                    spreadRadius: 0.1,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        RatingBarIndicator(
                                          rating: widget.rate!,
                                          itemBuilder:
                                              (context, index) => Icon(
                                                Icons.star,
                                                color: Colors.amber.shade600,
                                              ),
                                          itemCount: 5,
                                          itemSize: 30.0,
                                          direction: Axis.horizontal,
                                        ),
                                        SizedBox(width: 20),
                                        Container(
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                4.0,
                                              ),
                                              child: Text(
                                                "${widget.rate!.toStringAsFixed(1)}",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        Container(
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                4.0,
                                              ),
                                              child: Text(
                                                "${widget.comments.length} نظر",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 160,
                                      child: ListView(
                                        padding: EdgeInsets.only(
                                          right: 2,
                                          left: 2,
                                          top: 2,
                                        ),
                                        scrollDirection: Axis.horizontal,
                                        // itemCount: widget.comments.length == 0 ?widget.comments.length:1,
                                        children:
                                            widget.comments.map<Widget>((c) {
                                              if (widget.comments.length == 0) {
                                                return Center(
                                                  child: Text(
                                                    "نظری وجود ندارد",
                                                  ),
                                                );
                                              }
                                              return CommentCard(
                                                starrate:
                                                    c['rating'].toDouble(),
                                                body:
                                                    c['comment'] != null
                                                        ? c['comment']
                                                        : "کارفرما نظری ثبت نکرده است",
                                                datetime: "",
                                                name: c['user']['name'],
                                              );
                                            }).toList(),
                                        // : const [
                                        // CommentCard(name: "نقی مرادی", body: "بسیار عالی کار تمیز و سریع ", datetime: "1403.01.02", starrate: 4.25,),
                                        // CommentCard(name: "نقی مرادی", body: "کار خوب بود ولی من راضی نیستم به شدت کار \n ککند پیش رفت", datetime: "1403.01.02", starrate: 3.25,),
                                        // CommentCard(name: "نقی مرادی", body: "بسیار عالی کار تمیز و سریع ", datetime: "1403.01.02", starrate: 4.3,),

                                        // ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          DividerWithTextWidget(
                            text: "گالری نمونه کار",
                            key: dataKey3,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              width: Get.width,
                              child: Wrap(
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.center,

                                children:
                                    widget.gallery.map<Widget>((g) {
                                      if (widget.gallery.length == 0) {
                                        return Text(
                                          "هیچ نمونه کاری وجود ندارد",
                                        );
                                      }
                                      return Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            // Handle image tap
                                            showDialog(
                                              context: context,
                                              builder:
                                                  (_) => Dialog(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    child: GestureDetector(
                                                      onTap:
                                                          () => Navigator.pop(
                                                            context,
                                                          ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              18,
                                                            ),
                                                        child: Image.network(
                                                          IMG_API_URL +
                                                              '/' +
                                                              g['path'],
                                                          fit: BoxFit.contain,
                                                          errorBuilder:
                                                              (
                                                                context,
                                                                error,
                                                                stackTrace,
                                                              ) => Center(
                                                                child: Icon(
                                                                  Icons
                                                                      .broken_image,
                                                                  color:
                                                                      Colors
                                                                          .grey,
                                                                  size: 60,
                                                                ),
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                            );
                                          },
                                          child: Container(
                                            width: 150,
                                            height: 150,
                                            child: Image.network(
                                              IMG_API_URL + g['path'],
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),

          // bottomNavigationBar: Mynav(currentIndex: _currentIndexe)
        ),
      ),
    );
  }
}
