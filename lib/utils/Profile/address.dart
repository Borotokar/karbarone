import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      // add this
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              snap: false,
              centerTitle: true,
              automaticallyImplyLeading: true,

              title: const Text('آدرس ها'),

              bottom: AppBar(
                automaticallyImplyLeading: false,
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: Get.width * 0.95,
                      height: 50,

                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        border: Border(
                          bottom: BorderSide(),
                          top: BorderSide(),
                          left: BorderSide(),
                          right: BorderSide(),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 45,
                            width: 200,
                            child: FormBuilderTextField(
                              enableSuggestions: true,
                              name: 'کدوم آدرس ؟',
                              onChanged: (val) {
                                // Print the text value write into TextField
                              },

                              decoration: InputDecoration(
                                labelText: 'کدوم آدرس ؟',
                                hintTextDirection: TextDirection.rtl,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                enabled: true,
                                icon: Icon(Icons.search),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SliverList(
              delegate: SliverChildListDelegate([
                AddressCard(address: "تهران تهران پارس کوچه 186 پلاک 3"),
                AddressCard(address: "تهران تهران پارس کوچه 186 پلاک 3"),
                AddressCard(address: "تهران تهران پارس کوچه 186 پلاک 3"),
                AddressCard(address: "تهران تهران پارس کوچه 186 پلاک 3"),
                AddressCard(address: "تهران تهران پارس کوچه 186 پلاک 3"),
                AddressCard(address: "تهران تهران پارس کوچه 186 پلاک 3"),
              ]),
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: null,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,

        // bottomNavigationBar: Mynav(currentIndex: _currentIndexe)
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  final String address;
  const AddressCard({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 6.0,
        top: 6.0,
        right: 12,
        left: 12,
      ),
      child: Container(
        width: Get.width * 0.6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.white60,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(102, 0, 0, 0),
              blurRadius: 2,
              blurStyle: BlurStyle.inner,
              spreadRadius: 0.6,
            ),
          ],
        ),
        height: 100,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 10.0, left: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 10),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address.replaceRange(32, null, "..."),
                        style: TextStyle(fontSize: 22),
                      ),
                      SizedBox(height: 5),

                      SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 270),
                          Text("ویرایش"),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward_ios_outlined, size: 18),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
