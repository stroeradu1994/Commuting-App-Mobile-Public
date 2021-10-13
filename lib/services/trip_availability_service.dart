import 'package:commuting_app_mobile/dto/trip/trip_availability_request.dart';
import 'package:commuting_app_mobile/services/notification_service.dart';
import 'package:commuting_app_mobile/services/service_wrapper.dart';
import 'package:commuting_app_mobile/services/token_service.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:dio/dio.dart';

import 'locator.dart';

class TripAvailabilityService {
  var tokenService = locator.get<TokenService>();
  var notificationService = locator.get<NotificationService>();
  var serviceWrapper = locator.get<ServiceWrapper>();

  Future checkAvailability(TripAvailabilityRequest tripAvailabilityRequest) async {

    try {
      Dio dio = new Dio();
      Response response = await dio.post(
          BASE_URL + AVAILABILITY_URL,
          data: tripAvailabilityRequest,
          options: tokenService.getAccessHeader());

      if (response.statusCode == 200) {
        return true;
      } else {
        notificationService.showSnackBar(response.data);
        return false;
      }
    } on DioError catch (e) {
      notificationService.showSnackBar(e.response!.data["message"]);
      return false;
    }
  }
}
