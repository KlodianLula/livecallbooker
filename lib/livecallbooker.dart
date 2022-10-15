library livecallbooker;

import 'package:flutter/material.dart';
import 'package:livecallbooker/widgets/month_view.dart';
import 'package:livecallbooker/widgets/time_view.dart';
import 'package:livecallbooker/models/availability.dart';

class LiveCallBooker extends StatefulWidget {
  const LiveCallBooker({
    Key? key,
    required this.initialDateSlots,
    required this.finalDateSlots,
    required this.selectedDay,
    required this.selectedDate,
    required this.totalDaysOfMonth,
    required this.daysOfWeek,
    required this.initialTimeSlots,
    required this.finalTimeSlots,
    required this.availabilities,
    required this.yearNumber,
    required this.timeKeyPressed,
    required this.isLoadingTime,
    required this.isLoadingDate,
    required this.monthName,
    required this.dayName,
    required this.onDaySelect,
    required this.onTimeSelect,
    required this.onForwardArrow,
    required this.onBackArrow,
  }) : super(key: key);
  final List<String> initialDateSlots;
  final List<Map<String, dynamic>> finalDateSlots;
  final int selectedDay;
  final DateTime selectedDate;
  final List<Availability>? availabilities;
  final int totalDaysOfMonth;
  final int yearNumber;
  final String monthName;
  final List<String> daysOfWeek;
  final List<Map<String, dynamic>> initialTimeSlots;
  final List<Map<String, dynamic>> finalTimeSlots;
  final String timeKeyPressed;
  final bool isLoadingTime;
  final bool isLoadingDate;
  final String dayName;
  final Function onDaySelect;
  final Function onTimeSelect;
  final Function onForwardArrow;
  final Function onBackArrow;

  @override
  State<LiveCallBooker> createState() => LiveCallBookerState();
}

class LiveCallBookerState extends State<LiveCallBooker> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;

    List<Widget> children = [
      MonthView(
        initialDateSlots: widget.initialDateSlots,
        finalDateSlots: widget.finalDateSlots,
        availabilities: widget.availabilities,
        selectedDay: widget.selectedDay,
        selectedDate: widget.selectedDate,
        totalDaysOfMonth: widget.totalDaysOfMonth,
        yearNumber: widget.yearNumber,
        monthName: widget.monthName,
        daysOfWeek: widget.daysOfWeek,
        onDaySelect: widget.onDaySelect,
        onForwardArrow: widget.onForwardArrow,
        onBackArrow: widget.onBackArrow,
        isLoadingDate: widget.isLoadingDate,
      ),
      TimeView(
        initialTimeSlots: widget.initialTimeSlots,
        finalTimeSlots: widget.finalTimeSlots,
        availabilities: widget.availabilities,
        dayName: widget.dayName,
        onTimeSelect: widget.onTimeSelect,
        selectedDay: widget.selectedDay,
        isLoadingTime: widget.isLoadingTime,
        isLoadingDate: widget.isLoadingDate,
        timeKeyPressed: widget.timeKeyPressed,
      ),
    ];

    return width > 700
        ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: children)
        : Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children);
  }
}

