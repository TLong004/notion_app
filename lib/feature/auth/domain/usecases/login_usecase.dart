import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:notion_app/core/error/failure.dart';
import 'package:notion_app/core/extensions/string_validator_extension.dart';
import 'package:notion_app/core/usecase/use_case.dart';
import 'package:notion_app/feature/auth/domain/entities/user_entity.dart';
import 'package:notion_app/feature/auth/domain/repositories/auth_repository.dart';

class AuthLoginUseCase implements UseCase<UserEntity, Params> {
  final AuthRepository repository;

  AuthLoginUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(Params params) async {
    if (!params.email.isEmailValid) {
      return Left(InvalidEmailFailure());
    }
    if (!params.password.isPasswordValid) {
      return Left(InvalidPasswordFailure());
    }
    return await repository.login(params);
  }
}

class Params extends Equatable {
  final String email;
  final String password;
  const Params({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [
        email,
        password,
      ];
}
