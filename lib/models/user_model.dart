import 'package:hive_flutter/hive_flutter.dart';
part 'user_model.g.dart';


@HiveType(typeId: 0)
class UserModel extends HiveObject{
  @HiveField(0)
  String? username;
  @HiveField(1)
  String? password;

  UserModel({this.username, this.password});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json["username"],
      password: json["password"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
    };
  }

  UserModel clone() {
    return UserModel(username: username, password: password);
  }
}