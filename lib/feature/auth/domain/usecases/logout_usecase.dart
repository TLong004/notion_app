import 'package:fpdart/fpdart.dart';
import 'package:notion_app/core/error/failure.dart';
import 'package:notion_app/core/usecase/use_case.dart';

import '../repositories/auth_repository.dart';

class AuthLogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository _authRepository;
  const AuthLogoutUseCase(this._authRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await _authRepository.logout();
  }
}