import 'dart:convert';
import 'package:epreschool_admin/models/listItem.dart';
import 'package:epreschool_admin/providers/base_provider.dart';
import '../utils/authorization.dart';
import 'package:http/http.dart' as http;

class EnumProvider extends BaseProvider<ListItem> {
  EnumProvider() : super('Enum');

  List<ListItem> data = <ListItem>[];

  Future<List<ListItem>> getEnumItems(String url) async {
    var uri = Uri.parse('$apiUrl/Enum/$url');

    var headers = Authorization.createHeaders();

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      return data.map((d) => fromJson(d)).cast<ListItem>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  ListItem fromJson(data) {
    return ListItem.fromJson(data);
  }
}