/// id : "402880007ab9d3a8017ab9d3d5950000"
/// firstName : null
/// lastName : null
/// email : "string"
/// phone : null
/// imageUrl : null
/// rating : 0.0

class ProfileResponse {
  String? _id;
  dynamic? _firstName;
  dynamic? _lastName;
  String? _email;
  dynamic? _phone;
  dynamic? _imageUrl;
  double? _rating;
  double? _points;

  String? get id => _id;
  dynamic? get firstName => _firstName;
  dynamic? get lastName => _lastName;
  String? get email => _email;
  dynamic? get phone => _phone;
  dynamic? get imageUrl => _imageUrl;
  double? get rating => _rating;
  double? get points => _points;

  ProfileResponse({
      String? id, 
      dynamic? firstName, 
      dynamic? lastName, 
      String? email, 
      dynamic? phone, 
      dynamic? imageUrl, 
      dynamic? points,
      double? rating}){
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _phone = phone;
    _imageUrl = imageUrl;
    _rating = rating;
    _points = points;
}

  ProfileResponse.fromJson(dynamic json) {
    _id = json["id"];
    _firstName = json["firstName"];
    _lastName = json["lastName"];
    _email = json["email"];
    _phone = json["phone"];
    _imageUrl = json["imageUrl"];
    _rating = json["rating"];
    _points = json["points"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["firstName"] = _firstName;
    map["lastName"] = _lastName;
    map["email"] = _email;
    map["phone"] = _phone;
    map["imageUrl"] = _imageUrl;
    map["rating"] = _rating;
    map["points"] = _points;
    return map;
  }

}