class LoginModel { 
  final String email;
  final String password;
  
  const LoginModel({
    required this.email,
    required this.password,
  });

  LoginModel copyWith({String? email, String? password}) {
    return LoginModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}