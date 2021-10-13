
import 'package:commuting_app_mobile/dto/trip/upcoming_driver_trip_response.dart';
import 'package:commuting_app_mobile/dto/trip/upcoming_passenger_trip_response.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/services/upcoming_trip_service.dart';
import 'package:flutter/material.dart';

enum UpcomingDriverTripProviderState { NOT_FETCHED, IDLE, BUSY }

class UpcomingDriverTripProvider with ChangeNotifier {
  Map<String, UpcomingDriverTripProviderState> state = new Map();
  Map<String, UpcomingDriverTripResponse> _upcomingTrips = new Map();

  var _upcomingTripService = locator.get<UpcomingTripService>();

  Future fetch(String id) async {
    state[id] = UpcomingDriverTripProviderState.BUSY;
    UpcomingDriverTripResponse upcomingDriverTripResponse = await _upcomingTripService.getUpcomingTripForDriver(id);
    _upcomingTrips[id] = upcomingDriverTripResponse;
    state[id] = UpcomingDriverTripProviderState.IDLE;
    notifyListeners();
  }

  UpcomingDriverTripResponse get(String id) {
    return _upcomingTrips[id]!;
  }

  UpcomingDriverTripProviderState getState(String id) {
    if (!state.containsKey(id)) {
      return UpcomingDriverTripProviderState.NOT_FETCHED;
    } else {
      return state[id]!;
    }
  }
}