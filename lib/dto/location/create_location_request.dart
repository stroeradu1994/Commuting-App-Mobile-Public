/// address : "string"
/// label : "string"
/// lat : 0
/// lng : 0

class CreateLocationRequest {
  String? _address;
  String? _label;
  double? _lat;
  double? _lng;

  String? get address => _address;
  String? get label => _label;
  double? get lat => _lat;
  double? get lng => _lng;

  CreateLocationRequest({
      String? address, 
      String? label, 
      double? lat, 
      double? lng}){
    _address = address;
    _label = label;
    _lat = lat;
    _lng = lng;
}

  CreateLocationRequest.fromJson(dynamic json) {
    _address = json["address"];
    _label = json["label"];
    _lat = json["lat"];
    _lng = json["lng"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["address"] = _address;
    map["label"] = _label;
    map["lat"] = _lat;
    map["lng"] = _lng;
    return map;
  }

}