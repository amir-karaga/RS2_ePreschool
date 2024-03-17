import 'package:epreschool_mobile/models/base.dart';
import 'package:epreschool_mobile/models/country.dart';
import 'package:epreschool_mobile/models/parent.dart';

import 'employee.dart';

class EmployeeReview extends BaseModel{
  late String reviewComment;
  late int reviewRating;
  late int parentReviewerId;
  late Parent parentReviewer;
  late int employeeId;
  late Employee employee;

  EmployeeReview();

  EmployeeReview.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reviewComment = json['reviewComment'];
    reviewRating=json['reviewRating'];
    parentReviewerId=json['parentReviewerId'];
    employeeId = json['employeeId'];
    if (json['parentReviewer'] != null) {
      parentReviewer = Parent.fromJson(json['parentReviewer']);
    }
    if (json['employee'] != null) {
      employee = Employee.fromJson(json['employee']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['reviewComment'] = reviewComment;
    data['reviewRating'] = reviewRating;
    data['parentReviewerId'] = parentReviewerId;
    data['employeeId'] = employeeId;
    return data;
  }
}