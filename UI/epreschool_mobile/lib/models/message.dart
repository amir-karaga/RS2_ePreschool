import 'package:epreschool_mobile/models/person.dart';

import 'base.dart';

class Message extends BaseModel {
  late String text;
  late int fromUserId;
  late Person fromUser;
  late int toUserId;
  late Person toUser;

  Message();

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    text = json['text'];
    fromUserId=json['fromUserId'];
    if (json['fromUser'] != null) {
      fromUser = Person.fromJson(json['fromUser']);
    }
    toUserId = json['toUserId'];
    if (json['toUser'] != null) {
      toUser = Person.fromJson(json['toUser']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['text'] = text;
    data['fromUserId'] = fromUserId;
    data['toUserId'] = toUserId;
    return data;
  }
}