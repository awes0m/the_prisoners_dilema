// circular_app_icon with asset image

import 'package:flutter/material.dart';

class CircularAppIcon extends StatelessWidget {
  final double size;

  const CircularAppIcon({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage('assets/prisoners_dilema.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
