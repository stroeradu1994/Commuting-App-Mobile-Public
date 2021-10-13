/// numberOfTripsAsDriver : 1
/// numberOfTripsAsPassenger : 1
/// kmAsDriver : 1
/// kmAsPassenger : 1
/// numberOfPassengers : 1

class StatisticsResponse {
  double? _numberOfTripsAsDriver;
  double? _numberOfTripsAsPassenger;
  double? _kmAsDriver;
  double? _kmAsPassenger;
  double? _numberOfPassengers;

  double? get numberOfTripsAsDriver => _numberOfTripsAsDriver;
  double? get numberOfTripsAsPassenger => _numberOfTripsAsPassenger;
  double? get kmAsDriver => _kmAsDriver;
  double? get kmAsPassenger => _kmAsPassenger;
  double? get numberOfPassengers => _numberOfPassengers;

  StatisticsResponse({
      double? numberOfTripsAsDriver, 
      double? numberOfTripsAsPassenger, 
      double? kmAsDriver, 
      double? kmAsPassenger, 
      double? numberOfPassengers}){
    _numberOfTripsAsDriver = numberOfTripsAsDriver;
    _numberOfTripsAsPassenger = numberOfTripsAsPassenger;
    _kmAsDriver = kmAsDriver;
    _kmAsPassenger = kmAsPassenger;
    _numberOfPassengers = numberOfPassengers;
}

  StatisticsResponse.fromJson(dynamic json) {
    _numberOfTripsAsDriver = json['numberOfTripsAsDriver'];
    _numberOfTripsAsPassenger = json['numberOfTripsAsPassenger'];
    _kmAsDriver = json['kmAsDriver'];
    _kmAsPassenger = json['kmAsPassenger'];
    _numberOfPassengers = json['numberOfPassengers'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['numberOfTripsAsDriver'] = _numberOfTripsAsDriver;
    map['numberOfTripsAsPassenger'] = _numberOfTripsAsPassenger;
    map['kmAsDriver'] = _kmAsDriver;
    map['kmAsPassenger'] = _kmAsPassenger;
    map['numberOfPassengers'] = _numberOfPassengers;
    return map;
  }

}