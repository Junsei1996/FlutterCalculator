import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

class MyButton extends StatelessWidget {
  final backgroundColor;
  final textColor;
  final String buttonText;
  final buttonTapped;

  final ButtonStyle style = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ));

  MyButton(
      {this.backgroundColor,
      this.buttonTapped,
      required this.buttonText,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 80.0, height: 80.0),
      child: ElevatedButton(
        style: style,
        onPressed: buttonTapped,
        child: Text(
          buttonText,
          style: TextStyle(color: textColor, fontSize: 30),
        ),
      ),
    );
  }
}
