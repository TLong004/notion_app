import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:notion_app/core/error/failure.dart';
import 'package:notion_app/core/usecase/use_case.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _logger = Logger();

class SendOtpUseCase implements UseCase<void, String> {
  @override
  Future<Either<Failure, void>> call(String email) async {
    try {
      final otp = (100000 + (DateTime.now().millisecondsSinceEpoch % 900000)).toString();

      await Supabase.instance.client.from('otp_codes').insert({
        'email': email,
        'otp_code': otp,
        'expires_at': DateTime.now().add(Duration(minutes: 10)).toIso8601String(),
        'used': false,
      });

      _logger.i('📧 OTP Code: $otp (expires in 10 minutes)');

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
