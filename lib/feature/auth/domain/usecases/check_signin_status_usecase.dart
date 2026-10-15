import 'package:fpdart/fpdart.dart';
import 'package:notion_app/core/error/failure.dart';
import 'package:notion_app/core/usecase/use_case.dart';
import 'package:notion_app/feature/auth/domain/entities/user_entity.dart';

import '../repositories/auth_repository.dart';

class AuthCheckSignInStatusUseCase implements UseCase<UserEntity, NoParams> {
  final AuthRepository _authRepository;
  const AuthCheckSignInStatusUseCase(this._authRepository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await _authRepository.checkSignInStatus();
  }
}