/// brand : "Seat"
/// models : ["Alhambra","Altea","Altea XL","Arosa","Cordoba","Cordoba Vario","Exeo","Ibiza","Ibiza ST","Exeo ST","Leon","Leon ST","Inca","Mii","Toledo"]

class CarModel {
  String _brand;
  List<String> _models;

  String get brand => _brand;

  List<String> get models => _models;

  CarModel({required String brand, required List<String> models})
      : _brand = brand,
        _models = models {}

  CarModel.fromJson(dynamic json)
      : _brand = json["brand"],
        _models = json["models"] != null ? json["models"].cast<String>() : [] {}

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["brand"] = _brand;
    map["models"] = _models;
    return map;
  }
}
