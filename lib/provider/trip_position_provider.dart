
import 'package:commuting_app_mobile/dto/direction/point.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/services/trip_position_service.dart';
import 'package:flutter/material.dart';

enum TripPositionProviderState { NOT_FETCHED, IDLE, BUSY }

class TripPositionProvider with ChangeNotifier {
  Map<String, TripPositionProviderState> state = new Map();
  Map<String, Point> _tripPositions = new Map();

  var _tripPositionService = locator.get<TripPositionService>();

  Future fetch(String tripId, String userId) async {
    state[userId] = TripPositionProviderState.BUSY;
    Point position = await _tripPositionService.get(tripId, userId);
    _tripPositions[userId] = position;
    state[userId] = TripPositionProviderState.IDLE;
    notifyListeners();
  }

  Point get(String userId) {
    return _tripPositions[userId]!;
  }

  TripPositionProviderState getState(String userId) {
    if (!state.containsKey(userId)) {
      return TripPositionProviderState.NOT_FETCHED;
    } else {
      return state[userId]!;
    }
  }
}
