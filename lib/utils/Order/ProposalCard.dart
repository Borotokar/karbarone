import 'package:borotokar/Congit.dart';
import 'package:borotokar/utils/Order/ExpertProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'dart:math';

import 'package:url_launcher/url_launcher_string.dart';

class ProposalCard extends StatelessWidget {
  const ProposalCard({
    super.key,
    this.comment = false,
    this.image = "",
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
    required this.mesage,
    required this.proposed_price,
    required this.proposed_type,
    this.onPrress,
    this.rating,
    required this.website_link,
    required this.about_me,
    required this.garanty,
    this.buttonName = "تایید متخصص",
    this.done = false,
    required this.service_id,
    this.onCallButton,
    required this.expert_id,
    this.type = "",
    this.call = true,
    this.buttonCancel = "لغو پیشنهاد",
    this.onButtonCancel,
  });
  final int service_id;
  final bool done;
  final int expert_id;
  final bool comment;
  final String image;
  final String firstName;
  final String lastName;
  final onPrress;
  final String buttonName;
  final comments;
  final gallery;
  final double rate;
  final String address;
  final String phone_number;
  final String? website_link;
  final String about_me;
  final String garanty;
  final String? eitaa_link;
  final String? telegram_link;
  final String? whatsapp_link;
  final String mesage;
  final String proposed_price;
  final String type;
  final String proposed_type;
  final rating;
  final onCallButton;
  final call;
  final String? buttonCancel;
  final onButtonCancel;

  rand() {
    var rng = Random();
    return rng.nextInt(100);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          Get.to(
            EProfile(
              expert_id: expert_id,
              service_id: service_id,
              done: done,
              website_link: website_link,
              about_me: about_me,
              garanty: garanty,
              image: image,
              firstName: firstName,
              lastName: lastName,
              comments: comments,
              gallery: gallery,
              rate: rate,
              address: address,
              phone_number: phone_number,
              eitaa_link: eitaa_link,
              call: call,
              telegram_link: telegram_link,
              whatsapp_link: whatsapp_link,
              mesage: mesage,
              proposed_price: proposed_price,
              proposed_type: type,
            ),
          );
        },
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon(Icons.account_circle_sharp, size: 66, color: Colors.blueGrey.shade300,),
                        Container(
                          width: 65,
                          height: 65,

                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(IMG_API_URL + image),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Container(child: Icon(Icons.verified_rounded, color: Colors.blue, size: 18,), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(width: 10),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          firstName + " " + lastName,
                          style: TextStyle(fontSize: 20),
                        ),
                        Row(
                          children: [
                            if (!comment!)
                              RatingBarIndicator(
                                rating: rate!,

                                itemBuilder:
                                    (context, index) => Icon(
                                      Icons.star,
                                      color: Colors.amber.shade600,
                                    ),

                                itemCount: 5,
                                itemSize: 25.0,
                                direction: Axis.horizontal,
                              ),
                            if (comment) rating,
                            // SizedBox(width: 25,),
                            Container(
                              child: Text(
                                !comment
                                    ? "  ${comments.length} نظر  "
                                    : "  ستاره بدهید  ",
                                style: TextStyle(fontSize: 10),
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
                        if (!comment)
                          Row(
                            children: [
                              Container(
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          "$type : ${proposed_price}  تومان ",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
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
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          "در نزدیکی شما",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
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
                SizedBox(height: 8),
                if (comment == false)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Get.to(
                            EProfile(
                              expert_id: expert_id,
                              service_id: service_id,
                              done: done,
                              website_link: website_link,
                              about_me: about_me,
                              garanty: garanty,
                              image: image,
                              firstName: firstName,
                              lastName: lastName,
                              comments: comments,
                              gallery: gallery,
                              rate: rate,
                              address: address,
                              phone_number: phone_number,
                              eitaa_link: eitaa_link,
                              call: call,
                              telegram_link: telegram_link,
                              whatsapp_link: whatsapp_link,
                              mesage: mesage,
                              proposed_price: proposed_price,
                              proposed_type: type,
                            ),
                          );
                        },

                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.only(right: 5, left: 5),
                          // fixedSize: Size(250, 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: Colors.green,
                        ),
                        child: Text(
                          done! ? 'مشاهده پروفایل ' : 'مشاهده پروفایل ',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      if (done != true)
                        ElevatedButton(
                          onPressed: onPrress,

                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.only(right: 5, left: 5),

                            // fixedSize: Size(250, 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          child: Text(
                            buttonName!,
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),

                      if (onButtonCancel != null)
                        ElevatedButton(
                          onPressed: onButtonCancel,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.only(right: 5, left: 5),
                            // fixedSize: Size(250, 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor: Colors.red,
                          ),
                          child: Text(
                            buttonCancel!,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),

                      if (call)
                        FloatingActionButton(
                          heroTag: "btn${rand()}",
                          onPressed:
                              done!
                                  ? onCallButton
                                  : () =>
                                      launchUrlString("tel://${phone_number}"),
                          tooltip: 'Increment',
                          backgroundColor: Colors.white,
                          mini: true,
                          child: const Icon(Icons.call),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// "bids": [
//         {
//             "id": 2,
//             "order_id": 19,
//             "expert_id": 7,
//             "proposed_price": "1000",
//             "type": "whole_job",
//             "description": "This is my offer for the job.",
//             "created_at": "2024-09-03T14:46:34.000000Z",
//             "updated_at": "2024-09-03T14:46:34.000000Z",
//             "expert": {
//                 "id": 7,
//                 "phone_number": "09103907855",
//                 "first_name": "دانیال",
//                 "last_name": "ده‌نبی",
//                 "national_id": "0200667580",
//                 "birth_date": "1384-05-10",
//                 "type": "business_unit",
//                 "telegram_link": null,
//                 "whatsapp_link": null,
//                 "eitaa_link": null,
//                 "address": "#",
//                 "province": "#",
//                 "city": "#",
//                 "lat": "30.000000",
//                 "log": "30.000000",
//                 "is_active": 1,
//                 "profile_image": "img/default.png",
//                 "company_name": null,
//                 "registration_number": null,
//                 "created_at": "2024-09-03T14:22:01.000000Z",
//                 "updated_at": "2024-09-03T14:29:35.000000Z",
//                 "comments": [],
//                 "gallery": []
