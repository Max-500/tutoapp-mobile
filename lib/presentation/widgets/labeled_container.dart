import 'package:flutter/material.dart';
import 'package:tuto_app/widgets.dart';

class LabeledContainer extends StatelessWidget {
  final String text;
  final IconButton? iconButton;
  final bool? isPro;
  final VoidCallback? callback;

  const LabeledContainer(
      {super.key,
      required this.text,
      this.iconButton,
      this.isPro,
      this.callback});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final double responsivePadding = screenWidth * 0.05;

    final double fontSizeText = screenWidth * 0.04;

    return Stack(clipBehavior: Clip.none, children: [
      InkWell(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
          bottomLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
        ),
        onTap: callback ?? () {},
        child: Container(
          height: screenHeight * 0.08,
          width: screenWidth * 0.75,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
              bottomLeft: Radius.circular(16.0),
              bottomRight: Radius.circular(16.0),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: responsivePadding),
            child: Row(
              children: [
                Expanded(
                    child: Center(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: const Color.fromRGBO(111, 12, 113, 1),
                      fontSize: fontSizeText,
                    ),
                  ),
                )),
                if (iconButton != null) iconButton!,
              ],
            ),
          ),
        ),
      ),
      if (isPro == true) const LabelPro()
    ]);
  }
}
