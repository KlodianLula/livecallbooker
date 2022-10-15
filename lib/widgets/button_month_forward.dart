import 'package:flutter/material.dart';

class ButtonMonthForward extends StatelessWidget {
  const ButtonMonthForward(
      {Key? key, required this.selectedDate, required this.onForwardArrow})
      : super(key: key);
  final DateTime selectedDate;
  final Function onForwardArrow;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    return ElevatedButton(
      onPressed: () => onForwardArrow(),
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: screenWidth < 350
            ? const EdgeInsets.all(0)
            : const EdgeInsets.all(15),
      ),
      child: screenWidth < 350
          ? const Icon(
        Icons.arrow_forward_outlined,
        color: Colors.white,
        size: 20,
      )
          : const Icon(Icons.arrow_forward_outlined, color: Colors.white),
    );
  }
}
