import 'dart:ffi';

/// id : "123"
/// label : "Home"
/// address : "Iuliu Maniu"
/// type : 1

class LocationDto {
  String _id;
  String _label;
  String _address;
  double _lat;
  double _lng;

  String get id => _id;

  String get label => _label;

  String get address => _address;

  double get lat => _lat;

  double get lng => _lng;

  set id(String value) {
    _id = value;
  }

  LocationDto(String id, String label, String address, double lat, double lng)
      : _id = id,
        _label = label,
        _address = address,
        _lat = lat,
        _lng = lng {}

  LocationDto.fromJson(dynamic json)
      : _id = json["id"],
        _label = json["label"],
        _address = json["address"],
        _lat = json["lat"],
        _lng = json["lng"] {}

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["label"] = _label;
    map["address"] = _address;
    map["lat"] = _lat;
    map["lng"] = _lng;
    return map;
  }

  set label(String value) {
    _label = value;
  }

  set address(String value) {
    _address = value;
  }

  set lng(double value) {
    _lng = value;
  }

  set lat(double value) {
    _lat = value;
  }
}
