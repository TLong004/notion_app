import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:notion_app/core/error/failure.dart';
import 'package:notion_app/core/usecase/use_case.dart';
import 'package:notion_app/feature/auth/domain/entities/user_entity.dart';
import 'package:notion_app/feature/auth/domain/repositories/auth_repository.dart';

class VerifyOtpUseCase implements UseCase<UserEntity, Params> {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(Params params) async {
    return await repository.verifyOtp(params);
  }
}

class Params extends Equatable {
  final String email;
  final String otpCode;

  const Params({required this.email, required this.otpCode});

  @override
  List<Object?> get props => [email, otpCode];
}
