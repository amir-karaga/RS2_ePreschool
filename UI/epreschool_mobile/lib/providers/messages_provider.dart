import 'package:epreschool_mobile/models/apiResponse.dart';
import 'package:epreschool_mobile/providers/base_provider.dart';
import '../models/message.dart';

class MessagesProvider extends BaseProvider<Message> {
  MessagesProvider() : super('Messages');

  List<Message> messages = <Message>[];

  @override
  Future<List<Message>> get(Map<String, String>? params) async {
    messages = await super.get(params);

    return messages;
  }

  @override
  Future<ApiResponse<Message>> getForPagination(Map<String, String>? params) async {
    return await super.getForPagination(params);
  }

  @override
  Message fromJson(data) {
    return Message.fromJson(data);
  }
}