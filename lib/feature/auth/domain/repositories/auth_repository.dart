import 'package:fpdart/fpdart.dart';
import 'package:notion_app/core/error/failure.dart';
import 'package:notion_app/feature/auth/domain/entities/user_entity.dart';

import '../usecases/usecase_params.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> register(RegisterParams params);
  Future<Either<Failure, void>> sendOtp(String email);
  Future<Either<Failure, UserEntity>> checkSignInStatus();
  Future<Either<Failure, UserEntity>> verifyOtp(VerifyOtpParams params);
}