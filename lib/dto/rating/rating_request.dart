/// tripId : ""
/// rate : 1

class RatingRequest {
  String? _tripId;
  int? _rate;

  String? get tripId => _tripId;
  int? get rate => _rate;

  RatingRequest({
      String? tripId, 
      int? rate}){
    _tripId = tripId;
    _rate = rate;
}

  RatingRequest.fromJson(dynamic json) {
    _tripId = json['tripId'];
    _rate = json['rate'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['tripId'] = _tripId;
    map['rate'] = _rate;
    return map;
  }

}