// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Enum? groupValue;
  final dynamic value; //bool or enum of the same type as groupValue

  const CustomButton({
    required this.text,
    required this.onPressed,
    required this.value,
    this.groupValue,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          color: Theme.of(context).colorScheme.inversePrimary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2,
            color: groupValue != null //depends on button type (?radio:toggle)
                ? value == groupValue
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).disabledColor
                : value
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).disabledColor,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 50,
              color: groupValue != null
                  ? value == groupValue
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).disabledColor
                  : value
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).disabledColor,
            ),
          ),
        ),
      ),
    );
  }
}
