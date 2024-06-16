import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IconApp extends StatelessWidget {
  final double width;
  final double height;

  const IconApp({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: SvgPicture.asset('images/icono.svg', fit: BoxFit.contain,)
    );
  }
}