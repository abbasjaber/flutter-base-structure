import 'history_details_model.dart';

class HistoryModel {
  String? employee;
  String? client;
  List<HistoryDetailsModel>? details;
  String? createdAt;
  String? updatedAt;
  List<String>? images;

  HistoryModel({
    this.employee,
    this.client,
    this.details,
    this.createdAt,
    this.updatedAt,
    this.images,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      employee: json['employee'],
      client: json['client'],
      details: json['details'] != null
          ? (json['details'] as List)
              .map((e) => HistoryDetailsModel.fromJson(e))
              .toList()
          : [],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      images: json['images'] != null
          ? (json['images'] as List).map((e) => e as String).toList()
          : [],
    );
  }
}
