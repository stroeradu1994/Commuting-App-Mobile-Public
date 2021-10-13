import 'package:commuting_app_mobile/dto/account/add_name_request.dart';
import 'package:commuting_app_mobile/dto/account/authorization_response.dart';
import 'package:commuting_app_mobile/dto/account/email_authentication_request.dart';
import 'package:commuting_app_mobile/dto/account/email_verification_request.dart';
import 'package:commuting_app_mobile/dto/account/phone_number_authentication_request.dart';
import 'package:commuting_app_mobile/dto/account/phone_number_verification_request.dart';
import 'package:commuting_app_mobile/dto/profile/profile_response.dart';
import 'package:commuting_app_mobile/services/token_service.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:dio/dio.dart';

import 'locator.dart';

class ProfileService {
  var tokenService = locator.get<TokenService>();

  Future getProfile() async {
    Dio dio = new Dio();
    Response response = await dio.get(BASE_URL + PROFILE_URL,
        options: tokenService.getAccessHeader());

    if (response.statusCode == 200) {
      return ProfileResponse.fromJson(response.data);
    } else {
      throw Exception('Failed to save location');
    }
  }
}
