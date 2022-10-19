import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({required this.child, required this.onPressed, Key? key})
      : super(key: key);
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ElevatedButton(
        child: child,
        onPressed: onPressed,
      ),
    );
  }
}
