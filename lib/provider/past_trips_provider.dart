import 'package:commuting_app_mobile/dto/trip/generic_past_trip_response.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/services/past_trip_service.dart';
import 'package:flutter/material.dart';

enum PastTripsProviderState { NOT_FETCHED, IDLE, BUSY }

class PastTripsProvider with ChangeNotifier {
  PastTripsProviderState state = PastTripsProviderState.NOT_FETCHED;

  List<GenericPastTripResponse> trips = [];

  var _pastTripService = locator.get<PastTripService>();

  Future getPastTrips() async {
    state = PastTripsProviderState.BUSY;
    trips = await _pastTripService.getPastTrips();
    state = PastTripsProviderState.IDLE;
    notifyListeners();
  }
}
