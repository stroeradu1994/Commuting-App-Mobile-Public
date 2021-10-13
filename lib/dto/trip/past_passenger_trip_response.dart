import 'package:commuting_app_mobile/dto/location/location_response.dart';

/// tripId : "402880007afcd26b017afcd2d0fd0010"
/// driverId : "402880007afcc4a1017afccf8e4d0000"
/// driverName : "null null"
/// driverRating : 0.0
/// carBrand : "Dacia"
/// carModel : "Dokker"
/// carColor : "White"
/// carPlate : "23425"
/// fromLocation : {"id":"402880007afcc4a1017afcd0bfa20002","label":"Home","address":"Strada Râmnicu Vâlcea 19, București, Romania","point":{"lat":44.4156433,"lng":26.141303300000004}}
/// toLocation : {"id":"402880007afcc4a1017afcd1434c0003","label":"Work","address":"Strada Ion Luca Caragiale 12, București, Romania","point":{"lat":44.44046012462835,"lng":26.106228679418564}}
/// riding : false
/// pickupWalkingDistance : 17.42376104883069
/// dropWalkingDistance : 1.194372378864281
/// pickupPoint : "44.415659299363064, 26.141521528662423"
/// dropPoint : "44.44045413043479, 26.106216195652173"
/// leaveTime : "2021-07-31T17:46:36.901352"
/// arriveTime : "2021-07-31T18:04:41.901352"
/// pickupTime : "2021-07-31T17:46:53.901352"
/// dropTime : "2021-07-31T18:04:40.901352"
/// polyline : "}|anGowp~CLADGxBMOMa@OKDE?_@IUKIGg@Wa@hAOf@a@~@Cf@YFgChAUJOJkHlAyAPCCM@]LOFKx@Kl@}@bFo@pDK|@Cr@A`@]`Fe@tGKlAOj@uD|IyBpFcCtG{@`CGZq@bGk@dFiAfKA~@NtABpCFpU?~EIZOvHChBDr@?ZMl@I`DDTZfADVP~CJzACLIRGHYN}Ke@eBEeBIcAG_A?[Nu@TuErA{A^q@B[?cAIyCWsBG]Eq@EIEQa@KSMGSEUGgAAq@A{AO]LgDjB{EdCaAf@kCtAsCjBaBv@_@P}B\\k@LsCjAg@VQBWC{@c@]rCI|@GtB@fCJ`B?PjAeA"

class PastPassengerTripResponse {
  String? _tripId;
  String? _driverId;
  String? _driverName;
  double? _driverRating;
  String? _carBrand;
  String? _carModel;
  String? _carColor;
  String? _carPlate;
  LocationResponse? _fromLocation;
  LocationResponse? _toLocation;
  bool? _pickedUp;
  bool? _dropped;
  bool? _arrivedAtPickup;
  double? _pickupWalkingDistance;
  double? _dropWalkingDistance;
  double? _tripDistance;
  String? _pickupPoint;
  String? _dropPoint;
  String? _pickupAddress;
  String? _dropAddress;
  String? _leaveTime;
  String? _arriveTime;
  String? _pickupTime;
  String? _dropTime;
  String? _polyline;
  int? _rating;

  String? get tripId => _tripId;

  String? get driverId => _driverId;

  String? get driverName => _driverName;

  double? get driverRating => _driverRating;

  String? get carBrand => _carBrand;

  String? get carModel => _carModel;

  String? get carColor => _carColor;

  String? get carPlate => _carPlate;

  LocationResponse? get fromLocation => _fromLocation;

  LocationResponse? get toLocation => _toLocation;

  bool? get pickedUp => _pickedUp;

  bool? get dropped => _dropped;

  bool? get arrivedAtPickup => _arrivedAtPickup;

  double? get pickupWalkingDistance => _pickupWalkingDistance;

  double? get dropWalkingDistance => _dropWalkingDistance;

  double? get tripDistance => _tripDistance;

  String? get pickupPoint => _pickupPoint;

  String? get dropPoint => _dropPoint;

  String? get pickupAddress => _pickupAddress;

  String? get dropAddress => _dropAddress;

  String? get leaveTime => _leaveTime;

  String? get arriveTime => _arriveTime;

  String? get pickupTime => _pickupTime;

