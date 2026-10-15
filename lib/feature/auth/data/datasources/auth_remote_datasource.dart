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
      final otpResponse = await _supabaseClient
          .from('otp_codes')
          .select()
          .eq('email', email)
          .eq('otp_code', otpCode)
          .eq('used', false)
          .single();

      final expiresAt = DateTime.parse(otpResponse['expires_at'] as String);
      if (DateTime.now().isAfter(expiresAt)) {
        throw ServerException();
      }

      await _supabaseClient
          .from('otp_codes')
          .update({'used': true})
          .eq('id', otpResponse['id']);

      final user = await _getUserByEmail(email);
      return user;
    } catch (e) {
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
