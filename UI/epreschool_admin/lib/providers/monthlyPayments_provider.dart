import 'package:epreschool_admin/models/apiResponse.dart';
import 'package:epreschool_admin/models/monthlyPayment.dart';
import 'package:epreschool_admin/providers/base_provider.dart';

class MonthlyPaymentProvider extends BaseProvider<MonthlyPayment> {
  MonthlyPaymentProvider() : super('MonthlyPayments');

  List<MonthlyPayment> monthlyPayments = <MonthlyPayment>[];

  @override
  Future<List<MonthlyPayment>> get(Map<String, String>? params) async {
    monthlyPayments = await super.get(params);
    return monthlyPayments;
  }

  @override
  Future<ApiResponse<MonthlyPayment>> getForPagination(Map<String, String>? params) async {
     return await super.getForPagination(params);
  }

  @override
  MonthlyPayment fromJson(data) {
    return MonthlyPayment.fromJson(data);
  }
}