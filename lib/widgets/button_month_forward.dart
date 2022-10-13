import 'package:flutter/material.dart';

class ButtonMonthForward extends StatelessWidget {
  const ButtonMonthForward(
      {Key? key, required this.selectedDate, required this.onForwardArrow})
      : super(key: key);
  final DateTime selectedDate;
  final Function onForwardArrow;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onForwardArrow(),
      style: ElevatedButton.styleFrom(
          shape: const CircleBorder(), padding: const EdgeInsets.all(15)),
      child: const Icon(Icons.arrow_forward_outlined, color: Colors.white),
    );
  }
}
