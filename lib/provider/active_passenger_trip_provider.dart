import 'package:commuting_app_mobile/dto/trip/active_passenger_trip_response.dart';
import 'package:commuting_app_mobile/services/active_trip_service.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:flutter/material.dart';

enum ActivePassengerTripProviderState { NOT_FETCHED, IDLE, BUSY }

class ActivePassengerTripProvider with ChangeNotifier {
  Map<String, ActivePassengerTripProviderState> _state = new Map();
  Map<String, ActivePassengerTripResponse> _upcomingTrips = new Map();

  var _activeTripService = locator.get<ActiveTripService>();

  Future fetch(String id) async {
    _state[id] = ActivePassengerTripProviderState.BUSY;
    _upcomingTrips[id] = await _activeTripService.getActiveTripForPassenger(id);
    _state[id] = ActivePassengerTripProviderState.IDLE;
    notifyListeners();
  }

  ActivePassengerTripResponse get(String id) {
    return _upcomingTrips[id]!;
  }

  ActivePassengerTripProviderState getState(String id) {
    return _state.containsKey(id)
        ? _state[id]!
        : ActivePassengerTripProviderState.NOT_FETCHED;
  }
}
