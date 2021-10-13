import 'package:commuting_app_mobile/dto/profile/profile_response.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/services/profile_service.dart';
import 'package:flutter/material.dart';

enum ProfileProviderState { NOT_FETCHED, IDLE, BUSY }

class ProfileProvider with ChangeNotifier {
  ProfileProviderState state = ProfileProviderState.NOT_FETCHED;

  ProfileResponse? profile;

  var profileService = locator.get<ProfileService>();

  Future getProfile() async {
    state = ProfileProviderState.BUSY;
    profile = await profileService.getProfile();
    state = ProfileProviderState.IDLE;
    notifyListeners();
  }

}
