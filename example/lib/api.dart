import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

class Api {
  Future<Response> fetchMonthAvailability(monthName, yearNumber) {
    return Dio().get(
      'http://localhost:3000/days/?month=$monthName&year=$yearNumber',
    );
  }

  Future<Response> setTimeAvailability(bodyParams) {
    return Dio().post(
      'http://localhost:3000/days',
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      }),
      data: jsonEncode(bodyParams),
    );
  }

  Future<Response> updateTimeAvailability(id, bodyParams) {
    return Dio().patch(
      'http://localhost:3000/days/$id',
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      }),
      data: jsonEncode(bodyParams),
    );
  }

  Future<Response> deleteTimeAvailability(id) {
    return Dio().delete('http://localhost:3000/days/$id');
  }

  Future<Response> bookTimeSlot(id, bodyParams) {
    return Dio().patch(
      'http://localhost:3000/days/$id',
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      }),
      data: jsonEncode(bodyParams),
    );
  }

  Future<Response> unBookTimeSlot(id, bodyParams) {
    return Dio().put(
      'http://localhost:3000/days/$id',
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      }),
      data: jsonEncode(bodyParams),
    );
  }
}
