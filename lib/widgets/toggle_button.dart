// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scouting_app_865/utils/theme.dart';

class ToggleButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Enum? groupValue;
  final dynamic value; //bool or enum of the same type as groupValue

  const ToggleButton({
    required this.text,
    required this.onPressed,
    required this.value,
    this.groupValue,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color hightlightColor =
        groupValue != null //depends on button type (?radio:toggle)
            ? value == groupValue
                ? palette().primary
                : Theme.of(context).disabledColor
            : value
                ? palette().primary
                : Theme.of(context).disabledColor;

    return GestureDetector(
      onTap: () {
        groupValue != null ? onPressed(value) : onPressed();
        HapticFeedback.lightImpact(); //touch feedback
        Feedback.forTap(context); //sound feedback
      },
      child: Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: palette().background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2,
            color: hightlightColor,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 50,
              color: hightlightColor,
            ),
          ),
        ),
      ),
    );
  }
}
