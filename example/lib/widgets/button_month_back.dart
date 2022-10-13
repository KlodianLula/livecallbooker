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
    final bool isPastMonth = DateHelper.isPastMonth(selectedDate);
    return ElevatedButton(
      onPressed: isPastMonth ? () => onBackArrow() : null,
      style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(15),
          primary: isPastMonth ? Colors.blue : Colors.grey),
      child: const Icon(Icons.arrow_back_outlined, color: Colors.white),
    );
  }
}
