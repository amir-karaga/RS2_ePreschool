import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants{
  static String apiUrl = dotenv.env['API_URL']!;
  static String appTitle = 'ePreschool';
}


