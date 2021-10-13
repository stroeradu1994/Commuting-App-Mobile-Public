import 'package:background_location/background_location.dart';
import 'package:commuting_app_mobile/dto/account/add_name_request.dart';
import 'package:commuting_app_mobile/dto/account/authorization_response.dart';
import 'package:commuting_app_mobile/dto/account/email_authentication_request.dart';
import 'package:commuting_app_mobile/dto/account/email_verification_request.dart';
import 'package:commuting_app_mobile/dto/account/phone_number_authentication_request.dart';
import 'package:commuting_app_mobile/dto/account/phone_number_verification_request.dart';
import 'package:commuting_app_mobile/dto/car/car_response.dart';
import 'package:commuting_app_mobile/dto/car/create_car_request.dart';
import 'package:commuting_app_mobile/dto/direction/point.dart';
import 'package:commuting_app_mobile/dto/profile/profile_response.dart';
import 'package:commuting_app_mobile/services/token_service.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:dio/dio.dart';

import 'locator.dart';

class PositionService {
  var tokenService = locator.get<TokenService>();

  Future startLocation()async {
    await BackgroundLocation.setAndroidNotification(
      title: "Notification title",
      message: "Notification message",
      icon: "@mipmap/ic_launcher",
    );
    await BackgroundLocation.setAndroidConfiguration(10000);
    await BackgroundLocation.startLocationService(distanceFilter : 0);
    await BackgroundLocation.getLocationUpdates((location) async {
      await add(new Point(lat: location.latitude, lng: location.longitude));
    });

  }

  Future add(Point point) async {
    Dio dio = new Dio();
    Response response = await dio.post(BASE_URL + POSITION_URL,
        data: point, options: tokenService.getAccessHeader());

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to save location');
    }
  }
}
