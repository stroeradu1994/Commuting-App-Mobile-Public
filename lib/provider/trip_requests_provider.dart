import 'package:commuting_app_mobile/dto/trip/trip_request_response.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/services/trip_request_service.dart';
import 'package:flutter/material.dart';

enum TripRequestsProviderState { NOT_FETCHED, IDLE, BUSY }

class TripRequestsProvider with ChangeNotifier {
  TripRequestsProviderState state = TripRequestsProviderState.NOT_FETCHED;

  List<TripRequestResponse> tripRequests = [];

  var tripRequestService = locator.get<TripRequestService>();

  Future getTripRequests() async {
    state = TripRequestsProviderState.BUSY;
    tripRequests = await tripRequestService.getTripRequests();
    state = TripRequestsProviderState.IDLE;
    notifyListeners();
  }
}
