import 'package:commuting_app_mobile/dto/location/location_response.dart';

/// id : "402880007ae2d924017ae2f8d42a0004"
/// fromLocation : {"id":"402880007ae2d924017ae2f85c000002","label":"Home","address":"Strada Râmnicu Vâlcea 19, București, Romania","point":{"lat":44.4156433,"lng":26.141303300000004}}
/// toLocation : {"id":"402880007ae2d924017ae2f8b6ca0003","label":"Work","address":"Strada Popa Nan 139, București, Romania","point":{"lat":44.429275942591595,"lng":26.126607432961464}}
/// dateTime : "2021-07-26T16:19:51.119613"
/// matches : 0

class TripRequestResponse {
  String? _id;
  LocationResponse? _fromLocation;
  LocationResponse? _toLocation;
  String? _dateTime;
  int? _matches;

  String? get id => _id;
  LocationResponse? get fromLocation => _fromLocation;
  LocationResponse? get toLocation => _toLocation;
  String? get dateTime => _dateTime;
  int? get matches => _matches;

  TripRequestResponse({
      String? id,
    LocationResponse? fromLocation,
    LocationResponse? toLocation,
      String? dateTime, 
      int? matches}){
    _id = id;
    _fromLocation = fromLocation;
    _toLocation = toLocation;
    _dateTime = dateTime;
    _matches = matches;
}

  TripRequestResponse.fromJson(dynamic json) {
    _id = json["id"];
    _fromLocation = json["fromLocation"] != null ? LocationResponse.fromJson(json["fromLocation"]) : null;
    _toLocation = json["toLocation"] != null ? LocationResponse.fromJson(json["toLocation"]) : null;
    _dateTime = json["dateTime"];
    _matches = json["matches"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    if (_fromLocation != null) {
      map["fromLocation"] = _fromLocation?.toJson();
    }
    if (_toLocation != null) {
      map["toLocation"] = _toLocation?.toJson();
    }
    map["dateTime"] = _dateTime;
    map["matches"] = _matches;
    return map;
  }

}
