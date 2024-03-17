import 'package:epreschool_mobile/models/person.dart';
import 'package:intl/intl.dart';

class Child extends Person {
  late String? dateOfEnrollment;
  late Person? person;
  late String? emergencyContact;
  late String? specialNeeds;
  late String? note;
  late dynamic? file;
  late int parentId;
  late int kindergartenId;
  late int educatorId;
  Child();

  Child.fromJson(Map<String, dynamic> json) {
    print("test");
    id = json['id'];
    dateOfEnrollment = DateFormat('dd.MM.yyyy')
        .format(DateTime.parse(json['dateOfEnrollment']));
    emergencyContact = json['emergencyContact'];
    specialNeeds = json['specialNeeds'];
    note = json['note'];
    //createdAt = json['createdAt'];
    if (json['person'] != null) {
      person = Person.fromJson(json['person']);
    }
    parentId = json['parentId'];
    kindergartenId = json['kindergartenId'];
    educatorId = json['educatorId'];
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
