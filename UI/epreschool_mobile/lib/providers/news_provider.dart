import 'package:epreschool_mobile/models/new.dart';

import '../models/apiResponse.dart';
import '../models/parent.dart';
import 'base_provider.dart';

class NewsProvider extends BaseProvider<New> {
  NewsProvider() : super('News');

  List<New> news = <New>[];

  @override
  Future<List<New>> get(Map<String, String>? params) async {
    news  = await super.get(params);
    return news;
  }

  @override
  Future<ApiResponse<New>> getForPagination(Map<String, String>? params) async {
    return await super.getForPagination(params);
  }

  @override
  New fromJson(data) {
    return New.fromJson(data);
  }
}