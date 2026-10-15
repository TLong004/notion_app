import 'package:flutter/material.dart';
import 'package:notion_app/common/app_button.dart';
import 'package:notion_app/common/app_text_field.dart';

class RegisterFormSection extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onRegisterPressed;
  final bool isLoading;

  const RegisterFormSection({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onRegisterPressed,
    this.isLoading = false,
  });

  @override
  State<RegisterFormSection> createState() => _RegisterFormSectionState();
}

class _RegisterFormSectionState extends State<RegisterFormSection> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 16,
        children: [
          AppTextField(
            label: 'Full Name',
            hintText: 'Enter your full name',
            controller: widget.nameController,
            prefixIcon: const Icon(Icons.person_outline),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Name is required';
              }
              if (value!.length < 2) {
                return 'Name must be at least 2 characters';
              }
              return null;
            },
          ),
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
          AppTextField(
            label: 'Confirm Password',
            hintText: 'Confirm your password',
            controller: widget.confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Confirm password is required';
              }
              if (value != widget.passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          AppButton(
            text: 'Register',
            isLoading: widget.isLoading,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onRegisterPressed();
              }
            },
          ),
        ],
      ),
    );
  }
}
