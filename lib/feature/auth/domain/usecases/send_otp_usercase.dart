import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:notion_app/core/error/failure.dart';
import 'package:notion_app/core/usecase/use_case.dart';
import 'package:notion_app/feature/auth/domain/repositories/auth_repository.dart';

final _logger = Logger();

class SendOtpUseCase implements UseCase<void, String> {
  final AuthRepository _authRepository;

  SendOtpUseCase(this._authRepository);

  @override
  Future<Either<Failure, void>> call(String email) async {
    _logger.i('📧 Sending OTP to $email');
    return await _authRepository.sendOtp(email);
  }
}
