import 'package:epreschool_mobile/models/appUser.dart';
import 'package:intl/intl.dart';
import '../helpers/constants.dart';

class Person extends AppUser {
  late String firstName;
  late String lastName;
  late int? gender;
  late String? profilePhoto;
  late int? birthPlaceId;
  late String? birthDate;
  late String? JMBG;
  late int? placeOfResidenceId;
  late String? nationality;
  late String? citizenship;
  late String? address;
  late String? postCode;
  late AppUser? appUser;
  late String? imageUrl;
  Person();

  Person.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    gender = json['gender'];
    String? profilePhotoUrl = json['profilePhoto'];
    if(profilePhotoUrl != null) {
      imageUrl = json['profilePhoto'];
      profilePhoto = Constants.apiUrl + profilePhotoUrl;
    }else{
      imageUrl = "";
      profilePhoto = "";
    }
    birthDate =
        DateFormat('dd.MM.yyyy').format(DateTime.parse(json['birthDate']));
    placeOfResidenceId = json['placeOfResidenceId'];
    birthPlaceId = json['birthPlaceId'];
    nationality = json['nationality'];
    citizenship = json['citizenship'];
    address = json['address'];
    postCode = json['postCode'];
    JMBG = json['jmbg'];
    createdAt = json['createdAt'];
    if (json['applicationUser'] != null) {
      appUser = AppUser.fromJson(json['applicationUser']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['gender'] = gender;
    data['profilePhoto'] = profilePhoto;
    data['birthDate'] = birthDate;
    data['placeOfResidenceId'] = placeOfResidenceId;
    data['birthPlaceId'] = birthPlaceId;
    data['nationality'] = nationality;
    data['citizenship'] = citizenship;
    data['address'] = address;
    data['postCode'] = postCode;
    data['JMBG'] = JMBG;
    return data;
  }
}
