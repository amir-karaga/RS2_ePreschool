import 'package:epreschool_mobile/models/listItem.dart';

import '../helpers/constants.dart';
import '../models/apiResponse.dart';
import '../models/employee.dart';
import '../utils/authorization.dart';
import 'base_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmployeesProvider extends BaseProvider<Employee> {
  EmployeesProvider() : super('Employees');

  List<Employee> employees = <Employee>[];

  @override
  Future<List<Employee>> get(Map<String, String>? params) async {
    employees  = await super.get(params);
    return employees;
  }

  @override
  Future<ApiResponse<Employee>> getForPagination(Map<String, String>? params) async {
    return await super.getForPagination(params);
  }

  Future<List<ListItem>> getRecommendedEmployees(String companyId, String parentReviewerId) async {
    print("uri");

    var uri = Uri.parse('$apiUrl/Employees/RecommendByCompanyIdAndParentReviewerId/$companyId/$parentReviewerId');

    print(uri);
    var headers = Authorization.createHeaders();

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      return data.map((d) => ListItem.fromJson(d)).cast<ListItem>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Employee fromJson(data) {
    return Employee.fromJson(data);
  }
}