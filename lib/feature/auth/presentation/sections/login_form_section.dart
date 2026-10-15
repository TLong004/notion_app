import 'package:flutter/material.dart';
import 'package:notion_app/common/app_button.dart';
import 'package:notion_app/common/app_text_field.dart';

class LoginFormSection extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLoginPressed;
  final bool isLoading;

  const LoginFormSection({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onLoginPressed,
    this.isLoading = false,
  });

  @override
  State<LoginFormSection> createState() => _LoginFormSectionState();
}

class _LoginFormSectionState extends State<LoginFormSection> {
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 16,
        children: [
          AppTextField(
            label: 'Email',
            hintText: 'Enter your email',
            controller: widget.emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email_outlined),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Email is required';
              }
              if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                  .hasMatch(value!)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          AppTextField(
            label: 'Password',
            hintText: 'Enter your password',
            controller: widget.passwordController,
            obscureText: _obscurePassword,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Password is required';
              }
              if (value!.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          AppButton(
            text: 'Login',
            isLoading: widget.isLoading,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onLoginPressed();
              }
            },
          ),
        ],
      ),
    );
  }
}
