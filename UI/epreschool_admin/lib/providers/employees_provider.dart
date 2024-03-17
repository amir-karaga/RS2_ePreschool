import 'package:epreschool_admin/models/apiResponse.dart';
import 'package:epreschool_admin/models/employee.dart';
import 'package:epreschool_admin/providers/base_provider.dart';

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

  @override
  Employee fromJson(data) {
    return Employee.fromJson(data);
  }
}