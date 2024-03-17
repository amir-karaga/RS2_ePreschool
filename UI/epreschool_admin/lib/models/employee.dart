import 'package:epreschool_admin/models/person.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Employee extends Person {
  late int? qualifications;
  late Person? person;
  late bool? workExperience;
  late int? drivingLicence;
  late String? dateOfEmployment;
  late int? marriageStatus;
  late int? position;
  late String? biography;
  late int? pay;
  late int? companyId;
  late dynamic file;
  Employee();

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['companyId'];
    dateOfEmployment = DateFormat('dd.MM.yyyy',WidgetsBinding.instance!.window.locale.languageCode)
        .format(DateTime.parse(json['dateOfEmployment']));
    qualifications = json['qualifications'];
    workExperience = json['workExperience'];
    drivingLicence = json['drivingLicence'];
    marriageStatus = json['marriageStatus'];
    position = json['position'];
    biography = json['biography'];
    pay = json['pay'];
    if (json['person'] != null) {
      person = Person.fromJson(json['person']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['companyId'] = companyId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['gender'] = gender;
    data['birthDate'] = birthDate;
    data['placeOfResidenceId'] = placeOfResidenceId;
    data['nationality'] = nationality;
    data['citizenship'] = citizenship;
    data['address'] = address;
    data['postCode'] = postCode;
    data['dateOfEmployment'] = dateOfEmployment;
    data['qualifications'] = qualifications;
    data['workExperience'] = workExperience;
    data['drivingLicence'] = drivingLicence;
    data['marriageStatus'] = marriageStatus;
    data['position'] = position;
    data['biography'] = biography;
    data['pay'] = pay;
    return data;
  }
}
