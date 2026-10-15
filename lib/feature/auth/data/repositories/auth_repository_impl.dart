import 'package:fpdart/src/either.dart';
import 'package:notion_app/core/cache/hive_local_storage.dart';
import 'package:notion_app/core/cache/secure_local_storage.dart';
import 'package:notion_app/core/error/exceptions.dart';
import 'package:notion_app/core/error/failure.dart';
import 'package:notion_app/feature/auth/data/datasources/auth_local_datasource.dart';
import 'package:notion_app/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:notion_app/feature/auth/data/model/login_model.dart';
import 'package:notion_app/feature/auth/data/model/register_model.dart';
import 'package:notion_app/feature/auth/domain/entities/user_entity.dart';
import 'package:notion_app/feature/auth/domain/repositories/auth_repository.dart';
import 'package:notion_app/feature/auth/domain/usecases/usecase_params.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;
  final SecureLocalStorage _secureLocalStorage;
  final HiveLocalStorage _localStorage;
  const AuthRepositoryImpl(
    this._authRemoteDataSource,
    this._authLocalDataSource,
    this._secureLocalStorage,
    this._localStorage,
  );
  @override
  Future<Either<Failure, UserEntity>> checkSignInStatus() async {
    try {
      final user = await _authLocalDataSource.checkSignInStatus();
      return Right(user);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login(LoginParams params) async {
    try {
      final model = LoginModel(
        email: params.email,
        password: params.password,
      );

      final result = await _authRemoteDataSource.login(model);

      return Right(result);
    } on AuthException {
      return Left(CredentialFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _authRemoteDataSource.logout();
      await _secureLocalStorage.delete(key: 'userId');
      await _localStorage.delete(key: 'user', boxName: 'cache');
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> register(RegisterParams params) async {
    try {
      final model = RegisterModel(
        username: params.username,
        email: params.email,
        password: params.password,
      );
      await _authRemoteDataSource.register(model);
      return const Right(null);
    } on DuplicateEmailException {
      return Left(DuplicateEmailFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> verifyOtp(VerifyOtpParams params) async {
    try {
      final result = await _authRemoteDataSource.verifyOtp(
        email: params.email,
        otpCode: params.otpCode,
      );

      await _saveUserSession(result);

      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<void> _saveUserSession(UserEntity user) async {
    await _secureLocalStorage.save(key: "user_id", value: user.userId);
    await _localStorage.save(key: "user", value: user, boxName: "cache");
  }
}