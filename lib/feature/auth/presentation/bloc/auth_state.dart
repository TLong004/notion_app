import 'package:equatable/equatable.dart';
import 'package:notion_app/feature/auth/domain/entities/user_entity.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final UserEntity? user;

  const AuthSuccess([this.user]);

  @override
  List<Object?> get props => [user];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthLoggedOut extends AuthState {
  const AuthLoggedOut();
}

class OtpSent extends AuthState {
  final String email;

  const OtpSent(this.email);

  @override
  List<Object?> get props => [email];
}
