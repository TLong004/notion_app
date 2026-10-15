import 'package:notion_app/feature/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required String userId,
    required String email,
    required String username,
  }) : super(
          userId: userId,
          email: email,
          username: username,
        );

  factory UserModel.fromJson(Map<String, dynamic> json, String userId) {
    return UserModel(
      userId: userId,
      email: json["email"],
      username: json["username"],
    );
  }
}