import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notion_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:notion_app/feature/auth/presentation/bloc/auth_event.dart';
import 'package:notion_app/feature/auth/presentation/bloc/auth_state.dart';
import 'package:notion_app/feature/auth/presentation/sections/sections.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập email')),
      );
      return;
    }
    context.read<AuthBloc>().add(
      SendOtpEvent(email: _emailController.text),
    );
  }

  void _navigateToRegister() {
    Navigator.of(context).pushNamed('/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/home',
              (route) => false,
            );
          } else if (state is OtpSent) {
            Navigator.of(context).pushNamed(
              '/otp-verification',
              arguments: state.email,
            );
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
                  title: 'Welcome Back',
                  subtitle: 'Login to your account to continue',
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return LoginFormSection(
                      emailController: _emailController,
                      passwordController: _passwordController,
                      isLoading: state is AuthLoading,
                      onLoginPressed: _handleLogin,
                    );
                  },
                ),
                AuthFooterSection(
                  text: 'Don\'t have an account?',
                  actionText: 'Register',
                  onActionPressed: _navigateToRegister,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
