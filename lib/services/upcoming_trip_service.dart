import 'package:commuting_app_mobile/dto/trip/generic_upcoming_trip_response.dart';
import 'package:commuting_app_mobile/dto/trip/generic_active_trip_response.dart';
import 'package:commuting_app_mobile/dto/trip/start_trip.dart';
import 'package:commuting_app_mobile/dto/trip/upcoming_passenger_trip_response.dart';
import 'package:commuting_app_mobile/dto/trip/upcoming_driver_trip_response.dart';
import 'package:commuting_app_mobile/dto/trip/active_passenger_trip_response.dart';
import 'package:commuting_app_mobile/dto/trip/active_driver_trip_response.dart';
import 'package:commuting_app_mobile/dto/trip/create_trip_dto.dart';
import 'package:commuting_app_mobile/dto/trip/confirm_trip.dart';
import 'package:commuting_app_mobile/services/notification_service.dart';
import 'package:commuting_app_mobile/services/token_service.dart';
import 'package:commuting_app_mobile/services/service_wrapper.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:dio/dio.dart';

import 'locator.dart';

class UpcomingTripService {
  var tokenService = locator.get<TokenService>();
  var serviceWrapper = locator.get<ServiceWrapper>();

  Future createTrip(CreateTripDto createTripDto) async {
    Dio dio = new Dio();
    var response = await serviceWrapper.handleApiRequest(dio.post(
        BASE_URL + UPCOMING_TRIP_URL,
        data: createTripDto,
        options: tokenService.getAccessHeader()));
    return response;
  }

  Future getUpcomingTrips() async {
    Dio dio = new Dio();
    var response = await serviceWrapper.handleApiRequest(dio.get(
        BASE_URL + UPCOMING_TRIP_URL,
        options: tokenService.getAccessHeader()));

    if (response != null)
      return response
          .map<GenericUpcomingTripResponse>(
              (json) => GenericUpcomingTripResponse.fromJson(json))
          .toList();
    return null;
  }

  Future getUpcomingTripForPassenger(String id) async {
    Dio dio = new Dio();
    var response = await serviceWrapper.handleApiRequest(dio.get(
        BASE_URL + UPCOMING_TRIP_URL + '/passenger/' + id,
        options: tokenService.getAccessHeader()));

    if (response != null)
      return UpcomingPassengerTripResponse.fromJson(response);
    return null;
  }

  Future getUpcomingTripForDriver(String id) async {
    Dio dio = new Dio();
    var response = await serviceWrapper.handleApiRequest(dio.get(
        BASE_URL + UPCOMING_TRIP_URL + '/driver/' + id,
        options: tokenService.getAccessHeader()));

    if (response != null)
      return UpcomingDriverTripResponse.fromJson(response);
    return null;
  }

  Future confirmTrip(ConfirmTrip confirmTrip) async {
    Dio dio = new Dio();
    return await serviceWrapper.handleApiRequest(dio.post(
        BASE_URL + UPCOMING_TRIP_URL + '/confirm',
        data: confirmTrip,
        options: tokenService.getAccessHeader()));
  }

  Future startTrip(StartTrip startTrip) async {
    Dio dio = new Dio();
    return await serviceWrapper.handleApiRequest(dio.post(
        BASE_URL + UPCOMING_TRIP_URL + '/start',
        data: startTrip,
        options: tokenService.getAccessHeader()));
  }

  Future cancelTrip(String id) async {
    Dio dio = new Dio();
    return await serviceWrapper.handleApiRequest(dio.delete(
        BASE_URL + UPCOMING_TRIP_URL + '/' + id,
        options: tokenService.getAccessHeader()));
  }
}
