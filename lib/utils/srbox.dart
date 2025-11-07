import 'package:borotokar/pages/Type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SrBox extends StatelessWidget {
  final String text;
  final image;
  final double widget;
  final double  height;
  final bool undertitle;
  final nextPage;
  const SrBox({key,  required this.text,required this.image, this.widget = 79, this.height = 100, this.undertitle = false, this.nextPage = null}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: nextPage!=null ? nextPage : null,
      child: Container(
        width: 80,
        child: Column(
                children: [
                  
                  Container(
                      // height: height,
                      width: widget,
                    decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(103, 0, 0, 0),
                        blurRadius: 1,
                        spreadRadius: 0.1
                       )
                    ]
                    ),
                 padding: EdgeInsets.all(2),
                    child: Center(
                    child: Column(
                      children: [
                    image,
                    if(!undertitle)
                      Text(text, style: TextStyle( fontSize: 10, fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
        
                    ],
                    )
                ),   
              ),
              SizedBox(height: 2.5,),
              if(undertitle)
                  Text(text, style: TextStyle( fontSize: 10,), textAlign: TextAlign.center,),
                  
        
             
              
                ],
              ),
      ),
            );
        
  }
}