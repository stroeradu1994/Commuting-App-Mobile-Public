import 'package:commuting_app_mobile/dto/account/add_name_request.dart';
import 'package:commuting_app_mobile/dto/account/authorization_response.dart';
import 'package:commuting_app_mobile/dto/account/email_authentication_request.dart';
import 'package:commuting_app_mobile/dto/account/email_verification_request.dart';
import 'package:commuting_app_mobile/dto/notification/notification_type.dart';
import 'package:commuting_app_mobile/dto/notification/notification_response.dart';
import 'package:commuting_app_mobile/dto/account/phone_number_verification_request.dart';
import 'package:commuting_app_mobile/dto/car/car_response.dart';
import 'package:commuting_app_mobile/dto/car/create_car_request.dart';
import 'package:commuting_app_mobile/dto/profile/profile_response.dart';
import 'package:commuting_app_mobile/provider/active_passenger_trip_provider.dart';
import 'package:commuting_app_mobile/provider/active_trips_provider.dart';
import 'package:commuting_app_mobile/provider/past_trips_provider.dart';
import 'package:commuting_app_mobile/provider/trip_request_provider.dart';
import 'package:commuting_app_mobile/provider/trip_requests_provider.dart';
import 'package:commuting_app_mobile/provider/upcoming_driver_trip_provider.dart';
import 'package:commuting_app_mobile/provider/upcoming_passenger_trip_provider.dart';
import 'package:commuting_app_mobile/provider/upcoming_trips_provider.dart';
import 'package:commuting_app_mobile/screens/trips/active_driver_trip.dart';
import 'package:commuting_app_mobile/screens/trips/active_passenger_trip.dart';
import 'package:commuting_app_mobile/screens/trips/trip_request.dart';
import 'package:commuting_app_mobile/screens/trips/upcoming_driver_trip.dart';
import 'package:commuting_app_mobile/screens/trips/upcoming_passenger_trip.dart';
import 'package:commuting_app_mobile/services/token_service.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'locator.dart';

class NotificationService {
  var tokenService = locator.get<TokenService>();

