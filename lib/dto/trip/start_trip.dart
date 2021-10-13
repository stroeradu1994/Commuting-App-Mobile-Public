/// tripId : "string"

class StartTrip {
  String? _tripId;

  String? get tripId => _tripId;

  StartTrip({String? tripId}) {
    _tripId = tripId;
  }

  StartTrip.fromJson(dynamic json) {
    _tripId = json["tripId"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["tripId"] = _tripId;
    return map;
  }
}
