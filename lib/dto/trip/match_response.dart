/// matchId : "402880007aee307b017aee6086410007"
/// driverId : "402880007aee1b1c017aee2158690000"
/// driverName : "null null"
/// tripId : "402880007aee1b1c017aee25f8ee002e"
/// carBrand : "Dacia"
/// carModel : "Dokker"
/// carColor : "White"
/// rating : 0.0
/// polyline : "}|anGowp~CLADGxBMOMa@OKDE?_@IUKIGg@Wa@hAOf@a@~@Cf@YFgChAUJOJkHlAyAPCCM@]LOFKx@Kl@}@bFo@pDK|@Cr@A`@]`Fe@tGKlAOj@uD|IyBpFcCtG{@`CGZq@bGk@dFiAfKA~@NtABpCFpU?~EDbL?bLHnBV|CPjAjBnIj@fCjA|EbC|Kj@jCRxALt@AJCd@GhAgDKqBAqAAEBE@{A@}GCiBAkBKiBEqAF_BTeDJo@Hg@Ne@F_AF_FHuELsGz@eAN]JUN_APwAXo@NyAZa@RAACAMCOFIPAJg@RoBbAy@^{EtBoKnEeQ~GwFrB}LxEaBt@ULACEEEEMCM@KHIPCP?RJ^JJFBP\\PGLMHQFU@Kb@Hz@N"
/// pickupWalkingDistance : 17.42376104883069
/// dropWalkingDistance : 3.563450322728182
/// pickupPoint : "Point(lat=44.415659299363064, lng=26.141521528662423)"
/// dropPoint : "Point(lat=44.44615044117647, lng=26.09648011029412)"
/// leaveTime : "2021-07-28T21:24:38.917396"
/// arriveTime : "2021-07-28T21:44:06.917396"
/// pickupTime : "2021-07-28T21:24:55.917396"
/// dropTime : "2021-07-28T21:44:03.917396"

class MatchResponse {
  String? _matchId;
  String? _driverId;
  String? _driverName;
  String? _tripId;
  String? _carBrand;
  String? _carModel;
  String? _carColor;
  double? _rating;
  String? _polyline;
  double? _pickupWalkingDistance;
  double? _dropWalkingDistance;
  String? _pickupPoint;
  String? _dropPoint;
  String? _leaveTime;
  String? _arriveTime;
  String? _pickupTime;
  String? _dropTime;

  String? get matchId => _matchId;
  String? get driverId => _driverId;
  String? get driverName => _driverName;
  String? get tripId => _tripId;
  String? get carBrand => _carBrand;
  String? get carModel => _carModel;
  String? get carColor => _carColor;
  double? get rating => _rating;
  String? get polyline => _polyline;
  double? get pickupWalkingDistance => _pickupWalkingDistance;
  double? get dropWalkingDistance => _dropWalkingDistance;
  String? get pickupPoint => _pickupPoint;
  String? get dropPoint => _dropPoint;
  String? get leaveTime => _leaveTime;
  String? get arriveTime => _arriveTime;
  String? get pickupTime => _pickupTime;
  String? get dropTime => _dropTime;

  MatchResponse({
      String? matchId, 
      String? driverId, 
      String? driverName, 
      String? tripId, 
      String? carBrand, 
      String? carModel, 
      String? carColor, 
      double? rating, 
      String? polyline, 
      double? pickupWalkingDistance, 
      double? dropWalkingDistance, 
      String? pickupPoint, 
      String? dropPoint, 
      String? leaveTime, 
      String? arriveTime, 
      String? pickupTime, 
      String? dropTime}){
    _matchId = matchId;
    _driverId = driverId;
    _driverName = driverName;
    _tripId = tripId;
    _carBrand = carBrand;
    _carModel = carModel;
    _carColor = carColor;
    _rating = rating;
    _polyline = polyline;
    _pickupWalkingDistance = pickupWalkingDistance;
    _dropWalkingDistance = dropWalkingDistance;
    _pickupPoint = pickupPoint;
    _dropPoint = dropPoint;
    _leaveTime = leaveTime;
    _arriveTime = arriveTime;
    _pickupTime = pickupTime;
    _dropTime = dropTime;
}

  MatchResponse.fromJson(dynamic json) {
    _matchId = json["matchId"];
    _driverId = json["driverId"];
    _driverName = json["driverName"];
    _tripId = json["tripId"];
    _carBrand = json["carBrand"];
    _carModel = json["carModel"];
    _carColor = json["carColor"];
    _rating = json["rating"];
    _polyline = json["polyline"];
    _pickupWalkingDistance = json["pickupWalkingDistance"];
    _dropWalkingDistance = json["dropWalkingDistance"];
    _pickupPoint = json["pickupPoint"];
    _dropPoint = json["dropPoint"];
    _leaveTime = json["leaveTime"];
    _arriveTime = json["arriveTime"];
    _pickupTime = json["pickupTime"];
    _dropTime = json["dropTime"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["matchId"] = _matchId;
    map["driverId"] = _driverId;
    map["driverName"] = _driverName;
    map["tripId"] = _tripId;
    map["carBrand"] = _carBrand;
    map["carModel"] = _carModel;
    map["carColor"] = _carColor;
    map["rating"] = _rating;
    map["polyline"] = _polyline;
    map["pickupWalkingDistance"] = _pickupWalkingDistance;
    map["dropWalkingDistance"] = _dropWalkingDistance;
    map["pickupPoint"] = _pickupPoint;
    map["dropPoint"] = _dropPoint;
    map["leaveTime"] = _leaveTime;
    map["arriveTime"] = _arriveTime;
    map["pickupTime"] = _pickupTime;
    map["dropTime"] = _dropTime;
    return map;
  }

}