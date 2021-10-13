import 'package:commuting_app_mobile/dto/direction/point.dart';
import 'package:commuting_app_mobile/dto/location/location_response.dart';

/// northeast : ""
/// southwest : ""

class Bound {
  Point? _northeast;
  Point? _southwest;

  Point? get northeast => _northeast;
  Point? get southwest => _southwest;

  Bound({
      Point? northeast, 
      Point? southwest}){
    _northeast = northeast;
    _southwest = southwest;
}

  Bound.fromJson(dynamic json) {
    _northeast = json["northeast"] != null ? Point.fromJson(json["northeast"]) : null;
    _southwest = json["southwest"] != null ? Point.fromJson(json["southwest"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_northeast != null) {
      map["northeast"] = _northeast?.toJson();
    }
    if (_southwest != null) {
      map["southwest"] = _southwest?.toJson();
    }
    return map;
  }

}