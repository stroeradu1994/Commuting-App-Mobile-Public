import 'package:commuting_app_mobile/dto/location/location_response.dart';

/// tripId : "402880007aee1b1c017aee2269480015"
/// carBrand : "Dacia"
/// carModel : "Dokker"
/// carColor : "White"
/// fromLocation : {"id":"402880007aee1b1c017aee21dca10002","label":"Home","address":"Strada Râmnicu Vâlcea 19, București, Romania","point":{"lat":44.4156433,"lng":26.141303300000004}}
/// toLocation : {"id":"402880007aee1b1c017aee2211ae0003","label":"Work","address":"Strada D. I. Mendeleev 41, București, Romania","point":{"lat":44.446156131550794,"lng":26.09643593430519}}
/// leaveTime : "2021-07-28T22:30"
/// arriveTime : "2021-07-28T22:45:53"
/// polyline : "}|anGowp~CLADGxBMOMa@OKDE?_@IUKIGg@Wa@hAOf@a@~@Cf@YFgChAUJOJkHlAyAPCCM@]LOFKx@Kl@}@bFo@pDK|@Cr@A`@]`Fe@tGKlAOj@uD|IyBpFcCtG{@`CGZq@bGk@dFiAfKA~@NtABpCFpU?~EDbL?bLHnBV|CPjAjBnIj@fCjA|EbC|Kj@jCRxALt@AJCd@GhAgDKqBAqAAEBE@{A@}GCiBAkBKiBEqAF_BTeDJo@Hg@Ne@F_AF_FHuELsGz@eAN]JUN_APwAXo@NyAZa@RAACAMCOFIPAJg@RoBbAy@^{EtBoKnEeQ~GwFrB}LxEaBt@ULACEEEEMCM@KHIPCP?RJ^JJFBP\\PGLMHQFU@Kb@Hz@N"
/// passengers : [{"passengerId":null,"firstName":null,"lastName":null,"pickupPoint":"44.415659299363064, 26.141521528662423","dropPoint":"44.44615044117647, 26.09648011029412","rating":0.0}]

class UpcomingDriverTripResponse {
  String? _tripId;
  String? _carBrand;
  String? _carModel;
  String? _carColor;
  String? _carPlate;
  LocationResponse? _fromLocation;
  LocationResponse? _toLocation;
  String? _leaveTime;
  String? _arriveTime;
  String? _polyline;
  List<Passengers>? _passengers;
  bool? _confirmed;

  String? get tripId => _tripId;

  String? get carBrand => _carBrand;

  String? get carModel => _carModel;

  String? get carColor => _carColor;

  String? get carPlate => _carPlate;

  LocationResponse? get fromLocation => _fromLocation;

  LocationResponse? get toLocation => _toLocation;

  String? get leaveTime => _leaveTime;

  String? get arriveTime => _arriveTime;

  String? get polyline => _polyline;

  List<Passengers>? get passengers => _passengers;

  bool? get confirmed => _confirmed;

  UpcomingDriverTripResponse(
      {String? tripId,
      String? carBrand,
      String? carModel,
      String? carColor,
      String? carPlate,
      LocationResponse? fromLocation,
      LocationResponse? toLocation,
      String? leaveTime,
      String? arriveTime,
      String? polyline,
      List<Passengers>? passengers,
      bool? confirmed}) {
    _tripId = tripId;
    _carBrand = carBrand;
    _carModel = carModel;
    _carColor = carColor;
    _carPlate = carPlate;
    _fromLocation = fromLocation;
    _toLocation = toLocation;
    _leaveTime = leaveTime;
    _arriveTime = arriveTime;
    _polyline = polyline;
    _passengers = passengers;
    _confirmed = confirmed;
  }

  UpcomingDriverTripResponse.fromJson(dynamic json) {
    _tripId = json["tripId"];
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
    _leaveTime = json["leaveTime"];
    _arriveTime = json["arriveTime"];
    _polyline = json["polyline"];
    if (json["passengers"] != null) {
      _passengers = [];
      json["passengers"].forEach((v) {
        _passengers?.add(Passengers.fromJson(v));
      });
    }
    _confirmed = json["confirmed"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["tripId"] = _tripId;
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
    map["leaveTime"] = _leaveTime;
    map["arriveTime"] = _arriveTime;
    map["polyline"] = _polyline;
    if (_passengers != null) {
      map["passengers"] = _passengers?.map((v) => v.toJson()).toList();
    }
    map["confirmed"] = _confirmed;

    return map;
  }
}

/// passengerId : null
/// firstName : null
/// lastName : null
/// pickupPoint : "44.415659299363064, 26.141521528662423"
/// dropPoint : "44.44615044117647, 26.09648011029412"
/// rating : 0.0

class Passengers {
  dynamic? _passengerId;
  dynamic? _firstName;
  dynamic? _lastName;
  String? _pickupPoint;
  String? _dropPoint;
  double? _rating;
  String? _pickupTime;
  String? _dropTime;

  dynamic? get passengerId => _passengerId;

  dynamic? get firstName => _firstName;

  dynamic? get lastName => _lastName;

  String? get pickupPoint => _pickupPoint;

  String? get dropPoint => _dropPoint;

  double? get rating => _rating;

  String? get pickupTime => _pickupTime;

  String? get dropTime => _dropTime;

  Passengers(
      {dynamic? passengerId,
      dynamic? firstName,
      dynamic? lastName,
      String? pickupPoint,
      String? dropPoint,
      String? pickupTime,
      String? dropTime,
      double? rating}) {
    _passengerId = passengerId;
    _firstName = firstName;
    _lastName = lastName;
    _pickupPoint = pickupPoint;
    _dropPoint = dropPoint;
    _pickupTime = pickupTime;
    _dropTime = dropTime;
    _rating = rating;
  }

  Passengers.fromJson(dynamic json) {
    _passengerId = json["passengerId"];
    _firstName = json["firstName"];
    _lastName = json["lastName"];
    _pickupPoint = json["pickupPoint"];
    _dropPoint = json["dropPoint"];
    _pickupTime = json["pickupTime"];
    _dropTime = json["dropTime"];
    _rating = json["rating"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["passengerId"] = _passengerId;
    map["firstName"] = _firstName;
    map["lastName"] = _lastName;
    map["pickupPoint"] = _pickupPoint;
    map["dropPoint"] = _dropPoint;
    map["pickupTime"] = _pickupTime;
    map["dropTime"] = _dropTime;
    map["rating"] = _rating;
    return map;
  }
}
