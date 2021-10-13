import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:commuting_app_mobile/dto/direction/bound.dart';

/// path : "string"
/// distance : 0
/// duration : 0

class GetRoutesResult {
  String? _id;
  String? _path;
  double? _distance;
  double? _duration;
  Bound? _bounds;

  String? get id => _id;

  String? get path => _path;

  double? get distance => _distance;

  double? get duration => _duration;

  Bound? get bounds => _bounds;

  GetRoutesResult(
      {String? id,String? path,
      double? distance,
      double? duration,
        Bound? bounds}) {
    _id = id;
    _path = path;
    _distance = distance;
    _duration = duration;
    _bounds = bounds;
  }

  GetRoutesResult.fromJson(dynamic json) {
    _id = json["id"];
    _path = json["path"];
    _distance = json["distance"];
    _duration = json["duration"];
    _bounds = json["bounds"] != null ? Bound.fromJson(json["bounds"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["path"] = _path;
    map["distance"] = _distance;
    map["duration"] = _duration;
    if (_bounds != null) {
      map["bounds"] = _bounds?.toJson();
    }
    return map;
  }


}
