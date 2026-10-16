import 'package:notion_app/core/cache/hive_local_storage.dart';
import 'package:notion_app/core/cache/secure_local_storage.dart';
import 'package:notion_app/core/error/exceptions.dart';
import 'package:notion_app/feature/auth/domain/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

sealed class AuthLocalDataSource {
  Future<UserEntity> checkSignInStatus();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureLocalStorage _secureLocalStorage;
  final HiveLocalStorage _localStorage;
  final SupabaseClient _supabaseClient;
  const AuthLocalDataSourceImpl(
    this._secureLocalStorage,
    this._localStorage,
    this._supabaseClient,
  );
  @override
  Future<UserEntity> checkSignInStatus() async {
    try {
      final supabaseUser = _supabaseClient.auth.currentUser;
      if (supabaseUser == null) {
        throw CacheException();
      }

      final userId = await _secureLocalStorage.load(key: 'user_id');
      final result = await _localStorage.load(key: 'user', boxName: 'cache');

      if (result != null && userId.isNotEmpty) {
        if (result is UserEntity) {
          return result;
        }
      }

      throw CacheException();
    } catch (_) {
      throw CacheException();
    }
  }
}