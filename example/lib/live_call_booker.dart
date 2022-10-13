import 'package:flutter/material.dart';
import 'package:example/widgets/month_view.dart';
import 'package:example/widgets/time_view.dart';
import 'package:example/models/availability.dart';

class LiveCallBooker extends StatefulWidget {
  const LiveCallBooker({
    Key? key,
    required this.isHost,
    required this.onSwitchHost,
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
  final bool isHost;
  final Function onSwitchHost;
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
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                    widget.isHost
                        ? "Book one slot from available times:"
                        : "Choose the time slots when you are available:",
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.grey)),
                Row(
                  children: [
                    Switch(
                        value: widget.isHost,
                        activeColor: Colors.blue,
                        inactiveTrackColor: Colors.grey,
                        inactiveThumbColor: Colors.grey,
                        onChanged: (bool value) {
                          widget.onSwitchHost(value);
                        }),
                    Text("As Host",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(
                  top:
                      BorderSide(width: 3.0, color: Colors.lightBlue.shade600)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
