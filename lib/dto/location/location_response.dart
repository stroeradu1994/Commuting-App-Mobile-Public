import 'package:commuting_app_mobile/dto/direction/point.dart';

/// id : "402880007abb049b017abb4044640002"
/// label : "Home"
/// address : "1598 Amphitheatre Pkwy, California, United States"
/// point : {"lat":37.421896207679715,"lng":-122.08310365676881}

class LocationResponse {
  String? _id;
  String? _label;
  String? _address;
  Point? _point;

  String? get id => _id;
  String? get label => _label;
  String? get address => _address;
  Point? get point => _point;

  LocationResponse({
      String? id, 
      String? label, 
      String? address, 
      Point? point}){
    _id = id;
    _label = label;
    _address = address;
    _point = point;
}

  LocationResponse.fromJson(dynamic json) {
    _id = json["id"];
    _label = json["label"];
    _address = json["address"];
    _point = json["point"] != null ? Point.fromJson(json["point"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["label"] = _label;
    map["address"] = _address;
    if (_point != null) {
      map["point"] = _point?.toJson();
    }
    return map;
  }

}
