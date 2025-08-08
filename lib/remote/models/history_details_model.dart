class HistoryDetailsModel {
  String? note;
  String? action;
  String? createdAt;
  String? updatedAt;

  HistoryDetailsModel({
    this.note,
    this.action,
    this.createdAt,
    this.updatedAt,
  });

  factory HistoryDetailsModel.fromJson(Map<String, dynamic> json) {
    return HistoryDetailsModel(
      note: json['note'],
      action: json['action'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
