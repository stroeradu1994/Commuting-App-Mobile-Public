
import 'package:commuting_app_mobile/dto/trip/active_driver_trip_response.dart';
import 'package:commuting_app_mobile/dto/trip/past_driver_trip_response.dart';
import 'package:commuting_app_mobile/services/active_trip_service.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/services/past_trip_service.dart';
import 'package:flutter/material.dart';

enum PastDriverTripProviderState { NOT_FETCHED, IDLE, BUSY }

class PastDriverTripProvider with ChangeNotifier {
  Map<String, PastDriverTripProviderState> state = new Map();
  Map<String, PastDriverTripResponse> _pastTrips = new Map();

  var _pastTripService = locator.get<PastTripService>();

  Future fetch(String id) async {
    state[id] = PastDriverTripProviderState.BUSY;
    PastDriverTripResponse upcomingDriverTripResponse = await _pastTripService.getPastTripForDriver(id);
    _pastTrips[id] = upcomingDriverTripResponse;
    state[id] = PastDriverTripProviderState.IDLE;
    notifyListeners();
  }

  PastDriverTripResponse get(String id) {
    return _pastTrips[id]!;
  }

  PastDriverTripProviderState getState(String id) {
    if (!state.containsKey(id)) {
      return PastDriverTripProviderState.NOT_FETCHED;
    } else {
      return state[id]!;
    }
  }
}