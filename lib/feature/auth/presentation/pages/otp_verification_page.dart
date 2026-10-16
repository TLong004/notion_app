import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notion_app/common/app_button.dart';
import 'package:notion_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:notion_app/feature/auth/presentation/bloc/auth_event.dart';
import 'package:notion_app/feature/auth/presentation/bloc/auth_state.dart';

class OtpVerificationPage extends StatefulWidget {
  static const routeName = '/otp-verification';
  final String email;

  const OtpVerificationPage({super.key, required this.email});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  static const int _otpLength = 8;
  static const int _resendSeconds = 60;

  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  Timer? _timer;
  int _resendCountdown = 0;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (_) => FocusNode());
    _startResendCountdown(); 
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _focusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _startResendCountdown() {
    _timer?.cancel();
    setState(() => _resendCountdown = _resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_resendCountdown <= 1) {
        t.cancel();
        setState(() => _resendCountdown = 0);
      } else {
        setState(() => _resendCountdown--);
      }
    });
  }

  void _handleOtpInput(String value, int index) {
    final digits = value.replaceAll(RegExp(r'\D'), '');

    if (digits.isEmpty) {
      _controllers[index].clear();
      if (index > 0) _focusNodes[index - 1].requestFocus();
      return;
    }

    var last = index;
    for (var i = 0; i < digits.length && index + i < _otpLength; i++) {
      _controllers[index + i].text = digits[i];
      last = index + i;
    }

    if (last < _otpLength - 1) {
      _focusNodes[last + 1].requestFocus();
    } else {
      _focusNodes[last].unfocus();
    }
  }

  String _getOtpCode() => _controllers.map((c) => c.text).join();

  void _clearFields() {
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes.first.requestFocus();
  }

  void _handleVerifyOtp() {
    final otpCode = _getOtpCode();
    if (otpCode.length < _otpLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập đủ $_otpLength chữ số')),
      );
      return;
    }

    context.read<AuthBloc>().add(
          VerifyOtpEvent(email: widget.email, otpCode: otpCode),
        );
  }

  void _handleResendOtp() {
    if (_resendCountdown == 0) {
      context.read<AuthBloc>().add(SendOtpEvent(email: widget.email));
    }
  }

  @override
  Widget build(BuildContext context) {
    final canResend = _resendCountdown == 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Xác thực OTP')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/home',
              (route) => false,
            );
          } else if (state is OtpSent) {
            _startResendCountdown();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Mã OTP mới đã được gửi'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is AuthFailure) {
            _clearFields();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Xác thực OTP',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Nhập mã đã được gửi đến\n${widget.email}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 48),
                Row(
                  children: [
                    for (var i = 0; i < _otpLength; i++) ...[
                      if (i > 0) const SizedBox(width: 6),
                      Expanded(child: _buildOtpBox(i)),
                    ],
                  ],
                ),
                const SizedBox(height: 32),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) => AppButton(
                    text: 'Xác thực',
                    isLoading: state is AuthLoading,
                    onPressed: _handleVerifyOtp,
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: canResend ? _handleResendOtp : null,
                  child: Text(
                    canResend
                        ? 'Gửi lại mã OTP'
                        : 'Gửi lại mã OTP sau ${_resendCountdown}s',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: canResend
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.grey, width: 2),
    );

    return SizedBox(
      height: 56,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: _otpLength,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) => _handleOtpInput(value, index),
        style: Theme.of(context).textTheme.titleLarge,
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          border: border,
          enabledBorder: border,
          focusedBorder: border.copyWith(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}