import 'package:commuting_app_mobile/dto/car/create_car_request.dart';
import 'package:commuting_app_mobile/dto/trip/create_trip_dto.dart';
import 'package:commuting_app_mobile/dto/trip/create_trip_request_dto.dart';

class CreationService {
  CreateCarRequest createCarRequest = new CreateCarRequest(
      brand: 'Dacia', model: 'Logan', color: 'White', plate: '');

  resetCreateCarRequest() {
    createCarRequest = new CreateCarRequest(
        brand: 'Dacia', model: 'Logan', color: 'White', plate: '');
  }

  CreateTripDto? createTripDto;

  CreateTripRequestDto? createTripRequestDto;
}
