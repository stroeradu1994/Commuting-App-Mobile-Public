import 'package:commuting_app_mobile/dto/trip/trip_request_response_with_matches.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/services/trip_request_service.dart';
import 'package:flutter/material.dart';

enum TripRequestProviderState { NOT_FETCHED, IDLE, BUSY }

class TripRequestProvider with ChangeNotifier {
  Map<String, TripRequestProviderState> state = new Map();
  Map<String, TripRequestResponseWithMatches> _tripRequests = new Map();

  var _tripRequestService = locator.get<TripRequestService>();

  Future fetch(String id) async {
    state[id] = TripRequestProviderState.BUSY;
    TripRequestResponseWithMatches tripRequestResponse =
        await _tripRequestService.getTripRequest(id);
    _tripRequests[id] = tripRequestResponse;
    state[id] = TripRequestProviderState.IDLE;
    notifyListeners();
  }

  TripRequestResponseWithMatches get(String id) {
    return _tripRequests[id]!;
  }

  TripRequestProviderState getState(String id) {
    if (!state.containsKey(id)) {
      return TripRequestProviderState.NOT_FETCHED;
    } else {
      return state[id]!;
    }
  }
}
