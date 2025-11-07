import 'package:flutter/material.dart';

class CircularImageLoader extends StatelessWidget {
  final String imageUrl;
  final double size;
  final bool done;

  const CircularImageLoader({
    Key? key,
    required this.imageUrl,
    this.size = 100.0,
    this.done = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (!done)
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            ),
          ClipOval(
            child: Image.network(
              imageUrl,
              width: size * 0.8,
              height: size * 0.8,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
