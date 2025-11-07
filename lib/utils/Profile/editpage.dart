import 'package:borotokar/controller/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class Editpage extends StatefulWidget {
  const Editpage({super.key});

  @override
  State<Editpage> createState() => _EditpageState();
}

class _EditpageState extends State<Editpage> {
  bool? male = false;
  bool? female = false;
  final name = TextEditingController();
  AuthController authController = Get.find();
  aa() {
    authController.fetchAndSetUserData();
    try {
      name.text = authController.userData['user']['name'].toString();
      if (authController.userData['user']['sex'].toString() == "Male") {
        male = true;
        female = false;
      } else if (authController.userData['user']['sex'].toString() == "Fmale") {
        female = true;
        male = false;
      }
    } catch (e) {
      Get.log(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    aa();
    super.initState();
  }

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

                title: const Text('ویرایش اطلاعات'),

                actions: [],
              ),

              SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: 10),
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
                                  controller: name,
                                  onChanged: (val) {
                                    // Print the text value write into TextField
                                  },

                                  decoration: InputDecoration(
                                    labelText: 'نام و نام خانوادگی ',
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

                              CheckboxListTile(
                                value: male,
                                onChanged: (val) {
                                  setState(() {
                                    male = true;
                                    female = false;
                                  });
                                },
                                title: Text('آقا '),
                              ),

                              CheckboxListTile(
                                value: female,
                                onChanged: (val) {
                                  setState(() {
                                    female = true;
                                    male = false;
                                  });
                                },
                                title: Text('خانم'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // var name = ;
                        var sex = male! ? "Male" : "Fmale";
                        authController.editUserInfo(name.text, sex);
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
                        'ویرایش اطلاعات',
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
