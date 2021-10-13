import 'package:commuting_app_mobile/dto/location/location_response.dart';

/// tripId : "402880007aee1b1c017aee2269480015"
/// driverId : "402880007aee1b1c017aee2158690000"
/// driverName : "null null"
/// driverRating : 0.0
/// carBrand : "Dacia"
/// carModel : "Dokker"
/// carColor : "White"
/// fromLocation : {"id":"402880007aee1b1c017aee21dca10002","label":"Home","address":"Strada Râmnicu Vâlcea 19, București, Romania","point":{"lat":44.4156433,"lng":26.141303300000004}}
/// toLocation : {"id":"402880007aee1b1c017aee2211ae0003","label":"Work","address":"Strada D. I. Mendeleev 41, București, Romania","point":{"lat":44.446156131550794,"lng":26.09643593430519}}
/// pickupWalkingDistance : 17.42376104883069
/// dropWalkingDistance : 3.563450322728182
/// pickupPoint : "44.415659299363064, 26.141521528662423"
/// dropPoint : "44.44615044117647, 26.09648011029412"
/// leaveTime : "2021-07-28T22:29:43"
/// arriveTime : "2021-07-28T22:49:11"
/// pickupTime : "2021-07-28T22:30"
/// dropTime : "2021-07-28T22:49:08"
/// polyline : "}|anGowp~CLADGxBMOMa@OKDE?_@IUKIGg@Wa@hAOf@a@~@Cf@YFgChAUJOJkHlAyAPCCM@]LOFKx@Kl@}@bFo@pDK|@Cr@A`@]`Fe@tGKlAOj@uD|IyBpFcCtG{@`CGZq@bGk@dFiAfKA~@NtABpCFpU?~EDbL?bLHnBV|CPjAjBnIj@fCjA|EbC|Kj@jCRxALt@AJCd@GhAgDKqBAqAAEBE@{A@}GCiBAkBKiBEqAF_BTeDJo@Hg@Ne@F_AF_FHuELsGz@eAN]JUN_APwAXo@NyAZa@RAACAMCOFIPAJg@RoBbAy@^{EtBoKnEeQ~GwFrB}LxEaBt@ULACEEEEMCM@KHIPCP?RJ^JJFBP\\PGLMHQFU@Kb@Hz@N"

class UpcomingPassengerTripResponse {
  String? _tripId;
  String? _driverId;
  String? _driverName;
  double? _driverRating;
  String? _carBrand;
  String? _carModel;
  String? _carColor;
  LocationResponse? _fromLocation;
  LocationResponse? _toLocation;
  double? _pickupWalkingDistance;
  double? _dropWalkingDistance;
  String? _pickupPoint;
  String? _dropPoint;
  String? _leaveTime;
  String? _arriveTime;
  String? _pickupTime;
  String? _dropTime;
  String? _polyline;
  bool? _confirmed;

  String? get tripId => _tripId;
  String? get driverId => _driverId;
  String? get driverName => _driverName;
  double? get driverRating => _driverRating;
  String? get carBrand => _carBrand;
  String? get carModel => _carModel;
  String? get carColor => _carColor;
  LocationResponse? get fromLocation => _fromLocation;
  LocationResponse? get toLocation => _toLocation;
  double? get pickupWalkingDistance => _pickupWalkingDistance;
  double? get dropWalkingDistance => _dropWalkingDistance;
  String? get pickupPoint => _pickupPoint;
  String? get dropPoint => _dropPoint;
  String? get leaveTime => _leaveTime;
  String? get arriveTime => _arriveTime;
  String? get pickupTime => _pickupTime;
  String? get dropTime => _dropTime;
  String? get polyline => _polyline;
  bool? get confirmed => _confirmed;

  UpcomingPassengerTripResponse({
      String? tripId, 
      String? driverId, 
      String? driverName, 
      double? driverRating, 
      String? carBrand, 
      String? carModel, 
      String? carColor, 
      LocationResponse? fromLocation, 
      LocationResponse? toLocation, 
      double? pickupWalkingDistance, 
      double? dropWalkingDistance, 
      String? pickupPoint, 
      String? dropPoint, 
      String? leaveTime, 
      String? arriveTime, 
      String? pickupTime, 
      String? dropTime, 
      String? polyline,
      bool? confirmed}){
    _tripId = tripId;
    _driverId = driverId;
    _driverName = driverName;
    _driverRating = driverRating;
    _carBrand = carBrand;
    _carModel = carModel;
    _carColor = carColor;
    _fromLocation = fromLocation;
    _toLocation = toLocation;
    _pickupWalkingDistance = pickupWalkingDistance;
    _dropWalkingDistance = dropWalkingDistance;
    _pickupPoint = pickupPoint;
    _dropPoint = dropPoint;
    _leaveTime = leaveTime;
    _arriveTime = arriveTime;
    _pickupTime = pickupTime;
    _dropTime = dropTime;
    _polyline = polyline;
    _confirmed = confirmed;
}

  UpcomingPassengerTripResponse.fromJson(dynamic json) {
    _tripId = json["tripId"];
    _driverId = json["driverId"];
    _driverName = json["driverName"];
    _driverRating = json["driverRating"];
    _carBrand = json["carBrand"];
    _carModel = json["carModel"];
    _carColor = json["carColor"];
    _fromLocation = json["fromLocation"] != null ? LocationResponse.fromJson(json["fromLocation"]) : null;
    _toLocation = json["toLocation"] != null ? LocationResponse.fromJson(json["toLocation"]) : null;
    _pickupWalkingDistance = json["pickupWalkingDistance"];
    _dropWalkingDistance = json["dropWalkingDistance"];
    _pickupPoint = json["pickupPoint"];
    _dropPoint = json["dropPoint"];
    _leaveTime = json["leaveTime"];
    _arriveTime = json["arriveTime"];
    _pickupTime = json["pickupTime"];
    _dropTime = json["dropTime"];
    _polyline = json["polyline"];
    _confirmed = json["confirmed"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["tripId"] = _tripId;
    map["driverId"] = _driverId;
    map["driverName"] = _driverName;
    map["driverRating"] = _driverRating;
    map["carBrand"] = _carBrand;
    map["carModel"] = _carModel;
    map["carColor"] = _carColor;
    if (_fromLocation != null) {
      map["fromLocation"] = _fromLocation?.toJson();
    }
    if (_toLocation != null) {
      map["toLocation"] = _toLocation?.toJson();
    }
    map["pickupWalkingDistance"] = _pickupWalkingDistance;
    map["dropWalkingDistance"] = _dropWalkingDistance;
    map["pickupPoint"] = _pickupPoint;
    map["dropPoint"] = _dropPoint;
    map["leaveTime"] = _leaveTime;
    map["arriveTime"] = _arriveTime;
    map["pickupTime"] = _pickupTime;
    map["dropTime"] = _dropTime;
    map["polyline"] = _polyline;
    map["confirmed"] = _confirmed;
    return map;
  }

}
