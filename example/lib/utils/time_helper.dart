import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:example/models/availability.dart';

class TimeHelper {
  static List<Map<String, dynamic>> initTimeSlots(timeDuration) {
    List<Map<String, dynamic>> slots = [];
    for (var i = -1; i < 23; i++) {
      if (i < 9) {
        slots.add(jsonDecode('{"0${i + 1}:00":"busy"}'));
        slots.add(jsonDecode('{"0${i + 1}:30":"busy"}'));
      } else if (i >= 9) {
        slots.add(jsonDecode('{"${i + 1}:00":"busy"}'));
        slots.add(jsonDecode('{"${i + 1}:30":"busy"}'));
      }
    }
    return slots;
  }

  static List<Map<String, dynamic>> extractTimeSlots(
    initialTimeSlots,
    availabilities,
    selectedDay,
  ) {
    final List<Map<String, dynamic>> finalTimeSlots = [];
    final List<String> selectedKeys = [];
    final List<String> selectedValues = [];

    for (Availability availability in availabilities) {
      bool isSelectedDay = availability.day == selectedDay;
      if (isSelectedDay && availability.times != null) {
        for (var time in availability.times!) {
          time.forEach((key, value) {
            selectedKeys.add(key);
            selectedValues.add(value);
          });
        }
      }
    }

    for (var initialTimeSlot in initialTimeSlots) {
      initialTimeSlot.forEach((initKey, initValue) {
        if (selectedKeys.contains(initKey)) {
          final index = selectedKeys.indexOf(initKey);
          final value = selectedValues[index];
          finalTimeSlots.add(jsonDecode('{"$initKey":"$value"}'));
        } else {
          finalTimeSlots.add(initialTimeSlot);
        }
      });
    }

    return finalTimeSlots;
  }

  static Availability? getAvailability(availabilities, selectedDay) {
    for (Availability availability in availabilities) {
      if (availability.day == selectedDay) {
        return availability;
      }
    }
    return null;
  }

  static getDayNameAbbr(DateTime date) {
    String monthAbbreviated = DateFormat("MMM").format(date);
    String dayName = DateFormat("EEEE").format(date);
    int dayNumber = int.parse(DateFormat("d").format(date));
    String ordinalDayNumber = "$dayNumber${numberOrdinal(dayNumber)}";

    return "$dayName, $monthAbbreviated $ordinalDayNumber";
  }

  static String numberOrdinal(int number) {
    if (!(number >= 1 && number <= 100)) throw Exception('Invalid number');

    if (number >= 11 && number <= 13) return 'th';

    switch (number % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
