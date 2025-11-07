import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class ProssingCard extends StatelessWidget {
  const ProssingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
      child: GestureDetector( 
        onTap: () {
         
        },
        child:  Container(
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.grey[300],
          boxShadow: [
            BoxShadow(
                      color: Color.fromARGB(111, 0, 0, 0),
                      blurRadius: 0.5,
                      blurStyle: BlurStyle.normal,
                      spreadRadius: 0.1
                     )
          ]
        ),
        height: 75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Icon(Icons.account_circle_sharp, size: 66, color: Colors.blueGrey.shade300,)
              ],
            ),

            SizedBox(width: 10,),

             Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("درحال پردازش . . .", style: TextStyle(fontSize: 22),),
                RatingBarIndicator(
                      rating: 0,
                      itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber.shade600,
                      ),
                      itemCount: 5,
                      itemSize: 25.0,
                      direction: Axis.horizontal,
                  ),
            
                
              ],
            ),
          ],
        ),
      )),
    );
  }
}