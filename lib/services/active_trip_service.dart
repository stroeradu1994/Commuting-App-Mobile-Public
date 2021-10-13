import 'package:commuting_app_mobile/dto/trip/active_driver_trip_response.dart';
import 'package:commuting_app_mobile/dto/trip/active_passenger_trip_response.dart';
import 'package:commuting_app_mobile/dto/trip/complete_trip_request.dart';
import 'package:commuting_app_mobile/dto/trip/generic_active_trip_response.dart';
import 'package:commuting_app_mobile/dto/trip/trip_action_request.dart';
import 'package:commuting_app_mobile/services/service_wrapper.dart';
import 'package:commuting_app_mobile/services/token_service.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:dio/dio.dart';

import 'locator.dart';

class ActiveTripService {
  var tokenService = locator.get<TokenService>();
  var serviceWrapper = locator.get<ServiceWrapper>();

  Future getActiveTrips() async {
    Dio dio = new Dio();
    var response = await serviceWrapper.handleApiRequest(dio.get(BASE_URL + ACTIVE_TRIP_URL,
        options: tokenService.getAccessHeader()));

    if (response != null)
      return response
          .map<GenericActiveTripResponse>(
              (json) => GenericActiveTripResponse.fromJson(json))
          .toList();
    return null;
  }

  Future getActiveTripForPassenger(String id) async {
    Dio dio = new Dio();
    var response = await serviceWrapper.handleApiRequest(dio.get(BASE_URL + ACTIVE_TRIP_URL + '/passenger/' + id,
        options: tokenService.getAccessHeader()));

    if (response != null)
      return ActivePassengerTripResponse.fromJson(response);
    return null;
  }

  Future getActiveTripForDriver(String id) async {
    Dio dio = new Dio();
    var response = await serviceWrapper.handleApiRequest(dio.get(BASE_URL + ACTIVE_TRIP_URL + '/driver/' + id,
        options: tokenService.getAccessHeader()));

    if (response != null)
      return ActiveDriverTripResponse.fromJson(response);
    return null;
  }

  Future complete(CompleteTripRequest completeTripRequest) async {
    Dio dio = new Dio();
    var response = await serviceWrapper.handleApiRequest(dio.post(BASE_URL + ACTIVE_TRIP_URL + '/complete',
        data: completeTripRequest,
        options: tokenService.getAccessHeader()));

    return response;
  }

  Future arrivedAtPickup(TripActionRequest tripActionRequest) async {
    Dio dio = new Dio();
    var response = await serviceWrapper.handleApiRequest(dio.post(BASE_URL + ACTIVE_TRIP_URL + '/arrivedAtPickup',
        data: tripActionRequest,
        options: tokenService.getAccessHeader()));

    return response;
  }

  Future pickup(TripActionRequest tripActionRequest) async {
    Dio dio = new Dio();
    var response = await serviceWrapper.handleApiRequest(dio.post(BASE_URL + ACTIVE_TRIP_URL + '/pickup',
        data: tripActionRequest,
        options: tokenService.getAccessHeader()));

    return response;
  }

  Future drop(TripActionRequest tripActionRequest) async {
    Dio dio = new Dio();
    var response = await serviceWrapper.handleApiRequest(dio.post(BASE_URL + ACTIVE_TRIP_URL + '/drop',
        data: tripActionRequest,
        options: tokenService.getAccessHeader()));

    return response;
  }
}
