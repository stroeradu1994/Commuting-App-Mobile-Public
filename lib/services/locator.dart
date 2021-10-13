import 'package:commuting_app_mobile/services/car_service.dart';
import 'package:commuting_app_mobile/services/prefs_service.dart';
import 'package:commuting_app_mobile/services/profile_service.dart';
import 'package:commuting_app_mobile/services/rating_service.dart';
import 'package:commuting_app_mobile/services/secrets_service.dart';
import 'package:commuting_app_mobile/services/token_service.dart';
import 'package:commuting_app_mobile/services/creation_service.dart';
import 'package:commuting_app_mobile/services/direction_service.dart';
import 'package:commuting_app_mobile/services/upcoming_trip_service.dart';
import 'package:commuting_app_mobile/services/active_trip_service.dart';
import 'package:commuting_app_mobile/services/past_trip_service.dart';
import 'package:commuting_app_mobile/services/service_wrapper.dart';
import 'package:commuting_app_mobile/services/trip_request_service.dart';
import 'package:commuting_app_mobile/services/match_service.dart';
import 'package:commuting_app_mobile/services/position_service.dart';
import 'package:commuting_app_mobile/services/trip_position_service.dart';
import 'package:commuting_app_mobile/services/trip_availability_service.dart';
import 'package:commuting_app_mobile/services/statistics_service.dart';
import 'package:get_it/get_it.dart';

import 'account_service.dart';
import 'location_service.dart';
import 'notification_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<PrefsService>(PrefsService());
  locator.registerSingleton<TokenService>(TokenService());
  locator.registerSingleton<SecretsService>(SecretsService());
  locator.registerSingleton<NotificationService>(NotificationService());
  locator.registerSingleton<ServiceWrapper>(ServiceWrapper());
  locator.registerSingleton<AccountService>(AccountService());
  locator.registerSingleton<CarService>(CarService());
  locator.registerSingleton<ProfileService>(ProfileService());
  locator.registerSingleton<LocationService>(LocationService());
  locator.registerSingleton<CreationService>(CreationService());
  locator.registerSingleton<DirectionService>(DirectionService());
  locator.registerSingleton<UpcomingTripService>(UpcomingTripService());
  locator.registerSingleton<ActiveTripService>(ActiveTripService());
  locator.registerSingleton<PastTripService>(PastTripService());
  locator.registerSingleton<TripRequestService>(TripRequestService());
  locator.registerSingleton<MatchService>(MatchService());
  locator.registerSingleton<PositionService>(PositionService());
  locator.registerSingleton<TripPositionService>(TripPositionService());
  locator.registerSingleton<TripAvailabilityService>(TripAvailabilityService());
  locator.registerSingleton<StatisticsService>(StatisticsService());
  locator.registerSingleton<RatingService>(RatingService());
}
