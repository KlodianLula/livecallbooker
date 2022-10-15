import 'package:example/utils/date_helper.dart';
import 'package:flutter/material.dart';

class ButtonMonthBack extends StatelessWidget {
  const ButtonMonthBack(
      {Key? key, required this.selectedDate, required this.onBackArrow})
      : super(key: key);
  final DateTime selectedDate;
  final Function onBackArrow;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;

    final bool isPastMonth = DateHelper.isPastMonth(selectedDate);
    return ElevatedButton(
      onPressed: isPastMonth ? () => onBackArrow() : null,
      style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: screenWidth < 350
              ? const EdgeInsets.all(0)
              : const EdgeInsets.all(15),
          primary: isPastMonth ? Colors.blue : Colors.grey),
      child: screenWidth < 350
          ? const Icon(
              Icons.arrow_back_outlined,
              color: Colors.white,
              size: 20,
            )
          : const Icon(Icons.arrow_back_outlined, color: Colors.white),
    );
  }
}
