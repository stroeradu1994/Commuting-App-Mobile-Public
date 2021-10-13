
import 'package:commuting_app_mobile/dto/trip/upcoming_passenger_trip_response.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/services/upcoming_trip_service.dart';
import 'package:flutter/material.dart';

enum UpcomingPassengerTripProviderState { NOT_FETCHED, IDLE, BUSY }

class UpcomingPassengerTripProvider with ChangeNotifier {
  Map<String, UpcomingPassengerTripProviderState> state = new Map();
  Map<String, UpcomingPassengerTripResponse> _upcomingTrips = new Map();

  var _upcomingTripService = locator.get<UpcomingTripService>();

  Future fetch(String id) async {
    state[id] = UpcomingPassengerTripProviderState.BUSY;
    UpcomingPassengerTripResponse upcomingPassengerTripResponse = await _upcomingTripService.getUpcomingTripForPassenger(id);
    _upcomingTrips[id] = upcomingPassengerTripResponse;
    state[id] = UpcomingPassengerTripProviderState.IDLE;
    notifyListeners();
  }

  UpcomingPassengerTripResponse get(String id) {
    return _upcomingTrips[id]!;
  }

  UpcomingPassengerTripProviderState getState(String id) {
    if (!state.containsKey(id)) {
      return UpcomingPassengerTripProviderState.NOT_FETCHED;
    } else {
      return state[id]!;
    }
  }
}
