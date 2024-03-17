
import 'package:epreschool_admin/models/parent.dart';

import 'base.dart';
import 'child.dart';

class MonthlyPayment extends BaseModel {
  late bool isPaid;
  late int month;
  late int year;
  late int parentId;
  late Parent? parent;
  late int childId;
  late Child? child;
  late int price;
  late int discount;
  late String note;
  late int status;

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
    price = json['price'];
    discount = json['discount'];
    note = json['note'] ?? '';
    status = json['status'] ?? 0;
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
    data['status'] = status;
    return data;
  }
}