  String? get dropTime => _dropTime;

  String? get polyline => _polyline;
  
  int? get rating => _rating;

  PastPassengerTripResponse(
      {String? tripId,
      String? driverId,
      String? driverName,
      double? driverRating,
      String? carBrand,
      String? carModel,
      String? carColor,
      String? carPlate,
      LocationResponse? fromLocation,
      LocationResponse? toLocation,
      bool? pickedUp,
      bool? dropped,
      bool? arrivedAtPickup,
      double? pickupWalkingDistance,
      double? dropWalkingDistance,
      double? tripDistance,
      String? pickupPoint,
      String? dropPoint,
      String? pickupAddress,
      String? dropAddress,
      String? leaveTime,
      String? arriveTime,
      String? pickupTime,
      String? dropTime,
      int? rating,
      String? polyline}) {
    _tripId = tripId;
    _driverId = driverId;
    _driverName = driverName;
    _driverRating = driverRating;
    _carBrand = carBrand;
    _carModel = carModel;
    _carColor = carColor;
    _carPlate = carPlate;
    _fromLocation = fromLocation;
    _toLocation = toLocation;
    _pickedUp = pickedUp;
    _dropped = dropped;
    _arrivedAtPickup = arrivedAtPickup;
    _pickupWalkingDistance = pickupWalkingDistance;
    _dropWalkingDistance = dropWalkingDistance;
    _tripDistance = tripDistance;
    _pickupPoint = pickupPoint;
    _dropPoint = dropPoint;
    _pickupAddress = pickupAddress;
    _dropAddress = dropAddress;
    _leaveTime = leaveTime;
    _arriveTime = arriveTime;
    _pickupTime = pickupTime;
    _dropTime = dropTime;
    _rating = rating;
    _polyline = polyline;
  }

  PastPassengerTripResponse.fromJson(dynamic json) {
    _tripId = json["tripId"];
    _driverId = json["driverId"];
    _driverName = json["driverName"];
    _driverRating = json["driverRating"];
    _carBrand = json["carBrand"];
    _carModel = json["carModel"];
    _carColor = json["carColor"];
    _carPlate = json["carPlate"];
    _fromLocation = json["fromLocation"] != null
        ? LocationResponse.fromJson(json["fromLocation"])
        : null;
    _toLocation = json["toLocation"] != null
        ? LocationResponse.fromJson(json["toLocation"])
        : null;
    _pickedUp = json["pickedUp"];
    _dropped = json["dropped"];
    _arrivedAtPickup = json["arrivedAtPickup"];
    _pickupWalkingDistance = json["pickupWalkingDistance"];
    _dropWalkingDistance = json["dropWalkingDistance"];
    _tripDistance = json["tripDistance"];
    _pickupPoint = json["pickupPoint"];
    _dropPoint = json["dropPoint"];
    _pickupAddress = json["pickupAddress"];
    _dropAddress = json["dropAddress"];
    _leaveTime = json["leaveTime"];
    _arriveTime = json["arriveTime"];
    _pickupTime = json["pickupTime"];
    _dropTime = json["dropTime"];
    _rating = json["rating"];
    _polyline = json["polyline"];
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
    map["carPlate"] = _carPlate;
    if (_fromLocation != null) {
      map["fromLocation"] = _fromLocation?.toJson();
    }
    if (_toLocation != null) {
      map["toLocation"] = _toLocation?.toJson();
    }
    map["pickedUp"] = _pickedUp;
    map["dropped"] = _dropped;
    map["arrivedAtPickup"] = _arrivedAtPickup;
    map["pickupWalkingDistance"] = _pickupWalkingDistance;
    map["dropWalkingDistance"] = _dropWalkingDistance;
    map["tripDistance"] = _tripDistance;
    map["pickupPoint"] = _pickupPoint;
    map["dropPoint"] = _dropPoint;
    map["pickupAddress"] = _pickupAddress;
    map["dropAddress"] = _dropAddress;
    map["leaveTime"] = _leaveTime;
    map["arriveTime"] = _arriveTime;
    map["pickupTime"] = _pickupTime;
    map["dropTime"] = _dropTime;
    map["rating"] = _rating;
    map["polyline"] = _polyline;
    return map;
  }
}
