import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

class MyButton extends StatelessWidget {
  final backgroundColor;
  final textColor;
  final String buttonText;
  final buttonTapped;
  final textAlignment;
  final alignment;

  final ButtonStyle style = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ));

  final ButtonStyle style1 = ElevatedButton.styleFrom(
    padding: EdgeInsets.only(left: 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ));

  MyButton(
      {this.backgroundColor,
      this.buttonTapped,
      required this.buttonText,
      this.textColor,
      this.alignment,
      this.textAlignment});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 80.0, height: 80.0),
      child: ElevatedButton(
        style: (alignment == Alignment.center)? style : style1,
        onPressed: buttonTapped,
        child: Align(
          alignment: alignment,
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: textColor,
          ),
        ),
      ),
    );
  }
}
