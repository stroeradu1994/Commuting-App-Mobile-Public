import 'package:commuting_app_mobile/dto/car/car_response.dart';
import 'package:commuting_app_mobile/services/car_service.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:flutter/material.dart';

enum CarProviderState { NOT_FETCHED, IDLE, BUSY }

class CarProvider with ChangeNotifier {
  CarProviderState state = CarProviderState.NOT_FETCHED;

  List<CarResponse> cars = [];

  var carService = locator.get<CarService>();

  Future getCars() async {
    state = CarProviderState.BUSY;
    cars = await carService.getCars();
    state = CarProviderState.IDLE;
    notifyListeners();
  }
}
