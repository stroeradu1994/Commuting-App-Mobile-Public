
import 'package:commuting_app_mobile/dto/trip/upcoming_driver_trip_response.dart';
import 'package:commuting_app_mobile/dto/trip/upcoming_passenger_trip_response.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/services/notification_service.dart';
import 'package:commuting_app_mobile/services/upcoming_trip_service.dart';
import 'package:flutter/material.dart';
import 'package:commuting_app_mobile/dto/notification/notification_response.dart';

enum NotificationProviderState { NOT_FETCHED, IDLE, BUSY }

class NotificationProvider with ChangeNotifier {
  NotificationProviderState state = NotificationProviderState.NOT_FETCHED;
  List<NotificationResponse> notifications = [];

  var _notificationService = locator.get<NotificationService>();

  Future fetch() async {
    state = NotificationProviderState.BUSY;
    notifications = await _notificationService.getNotifications();
    state = NotificationProviderState.IDLE;
    notifyListeners();
  }
}