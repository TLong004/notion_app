import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notion_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:notion_app/feature/auth/presentation/bloc/auth_event.dart';
import 'package:notion_app/feature/auth/presentation/bloc/auth_state.dart';
import 'package:notion_app/feature/auth/presentation/sections/sections.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = '/register';

  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    context.read<AuthBloc>().add(
      RegisterEvent(
        username: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đăng ký thành công! Vui lòng đăng nhập'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 32,
              children: [
                const AuthHeaderSection(
                  title: 'Create Account',
                  subtitle: 'Join us and start using Notion App',
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return RegisterFormSection(
                      nameController: _nameController,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      isLoading: state is AuthLoading,
                      onRegisterPressed: _handleRegister,
                    );
                  },
                ),
                AuthFooterSection(
                  text: 'Already have an account?',
                  actionText: 'Login',
                  onActionPressed: _navigateToLogin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
