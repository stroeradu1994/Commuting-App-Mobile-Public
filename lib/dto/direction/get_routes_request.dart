import 'package:commuting_app_mobile/dto/direction/point.dart';
import 'package:commuting_app_mobile/dto/location/location_response.dart';

/// from : {"lat":0,"lng":0}
/// leaveAt : "string"
/// to : {"lat":0,"lng":0}

class GetRoutesRequest {
  Point? _from;
  String? _leaveAt;
  Point? _to;

  Point? get from => _from;
  String? get leaveAt => _leaveAt;
  Point? get to => _to;

  GetRoutesRequest({
    Point? from,
      String? leaveAt,
    Point? to}){
    _from = from;
    _leaveAt = leaveAt;
    _to = to;
}

  GetRoutesRequest.fromJson(dynamic json) {
    _from = json["from"] != null ? Point.fromJson(json["from"]) : null;
    _leaveAt = json["leaveAt"];
    _to = json["to"] != null ? Point.fromJson(json["to"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_from != null) {
      map["from"] = _from?.toJson();
    }
    map["leaveAt"] = _leaveAt;
    if (_to != null) {
      map["to"] = _to?.toJson();
    }
    return map;
  }

}
