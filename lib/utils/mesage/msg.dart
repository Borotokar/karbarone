import 'package:flutter/material.dart';

class MsgCard extends StatelessWidget {
  final bool sender;
  final String text;
  final String time;
  const MsgCard({super.key, required this.sender, required this.text, required this.time});

  @override
  Widget build(BuildContext context) {
    if (sender) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        children: [
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: Color.fromARGB(102, 102, 187, 106),
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: 
              Padding(
                    padding: const EdgeInsets.only(left: 9.0, right: 15, top: 8, bottom: 8),
                    child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text, style: TextStyle(color: Colors.black, fontSize: 16, ),),
                  SizedBox(height: 5,),
                  Text(time, style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w300),),
                ],
              ),)
            ),
          
        ],
      ),
    );  
    }

    else {
      return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: Color.fromARGB(109, 68, 137, 255),
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: 
              Padding(
                    padding: const EdgeInsets.only(left: 9.0, right: 15, top: 8, bottom: 8),
                    child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text, style: TextStyle(color: Colors.black, fontSize: 16, ),),
                  SizedBox(height: 5,),
                  Text(time, style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w300),),
                ],
              ),)
            ),
          
        ],
      ),
    );
    };
  }
}