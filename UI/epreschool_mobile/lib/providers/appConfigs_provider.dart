import '../models/appConfig.dart';
import 'base_provider.dart';

class AppConfigsProvider extends BaseProvider<AppConfig> {
  AppConfigsProvider() : super('AppConfigs');

  @override
  AppConfig fromJson(data) {
    return AppConfig.fromJson(data);
  }
}