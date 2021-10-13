/// carId : "string"
/// from : "string"
/// leaveAt : "string"
/// routeId : "string"
/// to : "string"

class CreateTripDto {
  String? _carId;
  String? _from;
  String? _leaveAt;
  String? _routeId;
  String? _to;

  String? get carId => _carId;
  String? get from => _from;
  String? get leaveAt => _leaveAt;
  String? get routeId => _routeId;
  String? get to => _to;

  CreateTripDto({
      String? carId, 
      String? from, 
      String? leaveAt, 
      String? routeId, 
      String? to}){
    _carId = carId;
    _from = from;
    _leaveAt = leaveAt;
    _routeId = routeId;
    _to = to;
}

  CreateTripDto.fromJson(dynamic json) {
    _carId = json["carId"];
    _from = json["from"];
    _leaveAt = json["leaveAt"];
    _routeId = json["routeId"];
    _to = json["to"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["carId"] = _carId;
    map["from"] = _from;
    map["leaveAt"] = _leaveAt;
    map["routeId"] = _routeId;
    map["to"] = _to;
    return map;
  }

  set to(String? value) {
    _to = value;
  }

  set routeId(String? value) {
    _routeId = value;
  }

  set leaveAt(String? value) {
    _leaveAt = value;
  }

  set from(String? value) {
    _from = value;
  }

  set carId(String? value) {
    _carId = value;
  }
}