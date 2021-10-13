import 'package:commuting_app_mobile/dto/trip/active_passenger_trip_response.dart';
import 'package:commuting_app_mobile/dto/trip/past_passenger_trip_response.dart';
import 'package:commuting_app_mobile/services/active_trip_service.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/services/past_trip_service.dart';
import 'package:flutter/material.dart';

enum PastPassengerTripProviderState { NOT_FETCHED, IDLE, BUSY }

class PastPassengerTripProvider with ChangeNotifier {
  Map<String, PastPassengerTripProviderState> state = new Map();
  Map<String, PastPassengerTripResponse> _upcomingTrips = new Map();

  var _pastTripService = locator.get<PastTripService>();

  Future fetch(String id) async {
    state[id] = PastPassengerTripProviderState.BUSY;
    PastPassengerTripResponse upcomingPassengerTripResponse =
        await _pastTripService.getPastTripForPassenger(id);
    _upcomingTrips[id] = upcomingPassengerTripResponse;
    state[id] = PastPassengerTripProviderState.IDLE;
    notifyListeners();
  }

  PastPassengerTripResponse get(String id) {
    return _upcomingTrips[id]!;
  }

  PastPassengerTripProviderState getState(String id) {
    if (!state.containsKey(id)) {
      return PastPassengerTripProviderState.NOT_FETCHED;
    } else {
      return state[id]!;
    }
  }
}
