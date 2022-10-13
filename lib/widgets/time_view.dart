import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:livecallbooker/models/availability.dart';

class TimeView extends StatefulWidget {
  const TimeView({
    Key? key,
    required this.initialTimeSlots,
    required this.finalTimeSlots,
    required this.availabilities,
    required this.selectedDay,
    required this.dayName,
    required this.onTimeSelect,
    required this.isLoadingTime,
    required this.isLoadingDate,
    required this.timeKeyPressed,
  }) : super(key: key);
  final List<Map<String, dynamic>> initialTimeSlots;
  final List<Map<String, dynamic>> finalTimeSlots;
  final List<Availability>? availabilities;
  final int selectedDay;
  final String dayName;
  final Function onTimeSelect;
  final bool isLoadingTime;
  final bool isLoadingDate;
  final String timeKeyPressed;

  @override
  State<TimeView> createState() => _TimeViewState();
}

class _TimeViewState extends State<TimeView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: !widget.isLoadingDate
              ? Text(
                  widget.dayName,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black45,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )
              : Container(),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 600,
          child: Scrollbar(
            thickness: 10,
            controller: ScrollController(),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: !widget.isLoadingDate
                  ? Center(
                      child: Column(
                        children: widget.finalTimeSlots
                            .map((timeSlot) => _timeSlot(
                                timeSlot,
                                widget.timeKeyPressed,
                                widget.isLoadingTime,
                                widget.onTimeSelect,
                                context))
                            .toList(),
                      ),
                    )
                  : Container(),
            ),
          ),
        ),
      ],
    );
  }
}

Widget _timeSlot(Map<String, dynamic> data, String timeKeyPressed,
    bool isLoadingTime, Function onTimeSelect, BuildContext context) {
  String key = data.keys.toList().first;
  String value = data[key];
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: key == timeKeyPressed && isLoadingTime
        ? const Padding(
            padding: EdgeInsets.all(9.0),
            child: Center(
              child: CupertinoActivityIndicator(
                color: Colors.blueGrey,
                radius: 14.5,
              ),
            ),
          )
        : ChoiceChip(
            backgroundColor: const Color(0xFFE1E4F3),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),
            ),
            labelPadding:
                const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
            elevation: 1,
            label: Text(
              key,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.white, fontSize: 18),
            ),
            selected: value == "selected" || value == "booked",
            selectedColor: value == "booked"
                ? Colors.green[400]
                : value == "selected"
                    ? Colors.blue[400]
                    : Colors.blue[200],
            onSelected: (bool isSelected) {
              onTimeSelect(key, value);
            },
          ),
  );
}
