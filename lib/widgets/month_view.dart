import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:livecallbooker/models/availability.dart';
import 'package:livecallbooker/utils/date_helper.dart';
import 'package:livecallbooker/widgets/button_month_back.dart';
import 'package:livecallbooker/widgets/button_month_forward.dart';
import 'package:intl/intl.dart';

class MonthView extends StatefulWidget {
  const MonthView({
    Key? key,
    required this.initialDateSlots,
    required this.finalDateSlots,
    required this.availabilities,
    required this.selectedDay,
    required this.selectedDate,
    required this.totalDaysOfMonth,
    required this.yearNumber,
    required this.monthName,
    required this.daysOfWeek,
    required this.onDaySelect,
    required this.onForwardArrow,
    required this.onBackArrow,
    required this.isLoadingDate,
  }) : super(key: key);
  final List<String> initialDateSlots;
  final List<Map<String, dynamic>> finalDateSlots;
  final List<Availability>? availabilities;
  final int selectedDay;
  final DateTime selectedDate;
  final int totalDaysOfMonth;
  final int yearNumber;
  final String monthName;
  final List<String> daysOfWeek;
  final Function onDaySelect;
  final Function onForwardArrow;
  final Function onBackArrow;
  final bool isLoadingDate;

  @override
  State<MonthView> createState() => _MonthViewState();
}

class _MonthViewState extends State<MonthView> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;

    return Container(
      decoration: BoxDecoration(color: Colors.grey[100]),
      child: Expanded(
        child: Center(
          child: Column(
            children: [
              Container(
                constraints: const BoxConstraints(minWidth: 300, maxWidth: 500),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(width: 40),
                      !widget.isLoadingDate
                          ? Text("${widget.monthName} ${widget.yearNumber}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                              color: Colors.black45,
                              fontSize: 20,
                              fontWeight: FontWeight.bold))
                          : Container(),
                      !widget.isLoadingDate
                          ? Row(
                        // mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ButtonMonthBack(
                                selectedDate: widget.selectedDate,
                                onBackArrow: widget.onBackArrow),
                            ButtonMonthForward(
                                selectedDate: widget.selectedDate,
                                onForwardArrow: widget.onForwardArrow)
                          ])
                          : Container(),
                    ],
                  ),
                ),
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 500),
                height:screenWidth > 350 ? 400 :310,
                child: widget.isLoadingDate
                    ? const Center(
                    child: CupertinoActivityIndicator(
                        color: Colors.blueGrey, radius: 14.5))
                    : Padding(
                  padding: screenWidth > 350
                      ? const EdgeInsets.symmetric(horizontal: 50)
                      : const EdgeInsets.all(0),
                  child: GridView(
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1),
                    children: widget.finalDateSlots
                        .map((dateSlot) => _dayNumber(
                        dateSlot,
                        widget.selectedDay,
                        widget.selectedDate,
                        widget.onDaySelect,
                        screenWidth,
                        context))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _dayNumber(Map<String, dynamic> data, selectedDay, selectedDate,
    Function onDaySelect, double screenWidth, BuildContext context) {
  String key = data.keys.toList().first;
  String value = data[key];
  int todayDay = int.parse(DateFormat("d").format(DateTime.now()));
  int todayMonth = int.parse(DateFormat("M").format(DateTime.now()));
  int todayYear = DateHelper.getYearNumber(DateTime.now());
  int selectedMonth = int.parse(DateFormat("M").format(selectedDate));
  int selectedYear = DateHelper.getYearNumber(selectedDate);
  bool isDayNumber = num.tryParse(key) != null;
  int dayNumber = isDayNumber ? int.parse(key) : -1;
  bool isNotCurrent = todayMonth != selectedMonth || todayYear != selectedYear;
  bool isDisabled = isDayNumber && dayNumber < todayDay && !isNotCurrent;

  return ChoiceChip(
    backgroundColor:
    dayNumber == selectedDay ? Colors.blue[400] : Colors.grey[100],
    shape: const CircleBorder(),
    labelPadding: key.length < 2
        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 8)
        : const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
    elevation: key == todayDay.toString() && !isNotCurrent ? 1 : 0,
    label: Text(
      !isDayNumber && key.isNotEmpty && screenWidth < 350 ? key[0] : key,
      style: !isDayNumber
          ? Theme.of(context).textTheme.headline3?.copyWith(
          color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)
          : Theme.of(context).textTheme.headline5?.copyWith(
          fontSize: 18,
          color: value == "selected"
              ? Colors.white
              : (dayNumber == selectedDay)
              ? Colors.white
              : Colors.grey),
    ),
    disabledColor: !isDayNumber ? Colors.grey[100] : Colors.grey[200],
    selected: value == "selected",
    selectedColor: value == "selected"
        ? dayNumber == selectedDay
        ? Colors.blue[400]
        : Colors.blue[100]
        : Colors.blue[100],
    onSelected: (!isDisabled && isDayNumber)
        ? (bool isSelected) => onDaySelect(key)
        : null,
  );
}

