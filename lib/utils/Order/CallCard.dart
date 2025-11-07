import 'package:flutter/material.dart';

class CallCard extends StatelessWidget {
  final String text;
  final icon;
  final double widget;
  final double  height;
  final IconColor;
  final image;
  final onPress;
  const CallCard({super.key, required this.text, this.icon = null,  this.widget = 55, this.height = 55, this.IconColor = Colors.blue, this.image = null, this.onPress});

  Widget imageroicon(){
    if(this.icon != null)
      return Icon(icon, size: 40, color: Colors.white,);
    if (this.image != null)
      return Image.asset(image, width: 39,);
    return Icon(icon, size: 40, color: Colors.white, );
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Column(
              children: [
                
                Container(
                    height: height,
                    width: widget,
                  decoration: BoxDecoration(
                  color: IconColor,
                  borderRadius: BorderRadius.circular(40),
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
                  child: imageroicon()
                 
              ),   
            ),
            SizedBox(height: 4,),
            Text(text, style: TextStyle( fontSize: 15,),),
                

           
            
              ],
            ),
            );
  }
}