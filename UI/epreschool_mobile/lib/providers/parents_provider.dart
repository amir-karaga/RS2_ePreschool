import '../models/apiResponse.dart';
import '../models/parent.dart';
import 'base_provider.dart';

class ParentsProvider extends BaseProvider<Parent> {
  ParentsProvider() : super('Parents');

  List<Parent> parents = <Parent>[];

  @override
  Future<List<Parent>> get(Map<String, String>? params) async {
    parents  = await super.get(params);
    return parents;
  }

  @override
  Future<ApiResponse<Parent>> getForPagination(Map<String, String>? params) async {
    return await super.getForPagination(params);
  }

  @override
  Parent fromJson(data) {
    return Parent.fromJson(data);
  }
}