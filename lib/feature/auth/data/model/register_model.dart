class RegisterModel {  
  final String email;
  final String username;
  final String password;
  
  const RegisterModel({
    required this.email,
    required this.username,
    required this.password,
  });

  RegisterModel copyWith({
    String? email,
    String? username,
    String? password,
  }) {
    return RegisterModel(
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toJson() {
    return {"email": email, "username": username, "password": password};
  }
}
