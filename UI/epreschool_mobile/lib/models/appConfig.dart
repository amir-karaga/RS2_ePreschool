
import 'base.dart';

class AppConfig extends BaseModel {
  late double monthlyFee;

  AppConfig();

  AppConfig.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dynamic priceData = json['monthlyFee'];
    if (priceData is int) {
      monthlyFee = priceData.toDouble();
    } else if (priceData is double) {
      monthlyFee = priceData;
    } else if (priceData is String) {
      monthlyFee = double.tryParse(priceData) ?? 0.0;
    } else {
      monthlyFee = 0.0;
    }
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['monthlyFee'] = monthlyFee;
    data['createdAt'] = createdAt;
    return data;
  }
}