import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {

  SharedPreferences? prefs;

  Future buildPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences getPrefs() {
    return prefs!;
  }
}
