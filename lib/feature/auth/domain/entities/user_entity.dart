import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String? username;
  final String? email;
  const UserEntity({
    this.userId,
    this.username,
    this.email,
  });

  @override
  List<Object?> get props => [
        userId,
        username,
        email,
      ];
}