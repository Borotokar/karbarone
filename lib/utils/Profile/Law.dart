import 'package:borotokar/controller/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MyLaw extends StatefulWidget {
  const MyLaw({super.key});

  @override
  State<MyLaw> createState() => _MyLawState();
}

class _MyLawState extends State<MyLaw> {
  AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    authController.fetchlaw();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Directionality( // add this
        textDirection: TextDirection.rtl,
      child:Scaffold(
      body: Obx((){
        if (authController.isLoading.value) {
          return Scaffold(
            body: Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.greenAccent,
              size: 50,
            )));
        }
        return CustomScrollView(
        
        slivers: [
          SliverAppBar(

            floating: true,
            pinned: true,
            snap: false,
            centerTitle: true,
            automaticallyImplyLeading: true,
            
            title: const Text('شرایط و قوانین'),
            
            actions: [
            
            ],

            
          ),

         SliverList(
            delegate: SliverChildListDelegate(
              [
                
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(authController.law.toString(),
                  style: TextStyle(
                    fontSize: 22
                  ),),
                )

            ]),
          ),
        ],
      );
      }),


      
      // bottomNavigationBar: Mynav(currentIndex: _currentIndexe)
      ));
  }
}