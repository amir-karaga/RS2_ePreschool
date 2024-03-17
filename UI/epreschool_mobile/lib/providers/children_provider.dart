import 'dart:convert';
import 'package:epreschool_mobile/models/apiResponse.dart';
import 'package:epreschool_mobile/models/child.dart';
import 'package:epreschool_mobile/providers/base_provider.dart';
import '../helpers/constants.dart';
import '../models/monthlyPayment.dart';
import '../utils/authorization.dart';
import 'package:http/http.dart' as http;

class ChildrenProvider extends BaseProvider<Child> {
  ChildrenProvider() : super('Children');

  List<Child> children = <Child>[];

  @override
  Future<List<Child>> get(Map<String, String>? params) async {
    children  = await super.get(params);
    return children;
  }

  @override
  Future<ApiResponse<Child>> getForPagination(Map<String, String>? params) async {
    return await super.getForPagination(params);
  }

  Future<ApiResponse<MonthlyPayment>> getMonthlyPayments(Map<String, String>? params) async {
    var uri = Uri.parse('$apiUrl/$endpoint/GetMonthlyPayments');
    if (params != null) {
      uri = uri.replace(queryParameters: params);
    }
    var headers = Authorization.createHeaders();

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<MonthlyPayment> items = data['items'].map<MonthlyPayment>((d) => fromJsonMonthlyPayment(d)).toList();
      int totalCount = data['totalCount'];
      return ApiResponse<MonthlyPayment>(items: items, totalCount: totalCount);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Child fromJson(data) {
    return Child.fromJson(data);
  }

  MonthlyPayment fromJsonMonthlyPayment(data){
    return MonthlyPayment.fromJson(data);
  }
}