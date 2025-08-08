import 'dart:io';

class ReportModel {
  int? clientId;
  bool? sales;
  bool? socialization;
  bool? collection;
  List<File>? files;
  List<String>? images;

  ReportModel({
    this.clientId,
    this.sales,
    this.socialization,
    this.collection,
    this.files,
    this.images,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      clientId: json['client_id'],
      sales: json['sales'],
      socialization: json['socialization'],
      collection: json['collection'],
      files: json['files'] != null
          ? (json['files'] as List).map((file) => File(file)).toList()
          : [],
      images: json['images'] != null
          ? (json['images'] as List).map((image) => image as String).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client_id': clientId,
      'sales': sales,
      'socialization': socialization,
      'collection': collection,
      'images': images,
      'files': files,
    };
  }
}
