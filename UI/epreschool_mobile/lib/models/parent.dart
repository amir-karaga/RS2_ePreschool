import 'package:epreschool_mobile/models/company.dart';
import 'package:epreschool_mobile/models/person.dart';

class Parent extends Person {
  late int? qualification;
  late Person? person;
  late bool? isEmployed;
  late String? employerName;
  late int? marriageStatus;
  late String? employerAddress;
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
    employerAddress = json['employerAddress'];
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
    data['userName'] = userName;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['gender'] = gender;
    data['birthDate'] = birthDate;
    data['placeOfResidenceId'] = null;
    data['birthPlaceId'] = null;
    data['JMBG'] = null;
    data['profilePhoto'] = "";
    data['profilePhotoThumbnail'] = "";
    data['nationality'] = "";
    data['citizenship'] = "";
    data['address'] = address;
    data['file'] = null;
    data['postCode'] = postCode;
    data['jobDescription'] = "";
    data['isEmployed'] = isEmployed;
    data['employerName'] = employerName;
    data['employeAddress'] = employerAddress;
    data['marriageStatus'] = null;
    data['employerPhoneNumber'] = employerPhoneNumber;
    data['qualification'] = qualification;
    data['kindergartenId'] = kindergartenId;
    data['createdAt'] = createdAt;
    return data;
  }
}
