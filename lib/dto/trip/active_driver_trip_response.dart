import 'package:commuting_app_mobile/dto/location/location_response.dart';

/// tripId : "402880007afcd26b017afcd2d0fd0010"
/// carBrand : "Dacia"
/// carModel : "Dokker"
/// carColor : "White"
/// carPlate : "23425"
/// fromLocation : {"id":"402880007afcc4a1017afcd0bfa20002","label":"Home","address":"Strada Râmnicu Vâlcea 19, București, Romania","point":{"lat":44.4156433,"lng":26.141303300000004}}
/// toLocation : {"id":"402880007afcc4a1017afcd1434c0003","label":"Work","address":"Strada Ion Luca Caragiale 12, București, Romania","point":{"lat":44.44046012462835,"lng":26.106228679418564}}
/// leaveTime : "2021-07-31T18:44:02.333966"
/// arriveTime : "2021-07-31T19:00:33.901352"
/// polyline : "}|anGowp~CLADGxBMOMa@OKDE?_@IUKIGg@Wa@hAOf@a@~@Cf@YFgChAUJOJkHlAyAPCCM@]LOFKx@Kl@}@bFo@pDK|@Cr@A`@]`Fe@tGKlAOj@uD|IyBpFcCtG{@`CGZq@bGk@dFiAfKA~@NtABpCFpU?~EIZOvHChBDr@?ZMl@I`DDTZfADVP~CJzACLIRGHYN}Ke@eBEeBIcAG_A?[Nu@TuErA{A^q@B[?cAIyCWsBG]Eq@EIEQa@KSMGSEUGgAAq@A{AO]LgDjB{EdCaAf@kCtAsCjBaBv@_@P}B\\k@LsCjAg@VQBWC{@c@]rCI|@GtB@fCJ`B?PjAeA"
/// passengers : [{"id":"402880007afcc4a1017afccf8e4d0000","firstName":null,"lastName":null,"review":0.0}]
/// stops : [{"point":"44.415659299363064, 26.141521528662423","address":"Strada Râmnicu Vâlcea 19, București, Romania","pickup":true,"time":"2021-07-31T17:46:53.901352","passengerId":"402880007afcc4a1017afccf8e4d0000","confirmed":false},{"point":"44.44045413043479, 26.106216195652173","address":"Strada Ion Luca Caragiale 11, București 030167, Romania","pickup":false,"time":"2021-07-31T18:04:40.901352","passengerId":"402880007afcc4a1017afccf8e4d0000","confirmed":false}]

class ActiveDriverTripResponse {
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
  List<Stops>? _stops;

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
  List<Stops>? get stops => _stops;

  ActiveDriverTripResponse({
      String? tripId, 
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
      List<Stops>? stops}){
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
    _stops = stops;
}

  ActiveDriverTripResponse.fromJson(dynamic json) {
    _tripId = json["tripId"];
    _carBrand = json["carBrand"];
    _carModel = json["carModel"];
    _carColor = json["carColor"];
    _carPlate = json["carPlate"];
    _fromLocation = json["fromLocation"] != null ? LocationResponse.fromJson(json["fromLocation"]) : null;
    _toLocation = json["toLocation"] != null ? LocationResponse.fromJson(json["toLocation"]) : null;
    _leaveTime = json["leaveTime"];
    _arriveTime = json["arriveTime"];
    _polyline = json["polyline"];
    if (json["passengers"] != null) {
      _passengers = [];
      json["passengers"].forEach((v) {
        _passengers?.add(Passengers.fromJson(v));
      });
    }
    if (json["stops"] != null) {
      _stops = [];
      json["stops"].forEach((v) {
        _stops?.add(Stops.fromJson(v));
      });
    }
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
    if (_stops != null) {
      map["stops"] = _stops?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// point : "44.415659299363064, 26.141521528662423"
/// address : "Strada Râmnicu Vâlcea 19, București, Romania"
/// pickup : true
/// time : "2021-07-31T17:46:53.901352"
/// passengerId : "402880007afcc4a1017afccf8e4d0000"
/// confirmed : false

class Stops {
  String? _id;
  String? _point;
  String? _address;
  bool? _pickup;
  bool? _arrived;
  String? _time;
  String? _passengerId;
  String? _passengerName;
  bool? _confirmed;

  String? get id => _id;
  String? get point => _point;
  String? get address => _address;
  bool? get pickup => _pickup;
  bool? get arrived => _arrived;
  String? get time => _time;
  String? get passengerId => _passengerId;
  String? get passengerName => _passengerName;
  bool? get confirmed => _confirmed;

  Stops({
      String? id,
      String? point,
      String? address,
      bool? pickup, 
      bool? arrived,
      String? time,
      String? passengerId, 
      String? passengerName,
      bool? confirmed}){
    _id = id;
    _point = point;
    _address = address;
    _arrived = arrived;
    _pickup = pickup;
    _time = time;
    _passengerId = passengerId;
    _passengerName = passengerName;
    _confirmed = confirmed;
}

  Stops.fromJson(dynamic json) {
    _id = json["id"];
    _point = json["point"];
    _address = json["address"];
    _pickup = json["pickup"];
    _arrived = json["arrived"];
    _time = json["time"];
    _passengerId = json["passengerId"];
    _passengerName = json["passengerName"];
    _confirmed = json["confirmed"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["point"] = _point;
    map["address"] = _address;
    map["pickup"] = _pickup;
    map["arrived"] = _arrived;
    map["time"] = _time;
    map["passengerId"] = _passengerId;
    map["passengerName"] = _passengerName;
    map["confirmed"] = _confirmed;
    return map;
  }

}

/// id : "402880007afcc4a1017afccf8e4d0000"
/// firstName : null
/// lastName : null
/// review : 0.0

class Passengers {
  String? _id;
  dynamic? _firstName;
  dynamic? _lastName;
  double? _review;

  String? get id => _id;
  dynamic? get firstName => _firstName;
  dynamic? get lastName => _lastName;
  double? get review => _review;

  Passengers({
      String? id, 
      dynamic? firstName, 
      dynamic? lastName, 
      double? review}){
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _review = review;
}

  Passengers.fromJson(dynamic json) {
    _id = json["id"];
    _firstName = json["firstName"];
    _lastName = json["lastName"];
    _review = json["review"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["firstName"] = _firstName;
    map["lastName"] = _lastName;
    map["review"] = _review;
    return map;
  }

}
