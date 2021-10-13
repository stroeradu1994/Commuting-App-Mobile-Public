/// dateTime : ""
/// driver : "false"
/// asap : "false"

class TripAvailabilityRequest {
  String? _dateTime;
  bool? _driver;
  bool? _asap;

  String? get dateTime => _dateTime;
  bool? get driver => _driver;
  bool? get asap => _asap;

  TripAvailabilityRequest({
      String? dateTime, 
      bool? driver,
    bool? asap}){
    _dateTime = dateTime;
    _driver = driver;
    _asap = asap;
}

  TripAvailabilityRequest.fromJson(dynamic json) {
    _dateTime = json['dateTime'];
    _driver = json['driver'];
    _asap = json['asap'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['dateTime'] = _dateTime;
    map['driver'] = _driver;
    map['asap'] = _asap;
    return map;
  }

}