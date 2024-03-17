import 'city.dart';

class Company {
  late int id;
  late bool isActive;
  late String createdAt;
  late String name;
  late String identificationNumber;
  late String address;
  late City? location;
  late int locationId;
  late String phoneNumber;
  late String email;
  late double rating;

  Company({required this.id, required this.name});

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    name = json['name'];
    address = json['address'];
    phoneNumber = json['phoneNumber'];
    identificationNumber = json['identificationNumber'];
    email = json['email'];
    if (json['rating'] != null) {
      rating = double.tryParse(json['rating'].toString()) ?? 0.0;
    } else {
      rating = 0.0;
    }
    locationId = json['locationId'];
    if (json['location'] != null) {
      location = City.fromJson(json['location']);
    }
    else{
      location = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['isActive'] = isActive;
    data['name'] = name;
    data['address'] = address;
    data['locationId'] = locationId;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    data['identificationNumber'] = identificationNumber;
    return data;
  }
}