import 'package:borotokar/controller/AuthController.dart';
import 'package:borotokar/utils/srbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class Rigister extends StatefulWidget {
  const Rigister({super.key});

  @override
  State<Rigister> createState() => _RigisterState();
}

class _RigisterState extends State<Rigister> {
  bool? male = true;
  bool? female = false;
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  AuthController authController = Get.find();
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormBuilderState>();

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

                title: const Text('ثبت نام'),

                actions: [],
              ),

              SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.info),
                        SizedBox(width: 2),
                        Text(
                          "به بروتوکار خوش آمدید ، نام و نام خانوادگی خود را وارد کنید!",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  FormBuilder(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
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
                                  enableSuggestions: true,
                                  name: 'نام',
                                  controller: firstname,
                                  onChanged: (val) {
                                    // Print the text value write into TextField
                                  },

                                  decoration: InputDecoration(
                                    labelText: 'نام ',
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

                              SizedBox(height: 25),

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
                                  enableSuggestions: true,
                                  name: 'نام خانوادگی',
                                  controller: lastname,
                                  onChanged: (val) {
                                    // Print the text value write into TextField
                                  },

                                  decoration: InputDecoration(
                                    labelText: 'نام خانوادگی',
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

                              CheckboxListTile(
                                value: male,
                                onChanged: (val) {
                                  if (female!) {
                                    setState(() {
                                      male = val;
                                      female = false;
                                    });
                                  }
                                },
                                title: Text('آقا '),
                              ),

                              CheckboxListTile(
                                value: female,
                                onChanged: (val) {
                                  if (male!) {
                                    setState(() {
                                      female = val;
                                      male = false;
                                    });
                                  }
                                },
                                title: Text('خانم'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Text(
                      "لمسی به وسعت نیاز های شما",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SrBox(
                      text: "",
                      image: Image.asset(
                        'images/register.jpg',
                        fit: BoxFit.contain,
                      ),
                      undertitle: true,
                      height: 200,
                      widget: Get.width,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        var first_name = firstname.text;
                        var last_name = lastname.text;
                        var sex = male! ? "Male" : "Fmale";
                        authController.registerUserAndProceed(
                          first_name,
                          last_name,
                          sex,
                        );
                      },

                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 55,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),

                        backgroundColor: Colors.lightGreenAccent,
                      ),
                      child: Text(
                        'ثبت اطلاعات',
                        style: TextStyle(color: Colors.black45),
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
