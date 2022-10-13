// use this if you don't want the package
// import 'package:example/live_call_booker.dart';

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:livecallbooker/livecallbooker.dart';
import 'package:livecallbooker/utils/date_helper.dart';
import 'package:livecallbooker/utils/time_helper.dart';
import 'package:livecallbooker/models/availability.dart';
import 'package:example/api.dart';
import 'package:flutter/scheduler.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live Call Booker Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Live Call Booker Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // date
  late DateTime _todayDate;
  late DateTime _selectedDate;
  late String _monthName;
  late int _monthNumber;
  late int _yearNumber;
  late int _totalDaysOfMonth;
  late String _firstDayOfMonth;
  late List<String> _daysOfWeek;
  late List<String> _initialDateSlots;
  late int _selectedDay;
  List<Availability>? _availabilities;
  List<Map<String, dynamic>> _finalDateSlots = [];
  bool _isLoadingDate = true;

  //time
  late String _dayName;
  late int _timeDurationInMin;
  late List<Map<String, dynamic>> _initialTimeSlots;
  List<Map<String, dynamic>> _finalTimeSlots = [];
  String _timeKeyPressed = "";
  bool _isLoadingTime = false;

  bool _isHost = false;
  final api = Api();

  @override
  void initState() {
    // date
    _todayDate = DateTime.now();
    _monthName = DateHelper.getMonthName(_todayDate);
    _monthNumber = DateHelper.getMonthNumber(_todayDate);
    _yearNumber = DateHelper.getYearNumber(_todayDate);
    _daysOfWeek = DateHelper.weekDays();
    _firstDayOfMonth = DateHelper.dayOfMonth(_todayDate);
    _totalDaysOfMonth = DateHelper.totalDaysOfMonth(_todayDate);
    _initialDateSlots = DateHelper.initDateSlots(
        _daysOfWeek, _firstDayOfMonth, _totalDaysOfMonth);
    _selectedDay = DateHelper.getDayNumber(_todayDate);
    _selectedDate =
        DateHelper.getClickedDate(_yearNumber, _monthNumber, _selectedDay);

    // time
    _timeDurationInMin = 30;
    _initialTimeSlots = TimeHelper.initTimeSlots(_timeDurationInMin);
    _dayName = TimeHelper.getDayNameAbbr(_selectedDate);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _fetchData(_selectedDate);
    });
    super.initState();
  }

  void _fetchData(DateTime selectedDate) async {
    if (_isLoadingDate) {
      setState(() => _isLoadingDate = true);
    }
    String monthName = DateHelper.getMonthName(selectedDate).toLowerCase();
    int yearNumber = DateHelper.getYearNumber(selectedDate);

    try {
      var response = await api.fetchMonthAvailability(monthName, yearNumber);
      if ((response.statusCode! >= 200 && response.statusCode! < 300)) {
        _availabilities = Availability.fromList(response.data);
      } else {
        _availabilities = null;
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }

    fillSlots();
    // await Future.delayed(const Duration(seconds: 1));
    if (_isLoadingDate) {
      setState(() => _isLoadingDate = false);
    } else {
      setState(() {
        _timeKeyPressed = "";
        _isLoadingTime = false;
      });
    }
  }

  void fillSlots() {
    if (_availabilities != null) {
      _finalDateSlots =
          DateHelper.extractDateSlots(_initialDateSlots, _availabilities);

      _finalTimeSlots = TimeHelper.extractTimeSlots(
          _initialTimeSlots, _availabilities, _selectedDay);
    } else {
      _finalDateSlots = DateHelper.generateEmptyDateSlots(_initialDateSlots);
      // todo revise
      _finalTimeSlots = _initialTimeSlots;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: SizedBox(
          width: 750,
          child: LiveCallBooker(
            isHost: _isHost,
            onSwitchHost: _onSwitchHost,
            initialDateSlots: _initialDateSlots,
            finalDateSlots: _finalDateSlots,
            selectedDay: _selectedDay,
            selectedDate: _selectedDate,
            availabilities: _availabilities,
            totalDaysOfMonth: _totalDaysOfMonth,
            yearNumber: _yearNumber,
            monthName: _monthName,
            daysOfWeek: _daysOfWeek,
            initialTimeSlots: _initialTimeSlots,
            finalTimeSlots: _finalTimeSlots,
            timeKeyPressed: _timeKeyPressed,
            isLoadingTime: _isLoadingTime,
            isLoadingDate: _isLoadingDate,
            dayName: _dayName,
            onDaySelect: _onDaySelect,
            onTimeSelect: _onTimeSelect,
            onForwardArrow: _onForwardArrow,
            onBackArrow: _onBackArrow,
          ),
        ),
      ),
    );
  }

  void _onSwitchHost(bool value) {
    setState(() => _isHost = value);
  }

  void _onTimeSelect(String keySelected, String valueSelected) async {
    setState(() {
      _timeKeyPressed = keySelected;
      _isLoadingTime = true;
    });
    Availability? selectedAvailability =
        TimeHelper.getAvailability(_availabilities, _selectedDay);

    if (_isHost) {
      if (selectedAvailability == null) {
        // do nothing
        setState(() => _isLoadingTime = false);
      } else if (valueSelected == "busy") {
        // do nothing
        setState(() => _isLoadingTime = false);
      } else if (valueSelected == "selected") {
        List<Map<String, dynamic>> times = [];
        late int indexSelected;
        int index = 0;
        times.addAll(selectedAvailability.times!);
        for (var time in times) {
          time.forEach((key, _) {
            if (key == keySelected) {
              indexSelected = index;
            }
          });
          index++;
        }
        times.removeAt(indexSelected);
        times.add(jsonDecode('{"$keySelected":"booked"}'));

        index = 0;
        String? previousKeyBooked;
        for (var time in times) {
          time.forEach((key, value) {
            if (value == "booked" && key != keySelected) {
              previousKeyBooked = key;
              indexSelected = index;
            }
          });
          index++;
        }
        if (previousKeyBooked != null) {
          times.removeAt(indexSelected);
          times.add(jsonDecode('{"$previousKeyBooked":"selected"}'));
        }
        var bodyParams = {
          "times": [...times]
        };
        await api.updateTimeAvailability(selectedAvailability.id, bodyParams);
        _fetchData(_selectedDate);
      } else if (valueSelected == "booked") {
        // todo: must be only one booked
        List<Map<String, dynamic>> times = [];
        late int indexSelected;
        int index = 0;
        times.addAll(selectedAvailability.times!);
        for (var time in times) {
          time.forEach((key, _) {
            if (key == keySelected) {
              indexSelected = index;
            }
          });
          index++;
        }
        times.removeAt(indexSelected);
        times.add(jsonDecode('{"$keySelected":"selected"}'));
        var bodyParams = {
          "times": [...times]
        };
        await api.updateTimeAvailability(selectedAvailability.id, bodyParams);
        _fetchData(_selectedDate);
      }
      // is not host
    } else {
      // todo when times becomes empty don't color date
      if (selectedAvailability == null) {
        List<Map<String, dynamic>> times = [];
        times.add(jsonDecode('{"$keySelected":"selected"}'));
        var bodyParams = {
          "day": _selectedDay,
          "month": _monthName.toLowerCase(),
          "year": _yearNumber,
          "times": [...times]
        };
        await api.setTimeAvailability(bodyParams);
        _fetchData(_selectedDate);
      } else if (valueSelected == "busy") {
        List<Map<String, dynamic>> times = [];
        times.addAll(selectedAvailability.times!);
        times.add(jsonDecode('{"$keySelected":"selected"}'));
        var bodyParams = {
          "times": [...times]
        };
        await api.updateTimeAvailability(selectedAvailability.id, bodyParams);
        _fetchData(_selectedDate);
      } else if (valueSelected == "selected") {
        List<Map<String, dynamic>> times = [];
        late int indexSelected;
        int index = 0;
        times.addAll(selectedAvailability.times!);
        for (var time in times) {
          time.forEach((key, _) {
            if (key == keySelected) {
              indexSelected = index;
            }
          });
          index++;
        }
        times.removeAt(indexSelected);
        var bodyParams = {
          "times": [...times]
        };
        await api.updateTimeAvailability(selectedAvailability.id, bodyParams);
        _fetchData(_selectedDate);
      } else if (valueSelected == "booked") {
        // do nothing
        setState(() => _isLoadingTime = false);
      }
    }

    // if (_isHost) {
    //   if (selectedAvailability != null) {
    //     if (selectedAvailability.booked == null) {
    //       if (times.contains(timeSelected)) {
    //         var bodyParams = {"booked": timeSelected};
    //         await api.bookTimeSlot(selectedAvailability.id, bodyParams);
    //         _fetchData(_selectedDate);
    //       } else {
    //         // do nothing
    //         setState(() => _isLoadingTime = false);
    //       }
    //     } else {
    //       // unbook
    //       if (times.contains(timeSelected) &&
    //           timeSelected == selectedAvailability.booked) {
    //         var bodyParams = {
    //           "day": selectedAvailability.day,
    //           "month": selectedAvailability.month!.toLowerCase(),
    //           "year": selectedAvailability.year,
    //           "times": [...selectedAvailability.times!]
    //         };
    //         await api.unBookTimeSlot(selectedAvailability.id, bodyParams);
    //         _fetchData(_selectedDate);
    //       }
    //       // book other
    //       else if (times.contains(timeSelected) &&
    //           timeSelected != selectedAvailability.booked) {
    //         var bodyParams = {"booked": timeSelected};
    //
    //         await api.bookTimeSlot(selectedAvailability.id, bodyParams);
    //         _fetchData(_selectedDate);
    //       } else {
    //         // do nothing
    //         setState(() => _isLoadingTime = false);
    //       }
    //     }
    //   }
    // } else {
    //   if (selectedAvailability == null) {
    //     var bodyParams = {
    //       "day": _selectedDay,
    //       "month": _monthName.toLowerCase(),
    //       "year": _yearNumber,
    //       "times": [...times]
    //     };
    //     await api.setTimeAvailability(bodyParams);
    //     _fetchData(_selectedDate);
    //   } else {
    //     if (times.isNotEmpty) {
    //       if (times.isNotEmpty &&
    //           selectedAvailability.booked != null &&
    //           timeSelected == selectedAvailability.booked) {
    //         // do nothing
    //         setState(() => _isLoadingTime = false);
    //       } else {
    //         var bodyParams = {
    //           "times": [...times],
    //           "booked": selectedAvailability.booked
    //         };
    //         await api.updateTimeAvailability(
    //             selectedAvailability.id, bodyParams);
    //         _fetchData(_selectedDate);
    //       }
    //     } else {
    //       if (selectedAvailability.booked != null &&
    //           timeSelected == selectedAvailability.booked) {
    //         // do nothing
    //         setState(() => _isLoadingTime = false);
    //       } else if (selectedAvailability.booked != null &&
    //           timeSelected != selectedAvailability.booked) {
    //         var bodyParams = {
    //           "times": [...times],
    //           "booked": selectedAvailability.booked
    //         };
    //         await api.updateTimeAvailability(
    //             selectedAvailability.id, bodyParams);
    //         _fetchData(_selectedDate);
    //       } else {
    //         await api.deleteTimeAvailability(selectedAvailability.id);
    //         _fetchData(_selectedDate);
    //       }
    //     }
    //   }
    // }
  }

  void _onDaySelect(String daySelected) {
    setState(() {
      _selectedDay = int.parse(daySelected);
      _selectedDate =
          DateHelper.getClickedDate(_yearNumber, _monthNumber, _selectedDay);
      _dayName = TimeHelper.getDayNameAbbr(_selectedDate);
      fillSlots();
    });
  }

  void _onForwardArrow() async {
    setState(() {
      _isLoadingDate = true;
      if (_monthNumber == 12) {
        _yearNumber++;
        _monthNumber = 1;
      } else {
        _monthNumber++;
      }
      _selectedDay = 1;
      _selectedDate =
          DateHelper.getClickedDate(_yearNumber, _monthNumber, _selectedDay);
      _monthName = DateHelper.getMonthName(_selectedDate);
      _dayName = TimeHelper.getDayNameAbbr(_selectedDate);
      _daysOfWeek = DateHelper.weekDays();
      _firstDayOfMonth = DateHelper.dayOfMonth(_selectedDate);
      _totalDaysOfMonth = DateHelper.totalDaysOfMonth(_selectedDate);
      _initialDateSlots = DateHelper.initDateSlots(
          _daysOfWeek, _firstDayOfMonth, _totalDaysOfMonth);
      _initialTimeSlots = TimeHelper.initTimeSlots(_timeDurationInMin);
      _fetchData(_selectedDate);
    });
  }

  void _onBackArrow() {
    setState(() {
      _isLoadingDate = true;
      if (_monthNumber == 1) {
        _yearNumber--;
        _monthNumber = 12;
      } else {
        _monthNumber--;
      }
      _selectedDay =
          _monthNumber == DateTime.now().month ? DateTime.now().day : 1;
      _selectedDate =
          DateHelper.getClickedDate(_yearNumber, _monthNumber, _selectedDay);
      _monthName = DateHelper.getMonthName(_selectedDate);
      _dayName = TimeHelper.getDayNameAbbr(_selectedDate);
      _daysOfWeek = DateHelper.weekDays();
      _firstDayOfMonth = DateHelper.dayOfMonth(_selectedDate);
      _totalDaysOfMonth = DateHelper.totalDaysOfMonth(_selectedDate);
      _initialDateSlots = DateHelper.initDateSlots(
          _daysOfWeek, _firstDayOfMonth, _totalDaysOfMonth);
      _initialTimeSlots = TimeHelper.initTimeSlots(_timeDurationInMin);
      _fetchData(_selectedDate);
    });
  }
}
