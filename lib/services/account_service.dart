import 'package:commuting_app_mobile/dto/account/add_name_request.dart';
import 'package:commuting_app_mobile/dto/account/add_fcm_token_request.dart';
import 'package:commuting_app_mobile/dto/account/authorization_response.dart';
import 'package:commuting_app_mobile/dto/account/email_authentication_request.dart';
import 'package:commuting_app_mobile/dto/account/account_response.dart';
import 'package:commuting_app_mobile/dto/account/email_verification_request.dart';
import 'package:commuting_app_mobile/dto/account/phone_number_authentication_request.dart';
import 'package:commuting_app_mobile/dto/account/phone_number_verification_request.dart';
import 'package:commuting_app_mobile/services/token_service.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:dio/dio.dart';

import 'locator.dart';

class AccountService {
  var tokenService = locator.get<TokenService>();

  Future emailAuthentication(
      EmailAuthenticationRequest emailAuthenticationRequest) async {
    Dio dio = new Dio();
    Response response = await dio.post(
        BASE_URL + ACCOUNT_URL + "/email/authentication",
        data: emailAuthenticationRequest);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to save location');
    }
  }

  Future emailVerification(
      EmailVerificationRequest emailVerificationRequest) async {
    Dio dio = new Dio();
    Response response = await dio.post(
        BASE_URL + ACCOUNT_URL + "/email/verification",
        data: emailVerificationRequest);

    if (response.statusCode == 200) {
      AuthorizationResponse authorizationResponse =
      AuthorizationResponse.fromJson(response.data);
      await tokenService.saveTokens(authorizationResponse);
      return response.data;
    } else {
      throw Exception('Failed to save location');
    }
  }

  Future phoneAuthentication(
      PhoneNumberAuthenticationRequest phoneNumberAuthenticationRequest) async {
    Dio dio = new Dio();
    Response response = await dio.post(
        BASE_URL + ACCOUNT_URL + "/phone/authentication",
        data: phoneNumberAuthenticationRequest,
        options: tokenService.getAccessHeader());

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to save location');
    }
  }

  Future phoneVerification(
      PhoneNumberVerificationRequest phoneNumberVerificationRequest) async {
    Dio dio = new Dio();
    Response response = await dio.post(
        BASE_URL + ACCOUNT_URL + "/phone/verification",
        data: phoneNumberVerificationRequest,
        options: tokenService.getAccessHeader());

    if (response.statusCode == 200) {
      AuthorizationResponse authorizationResponse =
      AuthorizationResponse.fromJson(response.data);
      await tokenService.saveTokens(authorizationResponse);
      return response.data;
    } else {
      throw Exception('Failed to save location');
    }
  }

  Future addName(AddNameRequest addNameRequest) async {
    Dio dio = new Dio();
    Response response = await dio.put(BASE_URL + ACCOUNT_URL + "/name",
        data: addNameRequest, options: tokenService.getAccessHeader());

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to save location');
    }
  }

  Future addFcmToken(AddFcmTokenRequest addFcmTokenRequest) async {
    Dio dio = new Dio();
    Response response = await dio.put(BASE_URL + ACCOUNT_URL + "/fcm",
        data: addFcmTokenRequest, options: tokenService.getAccessHeader());

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to save location');
    }
  }

  Future<AccountResponse?> getAccount() async {
    try {
      Dio dio = new Dio();
      Response response = await dio.get(BASE_URL + ACCOUNT_URL,
          options: tokenService.getAccessHeader());

      if (response.statusCode == 200) {
        return AccountResponse.fromJson(response.data);
      } else {
        return null;
      }
    } on DioError catch (e) {
      return null;
    }
  }

  Future reissueTokens() async {
    Dio dio = new Dio();
    Response response = await dio.post(BASE_URL + ACCOUNT_URL + "/reissue",
        options: tokenService.getRefreshHeader());

    if (response.statusCode == 200) {
      AuthorizationResponse authorizationResponse =
      AuthorizationResponse.fromJson(response.data);
      await tokenService.saveTokens(authorizationResponse);
      return response.data;
    } else {
      throw Exception('Failed to save location');
    }
  }
}
