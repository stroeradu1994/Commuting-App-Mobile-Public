import 'package:flutter/material.dart';

/// type : 1
/// from : "123"
/// to : "234"
/// date : "232255"
/// time : "2222"

class RegisterTrip {
  int? _type;
  String? _car;
  String? _from;
  String? _to;
  DateTime? _date;
  TimeOfDay? _time;

  int? get type => _type;
  String? get car => _car;
  String? get from => _from;
  String? get to => _to;
  DateTime? get date => _date;
  TimeOfDay? get time => _time;


  set type(int? value) {
    _type = value;
  }

  RegisterTrip({
      int? type,
    String? car,
      String? from,
      String? to,
    DateTime? date,
    TimeOfDay? time}){
    _type = type;
    _car = car;
    _from = from;
    _to = to;
    _date = date;
    _time = time;
}

  RegisterTrip.fromJson(dynamic json) {
    _type = json["type"];
    _car = json["car"];
    _from = json["from"];
    _to = json["to"];
    _date = json["date"];
    _time = json["time"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["type"] = _type;
    map["from"] = _from;
    map["car"] = _car;
    map["to"] = _to;
    map["date"] = _date!.toIso8601String();
    map["time"] = _time!.hour.toString() + '-' + _time!.minute.toString();
    return map;
  }

  @override
  String toString() {
    return 'RegisterTrip{_type: $_type, _from: $_from, _to: $_to, _date: $_date, _time: $_time}';
  }

  set from(String? value) {
    _from = value;
  }

  set car(String? car) {
    _car = car;
  }

  set to(String? value) {
    _to = value;
  }

  set date(DateTime? value) {
    _date = value;
  }

  set time(TimeOfDay? value) {
    _time = value;
  }
}