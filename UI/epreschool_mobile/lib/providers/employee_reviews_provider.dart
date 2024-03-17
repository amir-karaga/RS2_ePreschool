import '../models/apiResponse.dart';
import '../models/employee.dart';
import 'base_provider.dart';

class EmployeeReviewsProvider extends BaseProvider<Employee> {
  EmployeeReviewsProvider() : super('EmployeeReviews');

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