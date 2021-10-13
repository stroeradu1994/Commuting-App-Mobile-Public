/// tripId : ""
/// stopId : ""

class CompleteTripRequest {
  String? _tripId;

  String? get tripId => _tripId;

  CompleteTripRequest({
      String? tripId}){
    _tripId = tripId;
}

  CompleteTripRequest.fromJson(dynamic json) {
    _tripId = json['tripId'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['tripId'] = _tripId;
    return map;
  }

}