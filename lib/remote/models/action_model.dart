class ActionModel {
  List<String>? actions;

  ActionModel({this.actions});

  factory ActionModel.fromJson(Map<String, dynamic> json) {
    return ActionModel(
      actions: json['actions'] != null
          ? (json['actions'] as List).map((action) => action as String).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'actions': actions,
    };
  }
}
