/// tripId : ""
/// stopId : ""

class TripActionRequest {
  String? _tripId;
  String? _stopId;

  String? get tripId => _tripId;
  String? get stopId => _stopId;

  TripActionRequest({
      String? tripId, 
      String? stopId}){
    _tripId = tripId;
    _stopId = stopId;
}

  TripActionRequest.fromJson(dynamic json) {
    _tripId = json['tripId'];
    _stopId = json['stopId'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['tripId'] = _tripId;
    map['stopId'] = _stopId;
    return map;
  }

}