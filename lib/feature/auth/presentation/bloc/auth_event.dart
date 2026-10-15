import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;

  const RegisterEvent({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [username, email, password, confirmPassword];
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

class CheckSignInStatusEvent extends AuthEvent {
  const CheckSignInStatusEvent();
}

class SendOtpEvent extends AuthEvent {
  final String email;

  const SendOtpEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class VerifyOtpEvent extends AuthEvent {
  final String email;
  final String otpCode;

  const VerifyOtpEvent({
    required this.email,
    required this.otpCode,
  });

  @override
  List<Object?> get props => [email, otpCode];
}
