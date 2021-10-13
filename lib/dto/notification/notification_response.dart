/// id : ""
/// userId : ""
/// text : ""
/// type : ""
/// entityId : ""
/// createdAt : ""

class NotificationResponse {
  String? _id;
  String? _userId;
  String? _text;
  String? _type;
  String? _entityId;
  String? _createdAt;

  String? get id => _id;
  String? get userId => _userId;
  String? get text => _text;
  String? get type => _type;
  String? get entityId => _entityId;
  String? get createdAt => _createdAt;

  NotificationResponse({
      String? id, 
      String? userId, 
      String? text, 
      String? type, 
      String? entityId, 
      String? createdAt}){
    _id = id;
    _userId = userId;
    _text = text;
    _type = type;
    _entityId = entityId;
    _createdAt = createdAt;
}

  NotificationResponse.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['userId'];
    _text = json['text'];
    _type = json['type'];
    _entityId = json['entityId'];
    _createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['userId'] = _userId;
    map['text'] = _text;
    map['type'] = _type;
    map['entityId'] = _entityId;
    map['createdAt'] = _createdAt;
    return map;
  }

}