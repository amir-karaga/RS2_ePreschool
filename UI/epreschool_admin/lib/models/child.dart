import 'package:epreschool_admin/models/person.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class Child extends Person {
  late String? dateOfEnrollment;
  late Person? person;
  late String? emergencyContact;
  late String? specialNeeds;
  late String? note;
  late int kindergartenId;
  late int parentId;
  late int educatorId;
  late dynamic? file;
  Child();

  Child.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateOfEnrollment =  DateFormat('dd.MM.yyyy',WidgetsBinding.instance!.window.locale.languageCode).format(DateTime.parse(json['dateOfEnrollment']));
    emergencyContact = json['emergencyContact'];
    specialNeeds = json['specialNeeds'];
    note = json['note'];
    kindergartenId = json['kindergartenId'];
    parentId = json['parentId'];
    educatorId = json['educatorId'];
    if (json['person'] != null) {
      person = Person.fromJson(json['person']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['gender'] = gender;
    data['birthDate'] = birthDate;
    data['placeOfResidenceId'] = placeOfResidenceId;
    data['nationality'] = nationality;
    data['citizenship'] = citizenship;
    data['address'] = address;
    data['postCode'] = postCode;
    data['dateOfEnrollment'] = dateOfEnrollment;
    data['emergencyContact'] = emergencyContact;
    data['specialNeeds'] = specialNeeds;
    data['note'] = note;
    //data['file'] = file;
    return data;
  }
}
