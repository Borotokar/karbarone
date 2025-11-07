import 'package:flutter/material.dart';

class DividerWithTextWidget extends StatelessWidget {
  final String text;
  final Color textColor;
  const DividerWithTextWidget({super.key, required this.text, this.textColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    
    final line = Expanded(
        child: Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: const Divider(height: 10, thickness: 1, color: Color.fromARGB(255, 165, 214, 167)),
    ));

    return Row(children: [line, Text(text, style: TextStyle(fontSize: 20, color: textColor), ), line]);
    
  }
}