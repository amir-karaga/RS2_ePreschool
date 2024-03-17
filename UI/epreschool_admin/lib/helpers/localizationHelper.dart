import 'package:flutter_translate/flutter_translate.dart';

import '../models/language.dart';

class LocalizationHelper {
  static List<Language> getSupportedLanguages() {
    return [
      Language(languageCode: 'ba_BA', name: translate("languages.bs")),
      Language(languageCode: 'en_US', name: translate("languages.en")),
    ];
  }
}