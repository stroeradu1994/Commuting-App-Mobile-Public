/// tripId : "string"
/// leaveAt : "string"

class ConfirmTrip {
  String? _tripId;
  String? _leaveAt;

  String? get tripId => _tripId;
  String? get leaveAt => _leaveAt;

  ConfirmTrip({
      String? tripId, 
      String? leaveAt}){
    _tripId = tripId;
    _leaveAt = leaveAt;
}

  ConfirmTrip.fromJson(dynamic json) {
    _tripId = json["tripId"];
    _leaveAt = json["leaveAt"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["tripId"] = _tripId;
    map["leaveAt"] = _leaveAt;
    return map;
  }

}