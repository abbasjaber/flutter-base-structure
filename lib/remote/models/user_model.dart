class UserModel {
  int? id;
  String? name;
  String? email;
  String? password;
  String? position;
  String? username;

  UserModel(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.position,
      this.username});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    position = json['position'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['position'] = position;
    data['username'] = username;
    data['confirm_password'] = password;
    return data;
  }
}
