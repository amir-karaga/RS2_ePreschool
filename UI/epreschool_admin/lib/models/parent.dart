import 'package:epreschool_admin/models/company.dart';
import 'package:epreschool_admin/models/person.dart';

class Parent extends Person {
  late int? qualification;
  late Person? person;
  late bool? isEmployed;
  late String? employerName;
  late int? marriageStatus;
  late String? employeAddress;
  late String? employerPhoneNumber;
  late String? jobDescription;
  late Company? kindergarten;
  late int? kindergartenId;
  late dynamic? file;
  Parent();

  Parent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    qualification = json['qualification'];
    jobDescription = json['jobDescription'];
    isEmployed = json['isEmployed'];
    marriageStatus = json['marriageStatus'];
    employerName = json['employerName'];
    employeAddress = json['employerAddress'];
    employerPhoneNumber = json['employerPhoneNumber'];
    kindergartenId = json['kindergartenId'];
    if (json['person'] != null) {
      person = Person.fromJson(json['person']);
    }
    if (json['kindergarten'] != null) {
      kindergarten = Company.fromJson(json['kindergarten']);
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
    data['jobDescription'] = jobDescription;
    data['isEmployed'] = isEmployed;
    data['employerName'] = employerName;
    data['employeAddress'] = employeAddress;
    data['marriageStatus'] = marriageStatus;
    data['employerPhoneNumber'] = employerPhoneNumber;
    data['qualification'] = qualification;
    data['kindergartenId'] = kindergartenId;
    return data;
  }
}
