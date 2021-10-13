/// arriveBy : "string"
/// asap : true
/// from : "string"
/// to : "string"

class CreateTripRequestDto {
  String? _arriveBy;
  bool? _asap;
  String? _from;
  String? _to;

  String? get arriveBy => _arriveBy;
  bool? get asap => _asap;
  String? get from => _from;
  String? get to => _to;

  CreateTripRequestDto({
      String? arriveBy, 
      bool? asap, 
      String? from, 
      String? to}){
    _arriveBy = arriveBy;
    _asap = asap;
    _from = from;
    _to = to;
}

  CreateTripRequestDto.fromJson(dynamic json) {
    _arriveBy = json["arriveBy"];
    _asap = json["asap"];
    _from = json["from"];
    _to = json["to"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["arriveBy"] = _arriveBy;
    map["asap"] = _asap;
    map["from"] = _from;
    map["to"] = _to;
    return map;
  }

  set to(String? value) {
    _to = value;
  }

  set from(String? value) {
    _from = value;
  }

  set asap(bool? value) {
    _asap = value;
  }

  set arriveBy(String? value) {
    _arriveBy = value;
  }
}