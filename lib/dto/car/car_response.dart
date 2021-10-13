/// id : "string"
/// brand : "string"
/// color : "string"
/// model : "string"
/// plate : "string"

class CarResponse {
  String? _id;
  String? _brand;
  String? _color;
  String? _model;
  String? _plate;

  String? get id => _id;

  String? get brand => _brand;

  String? get color => _color;

  String? get model => _model;

  String? get plate => _plate;

  CarResponse(
      {String? id,
      String? brand,
      String? color,
      String? model,
      String? plate}) {
    _id = id;
    _brand = brand;
    _color = color;
    _model = model;
    _plate = plate;
  }

  CarResponse.fromJson(dynamic json) {
    _id = json["id"];
    _brand = json["brand"];
    _color = json["color"];
    _model = json["model"];
    _plate = json["plate"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["brand"] = _brand;
    map["color"] = _color;
    map["model"] = _model;
    map["plate"] = _plate;
    return map;
  }
}
