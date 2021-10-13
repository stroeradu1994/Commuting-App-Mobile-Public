import 'package:commuting_app_mobile/dto/location/location_response.dart';
import 'package:commuting_app_mobile/dto/trip/match_response.dart';

class TripRequestResponseWithMatches {
  String? _id;
  LocationResponse? _fromLocation;
  LocationResponse? _toLocation;
  String? _dateTime;
  List<MatchResponse>? _matches;

  String? get id => _id;
  LocationResponse? get fromLocation => _fromLocation;
  LocationResponse? get toLocation => _toLocation;
  String? get dateTime => _dateTime;
  List<MatchResponse>? get matches => _matches;

  TripRequestResponseWithMatches({
      String? id, 
      LocationResponse? fromLocation, 
      LocationResponse? toLocation, 
      String? dateTime, 
      List<MatchResponse>? matches}){
    _id = id;
    _fromLocation = fromLocation;
    _toLocation = toLocation;
    _dateTime = dateTime;
    _matches = matches;
}

  TripRequestResponseWithMatches.fromJson(dynamic json) {
    _id = json["id"];
    _fromLocation = json["fromLocation"] != null ? LocationResponse.fromJson(json["fromLocation"]) : null;
    _toLocation = json["toLocation"] != null ? LocationResponse.fromJson(json["toLocation"]) : null;
    _dateTime = json["dateTime"];
    if (json["matches"] != null) {
      _matches = [];
      json["matches"].forEach((v) {
        _matches?.add(MatchResponse.fromJson(v));
      });
    }
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
    if (_matches != null) {
      map["matches"] = _matches?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}
