import 'package:commuting_app_mobile/dto/location/location_response.dart';

/// tripId : "402880007afcd26b017afcd2d0fd0010"
/// arriveTime : "2021-07-31T19: 00: 33.901352"
/// pickUpDropTime : "2021-07-31T17: 46: 53.901352"
/// nextStopPassengerName : "null"
/// next : false
/// driver : true
/// pickup : true

class GenericActiveTripResponse {
  String? _tripId;
  LocationResponse? _fromLocation;
  LocationResponse? _toLocation;
  String? _arriveTime;
  String? _pickUpDropTime;
  String? _nextStopPassengerName;
  bool? _next;
  bool? _driver;
  bool? _pickup;

  String? get tripId => _tripId;

  String? get arriveTime => _arriveTime;

  String? get pickUpDropTime => _pickUpDropTime;

  String? get nextStopPassengerName => _nextStopPassengerName;

  bool? get next => _next;

  bool? get driver => _driver;

  bool? get pickup => _pickup;

  LocationResponse? get fromLocation => _fromLocation;

  LocationResponse? get toLocation => _toLocation;

  GenericActiveTripResponse(
      {String? tripId,
      LocationResponse? fromLocation,
      LocationResponse? toLocation,
      String? arriveTime,
      String? pickUpDropTime,
      String? nextStopPassengerName,
      bool? next,
      bool? driver,
      bool? pickup}) {
    _tripId = tripId;
    _arriveTime = arriveTime;
    _pickUpDropTime = pickUpDropTime;
    _fromLocation = fromLocation;
    _toLocation = toLocation;
    _nextStopPassengerName = nextStopPassengerName;
    _next = next;
    _driver = driver;
    _pickup = pickup;
  }

  GenericActiveTripResponse.fromJson(dynamic json) {
    _tripId = json["tripId"];
    _arriveTime = json["arriveTime"];
    _fromLocation = json["fromLocation"] != null
        ? LocationResponse.fromJson(json["fromLocation"])
        : null;
    _toLocation = json["toLocation"] != null
        ? LocationResponse.fromJson(json["toLocation"])
        : null;
    _pickUpDropTime = json["pickUpDropTime"];
    _nextStopPassengerName = json["nextStopPassengerName"];
    _next = json["next"];
    _driver = json["driver"];
    _pickup = json["pickup"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["tripId"] = _tripId;
    map["arriveTime"] = _arriveTime;
    map["pickUpDropTime"] = _pickUpDropTime;
    if (_fromLocation != null) {
      map["fromLocation"] = _fromLocation?.toJson();
    }
    if (_toLocation != null) {
      map["toLocation"] = _toLocation?.toJson();
    }
    map["nextStopPassengerName"] = _nextStopPassengerName;
    map["next"] = _next;
    map["driver"] = _driver;
    map["pickup"] = _pickup;
    return map;
  }
}
