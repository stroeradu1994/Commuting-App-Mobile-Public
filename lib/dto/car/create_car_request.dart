/// brand : "string"
/// color : "string"
/// model : "string"
/// plate : "string"

class CreateCarRequest {
  String? _brand;
  String? _color;
  String? _model;
  String? _plate;

  String? get brand => _brand;
  String? get color => _color;
  String? get model => _model;
  String? get plate => _plate;


  CreateCarRequest({
      String? brand, 
      String? color, 
      String? model, 
      String? plate}){
    _brand = brand;
    _color = color;
    _model = model;
    _plate = plate;
}

  CreateCarRequest.fromJson(dynamic json) {
    _brand = json["brand"];
    _color = json["color"];
    _model = json["model"];
    _plate = json["plate"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["brand"] = _brand;
    map["color"] = _color;
    map["model"] = _model;
    map["plate"] = _plate;
    return map;
  }

  set brand(String? value) {
    _brand = value;
  }

  set color(String? value) {
    _color = value;
  }

  set model(String? value) {
    _model = value;
  }

  set plate(String? value) {
    _plate = value;
  }
}