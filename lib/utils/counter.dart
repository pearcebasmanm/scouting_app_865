//copied increment decrement idea from stackoverflow, credit does to funder7
//https://stackoverflow.com/a/65271573

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import '../utils/palette.dart';

class Counter extends StatelessWidget {
  final String label;
  final int value;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const Counter({
    required this.onIncrease,
    required this.onDecrease,
    this.label = "",
    this.value = 0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
      mainAxisAlignment: MainAxisAlignment.center,
      direction: Axis.vertical,
      children: [
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(width: 10),
              Text(
                '$value',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  onDecrease();
                  HapticFeedback.lightImpact();
                  Feedback.forTap(context);
                },
                child: const Icon(
                  Icons.remove_rounded,
                  size: 60,
                ),
              ),
              GestureDetector(
                onTap: () {
                  onIncrease();
                  HapticFeedback.lightImpact();
                  Feedback.forTap(context);
                },
                child: const Icon(
                  Icons.add_rounded,
                  size: 60,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
