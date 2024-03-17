import 'package:epreschool_mobile/models/base.dart';
import 'package:epreschool_mobile/models/parent.dart';

import 'child.dart';

class MonthlyPayment extends BaseModel {
  late bool isPaid;
  late int month;
  late int year;
  late int parentId;
  late Parent? parent;
  late int childId;
  late Child? child;
  late double price;
  late int discount;
  late String note;
  late int statusPayment;

MonthlyPayment();

MonthlyPayment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isPaid = json['isPaid'];
    month=json['month'];
    year=json['year'];
    parentId = json['parentId'];
    if (json['parent'] != null) {
      parent = Parent.fromJson(json['parent']);
    }
    childId = json['childId'];
    if (json['child'] != null) {
      child = Child.fromJson(json['child']);
    }
    dynamic priceData = json['price'];
    if (priceData is int) {
      price = priceData.toDouble();
    } else if (priceData is double) {
      price = priceData;
    } else if (priceData is String) {
      price = double.tryParse(priceData) ?? 0.0;
    } else {
      price = 0.0;
    }
    discount = json['discount'];
    note = json['note'] ?? '';
    statusPayment = json['statusPayment'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['isPaid'] = isPaid;
    data['month'] = month;
    data['year'] = year;
    data['parentId'] = parentId;
    data['childId'] = childId;
    data['price'] = price;
    data['discount'] = discount;
    data['note'] = note;
    data['statusPayment'] = statusPayment;
    return data;
  }
}