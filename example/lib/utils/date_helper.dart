import 'package:example/models/availability.dart';
import 'package:intl/intl.dart';

class DateHelper {
  static List<String> initDateSlots(
      daysOfWeek, firstDayOfMonth, totalDaysOfMonth) {
    List<String> initialDateSlots = [];
    for (var i = 0; i < 7; i++) {
      initialDateSlots.add(daysOfWeek[i].substring(0, 3));
    }
    // change if different first day of week: 0 is for Monday
    int firstDayOfWeekIndex = 0;
    int firstDayOfMonthIndex = daysOfWeek.indexOf(firstDayOfMonth);
    // if firstDayOfMonth is Tuesday, firstDayOfMonthIndex is equal to 1.
    int daysToSkip = firstDayOfMonthIndex - firstDayOfWeekIndex;
    int dayNumber = 0;

    while (daysToSkip > 0) {
      initialDateSlots.add("");
      daysToSkip--;
    }

    while (totalDaysOfMonth > 0) {
      dayNumber++;
      initialDateSlots.add(dayNumber.toString());
      totalDaysOfMonth--;
    }

    return initialDateSlots;
  }

  static List<Map<String, dynamic>> extractDateSlots(
      initialDateSlots, availabilities) {
    final List<Map<String, dynamic>> dateSlots = [];
    final List<String> selectedDateSlots = [];
    for (Availability availability in availabilities!) {
      if (availability.times != null && availability.times!.isNotEmpty) {
        selectedDateSlots.add(availability.day.toString());
      }
    }
    for (var slot in initialDateSlots) {
      Map<String, dynamic> slotMap = selectedDateSlots.contains(slot)
          ? {slot: "selected"}
          : {slot: "busy"};
      dateSlots.add(slotMap);
    }
    return dateSlots;
  }

  static List<Map<String, dynamic>> generateEmptyDateSlots(initialDateSlots) {
    final List<Map<String, dynamic>> dateSlots = [];
    for (var slot in initialDateSlots) {
      Map<String, dynamic> slotMap = {slot: "busy"};
      dateSlots.add(slotMap);
    }
    return dateSlots;
  }

  static List<String> weekDays() {
    return [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
  }

  static String dayOfWeek(todayDate) {
    return DateFormat('EEEE').format(todayDate);
  }

  static String dayOfMonth(todayDate) {
    return DateFormat('EEEE')
        .format(DateTime(todayDate.year, todayDate.month, 1));
  }

  static int totalDaysOfMonth(DateTime date) {
    var firstDayOfMonth = DateTime(date.year, date.month, date.day);
    var firstDayNextMonth = DateTime(
        firstDayOfMonth.year, firstDayOfMonth.month + 1, firstDayOfMonth.day);

    ///fixed march issue!
    var num = firstDayNextMonth.difference(firstDayOfMonth).inDays;
    if (DateHelper.getMonthNumber(date) == 3) return num + 1;
    return num;
  }

  static String getMonthName(DateTime date) {
    return DateFormat("MMMM").format(date);
  }

  static int getMonthNumber(DateTime date) {
    return int.parse(DateFormat("M").format(date));
  }

  static int getDayNumber(DateTime date) {
    return int.parse(DateFormat("d").format(date));
  }

  static int getYearNumber(DateTime date) {
    return int.parse(DateFormat("y").format(date));
  }

  static DateTime getClickedDate(yearNumber, monthNumber, selectedDay) {
    return DateTime(yearNumber, monthNumber, selectedDay, 0, 0, 0, 0, 0);
  }

  static bool isPastMonth(selectedDate) {
    return selectedDate.month - DateTime.now().month > 0 ||
        (selectedDate.month - DateTime.now().month <= 0 &&
            selectedDate.year != DateTime.now().year);
  }
}
