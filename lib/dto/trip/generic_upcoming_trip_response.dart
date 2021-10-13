import 'package:commuting_app_mobile/dto/location/location_response.dart';

/// tripId : "402880007ae2f991017ae34c25480001"
/// fromLocation : {"id":"402880007ae2d924017ae2f85c000002","label":"Home","address":"Strada Râmnicu Vâlcea 19, București, Romania","point":{"lat":44.4156433,"lng":26.141303300000004}}
/// toLocation : {"id":"402880007ae2d924017ae2f8b6ca0003","label":"Work","address":"Strada Popa Nan 139, București, Romania","point":{"lat":44.429275942591595,"lng":26.126607432961464}}
/// leaveTime : "2021-07-26T18:50:39.462350"
/// driver : true

class GenericUpcomingTripResponse {
  String? _tripId;
  LocationResponse? _fromLocation;
  LocationResponse? _toLocation;
  String? _leaveTime;
  String? _arriveTime;
  bool? _driver;
  bool? _confirmed;
  int? _passengers;

  String? get tripId => _tripId;

  LocationResponse? get fromLocation => _fromLocation;

  LocationResponse? get toLocation => _toLocation;

  String? get leaveTime => _leaveTime;

  String? get arriveTime => _arriveTime;

  bool? get driver => _driver;
  bool? get confirmed => _confirmed;
  int? get passengers => _passengers;

  GenericUpcomingTripResponse(
      {String? tripId,
      LocationResponse? fromLocation,
      LocationResponse? toLocation,
      String? leaveTime,
      String? arriveTime,
        bool? confirmed,
        int? passengers,
      bool? driver}) {
    _tripId = tripId;
    _fromLocation = fromLocation;
    _toLocation = toLocation;
    _leaveTime = leaveTime;
    _confirmed = confirmed;
    _passengers = passengers;
    _arriveTime = arriveTime;
    _driver = driver;
  }

  GenericUpcomingTripResponse.fromJson(dynamic json) {
    _tripId = json["tripId"];
    _fromLocation = json["fromLocation"] != null
        ? LocationResponse.fromJson(json["fromLocation"])
        : null;
    _toLocation = json["toLocation"] != null
        ? LocationResponse.fromJson(json["toLocation"])
        : null;
    _leaveTime = json["leaveTime"];
    _arriveTime = json["arriveTime"];
    _confirmed = json["confirmed"];
    _passengers = json["passengers"];
    _driver = json["driver"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["tripId"] = _tripId;
    if (_fromLocation != null) {
      map["fromLocation"] = _fromLocation?.toJson();
    }
    if (_toLocation != null) {
      map["toLocation"] = _toLocation?.toJson();
    }
    map["leaveTime"] = _leaveTime;
    map["arriveTime"] = _arriveTime;
    map["confirmed"] = _confirmed;
    map["passengers"] = _passengers;
    map["driver"] = _driver;
    return map;
  }
}
