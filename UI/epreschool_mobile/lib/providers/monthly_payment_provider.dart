import 'package:epreschool_mobile/models/apiResponse.dart';
import 'package:epreschool_mobile/models/monthlyPayment.dart';
import 'package:epreschool_mobile/providers/base_provider.dart';

class MonthlyPaymentProvider extends BaseProvider<MonthlyPayment> {
  MonthlyPaymentProvider() : super('MonthlyPayments');

  List<MonthlyPayment> payments = <MonthlyPayment>[];

  @override
  Future<List<MonthlyPayment>> get(Map<String, String>? params) async {
    payments = await super.get(params);
    return payments;
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