import 'package:logger/logger.dart';
import 'package:notion_app/core/error/exceptions.dart';
import 'package:notion_app/feature/auth/data/model/login_model.dart';
import 'package:notion_app/feature/auth/data/model/register_model.dart';
import 'package:notion_app/feature/auth/data/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _logger = Logger();

sealed class AuthRemoteDataSource {
  Future<UserModel> login(LoginModel model);
  Future<void> logout();
  Future<UserModel> register(RegisterModel model);
  Future<void> sendOtp(String email);
  Future<UserModel> verifyOtp({required String email, required String otpCode});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _supabaseClient;

  const AuthRemoteDataSourceImpl(this._supabaseClient);
  @override
  Future<UserModel> login(LoginModel model) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: model.email,
        password: model.password,
      );

      if (response.user == null) {
        throw EmptyException();
      }

      final user = await _getUserByEmail(model.email);
      return user;
    } on EmptyException {
      rethrow;
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> register(RegisterModel model) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: model.email,
        password: model.password,
      );

      if (response.user == null) {
        throw EmptyException();
      }

      await _supabaseClient.from('users').insert({
        'id': response.user!.id,
        'email': model.email,
        'username': model.username,
      });

      return await _getUserByEmail(model.email);
    } on EmptyException {
      rethrow;
    } catch (e) {
      _logger.e('Register error: $e');
      throw ServerException();
    }
  }

  @override
  Future<UserModel> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    try {
      final response = await _supabaseClient.auth.verifyOTP(
        email: email,
        token: otpCode,
        type: OtpType.email,
      );

      if (response.user == null) {
        throw EmptyException();
      }

      final user = await _getUserByEmail(email);
      return user;
    } on EmptyException {
      rethrow;
    } catch (e) {
      _logger.e('Verify OTP error: $e');
      if (e.toString().contains('OTP') || e.toString().contains('token') || e.toString().contains('expired')) {
        throw InvalidOtpException();
      }
      throw ServerException();
    }
  }

  @override
  Future<void> sendOtp(String email) async {
    try {
      await _supabaseClient.auth.signInWithOtp(
        email: email,
        shouldCreateUser: false,
      );
    } catch (e) {
      _logger.e('Send OTP error: $e');
      throw ServerException();
    }
  }

  Future<UserModel> _getUserByEmail(String email) async {
    try {
      final response = await _supabaseClient
          .from('users')
          .select()
          .eq('email', email)
          .maybeSingle();

      if (response == null) {
        throw EmptyException();
      }

      final user = UserModel.fromJson(response, response['id'] as String);
      return user;
    } on EmptyException {
      rethrow;
    } catch (e) {
      throw ServerException();
    }
  }
}
