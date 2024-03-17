import 'package:epreschool_mobile/helpers/constants.dart';
import 'package:epreschool_mobile/models/person.dart';

class New {
  late int id;
  late String name;
  late String text;
  late int userId;
  late Person? user;
  late bool public;
  late String createdAt;
  late String image;

  New(){

  }

  New.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    text = json['text'];
    userId = json['userId'];
    public = json['public'];
    createdAt = json['createdAt'];
    if(json['image']!=null)
      {
        image = Constants.apiUrl + json['image'];
      }
    else{
      image ="";
    }

    if (json['user'] != null) {
      dynamic creationUser = json['user'];
      if (creationUser != null) {
        user = Person.fromJson(creationUser['person']);
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['text'] = text;
    data['public'] = public;
    return data;
  }
}
