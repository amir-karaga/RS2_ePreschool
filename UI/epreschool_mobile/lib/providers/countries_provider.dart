import 'package:epreschool_mobile/models/apiResponse.dart';
import 'package:epreschool_mobile/models/country.dart';
import 'package:epreschool_mobile/providers/base_provider.dart';

class CountryProvider extends BaseProvider<Country> {
  CountryProvider() : super('Countries');

  List<Country> countries = <Country>[];

  @override
  Future<List<Country>> get(Map<String, String>? params) async {
    countries = await super.get(params);

    return countries;
  }

  @override
  Future<ApiResponse<Country>> getForPagination(Map<String, String>? params) async {
    return await super.getForPagination(params);
  }

  @override
  Country fromJson(data) {
    return Country.fromJson(data);
  }
}