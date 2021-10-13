/// lat : 37.421896207679715
/// lng : -122.08310365676881

class Point {
  double? _lat;
  double? _lng;

  double? get lat => _lat;
  double? get lng => _lng;

  Point({
      double? lat, 
      double? lng}){
    _lat = lat;
    _lng = lng;
}

  Point.fromJson(dynamic json) {
    _lat = json["lat"];
    _lng = json["lng"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["lat"] = _lat;
    map["lng"] = _lng;
    return map;
  }

}