  Future getNotifications() async {
    Dio dio = new Dio();
    Response response = await dio.get(BASE_URL + NOTIFICATION_URL,
        options: tokenService.getAccessHeader());

    if (response.statusCode == 200) {
      return response.data
          .map<NotificationResponse>(
              (json) => NotificationResponse.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to save location');
    }
  }

  GlobalKey<NavigatorState>? navigatorKey;
  GlobalKey<ScaffoldMessengerState>? _messangerKey;

  setNavKey(nav) {
    this.navigatorKey = nav;
  }

  setMessengerKey(mess) {
    this._messangerKey = mess;
  }

  openScreen(context, NotificationType? notificationType, String id) async {
    if (notificationType != null) {

      switch (notificationType) {
        case NotificationType.MATCH_FOUND:
          _navigate(context, TripRequest(id));
          break;
        case NotificationType.PASSENGER_JOIN:
          _navigate(context, UpcomingDriverTrip(id));
          break;
        case NotificationType.TRIP_CONFIRMED:
          _navigate(context, UpcomingPassengerTrip(id));
          break;
        case NotificationType.TRIP_STARTED:
          navigatorKey!.currentState!.popUntil((route) => route.isFirst);
          _navigate(context, ActivePassengerTrip(id));
          break;
        case NotificationType.PROMPT_TO_CONFIRM:
          _navigate(context, UpcomingDriverTrip(id));
          break;
        case NotificationType.PROMPT_TO_START:
          _navigate(context, UpcomingDriverTrip(id));
          break;
        case NotificationType.DRIVER_ARRIVED_AT_PICKUP:
          _navigate(context, ActivePassengerTrip(id));
          break;
        case NotificationType.DRIVER_CONFIRMED_PICKUP:
          _navigate(context, ActivePassengerTrip(id));
          break;
        case NotificationType.DRIVER_CONFIRMED_DROP:
          _navigate(context, ActivePassengerTrip(id));
          break;
        case NotificationType.TRIP_EXPIRED:
          navigatorKey!.currentState!.popUntil((route) => route.isFirst);
          break;
        case NotificationType.TRIP_COMPLETED:
          navigatorKey!.currentState!.popUntil((route) => route.isFirst);
          break;
        default:
      }
    }
  }

  refreshContent(context, NotificationType? notificationType, String id) async {
    if (notificationType != null) {
      var pastTripsProvider =
          Provider.of<PastTripsProvider>(context, listen: false);
      var upcomingTripsProvider =
          Provider.of<UpcomingTripsProvider>(context, listen: false);
      var tripRequestsProvider =
          Provider.of<TripRequestsProvider>(context, listen: false);
      var activeTripsProvider =
          Provider.of<ActiveTripsProvider>(context, listen: false);
      var activePassengerTripProvider =
          Provider.of<ActivePassengerTripProvider>(context, listen: false);
      var activeDriverTripProvider =
          Provider.of<ActivePassengerTripProvider>(context, listen: false);
      var upcomingDriverTripProvider =
          Provider.of<UpcomingDriverTripProvider>(context, listen: false);
      var upcomingPassengerTripProvider =
          Provider.of<UpcomingPassengerTripProvider>(context, listen: false);
      var tripRequestProvider =
          Provider.of<TripRequestProvider>(context, listen: false);

      switch (notificationType) {
        case NotificationType.MATCH_FOUND:
          await tripRequestsProvider.getTripRequests();
          await tripRequestProvider.fetch(id);
          break;
        case NotificationType.PASSENGER_JOIN:
          await upcomingTripsProvider.getUpcomingTrips();
          await upcomingDriverTripProvider.fetch(id);
          break;
        case NotificationType.TRIP_CONFIRMED:
          await upcomingTripsProvider.getUpcomingTrips();
          await upcomingPassengerTripProvider.fetch(id);
          break;
        case NotificationType.TRIP_STARTED:
          await upcomingTripsProvider.getUpcomingTrips();
          await activeTripsProvider.getActiveTrips();
          await activePassengerTripProvider.fetch(id);
          navigatorKey!.currentState!.popUntil((route) => route.isFirst);
          _navigate(context, ActivePassengerTrip(id));
          break;
        case NotificationType.DRIVER_ARRIVED_AT_PICKUP:
          await activeTripsProvider.getActiveTrips();
          await activePassengerTripProvider.fetch(id);
          break;
        case NotificationType.DRIVER_CONFIRMED_PICKUP:
          await activeTripsProvider.getActiveTrips();
          await activePassengerTripProvider.fetch(id);
          break;
        case NotificationType.DRIVER_CONFIRMED_DROP:
          await activeTripsProvider.getActiveTrips();
          await activePassengerTripProvider.fetch(id);
          break;
        case NotificationType.TRIP_EXPIRED:
          await activeTripsProvider.getActiveTrips();
          await pastTripsProvider.getPastTrips();
          navigatorKey!.currentState!.popUntil((route) => route.isFirst);
          break;
        case NotificationType.TRIP_COMPLETED:
          await activeTripsProvider.getActiveTrips();
          await pastTripsProvider.getPastTrips();
          navigatorKey!.currentState!.popUntil((route) => route.isFirst);
          break;
        default:
      }
    }
  }

  showNotificationSnackbar(
      context, String body, NotificationType? type, entity) {
    final snackBar = SnackBar(
      backgroundColor: primaryColor,
      content: Text(
        body,
        style: TextStyle(color: Colors.white),
      ),
      action: SnackBarAction(
        label: 'View',
        textColor: Colors.white,
        onPressed: () {
          openScreen(context, type, entity);
        },
      ),
    );
    _messangerKey!.currentState!.showSnackBar(snackBar);
  }

  showSnackBar(String body) {
    final snackBar = SnackBar(
      backgroundColor: primaryColor,
      content: Text(
        body,
        style: TextStyle(color: Colors.white),
      ),
    );
    _messangerKey!.currentState!.showSnackBar(snackBar);
  }

  _navigate(context, widget) {
    navigatorKey!.currentState!.popUntil((route) => route.isFirst);
    navigatorKey!.currentState!.push(
      CupertinoPageRoute(builder: (context) => widget),
    );
  }
}
