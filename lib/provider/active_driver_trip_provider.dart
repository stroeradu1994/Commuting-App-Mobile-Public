
import 'package:commuting_app_mobile/dto/trip/active_driver_trip_response.dart';
import 'package:commuting_app_mobile/services/active_trip_service.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:flutter/material.dart';

enum ActiveDriverTripProviderState { NOT_FETCHED, IDLE, BUSY }

class ActiveDriverTripProvider with ChangeNotifier {
  Map<String, ActiveDriverTripProviderState> state = new Map();
  Map<String, ActiveDriverTripResponse> _upcomingTrips = new Map();

  var _activeTripService = locator.get<ActiveTripService>();

  Future fetch(String id) async {
    state[id] = ActiveDriverTripProviderState.BUSY;
    ActiveDriverTripResponse upcomingDriverTripResponse = await _activeTripService.getActiveTripForDriver(id);
    _upcomingTrips[id] = upcomingDriverTripResponse;
    state[id] = ActiveDriverTripProviderState.IDLE;
    notifyListeners();
  }

  ActiveDriverTripResponse get(String id) {
    return _upcomingTrips[id]!;
  }

  ActiveDriverTripProviderState getState(String id) {
    if (!state.containsKey(id)) {
      return ActiveDriverTripProviderState.NOT_FETCHED;
    } else {
      return state[id]!;
    }
  }
}