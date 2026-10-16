import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notion_app/core/error/failure.dart';
import 'package:notion_app/core/usecase/use_case.dart';
import 'package:notion_app/feature/auth/domain/usecases/check_signin_status_usecase.dart';
import 'package:notion_app/feature/auth/domain/usecases/logout_usecase.dart';
import 'package:notion_app/feature/auth/domain/usecases/register_usecase.dart';
import 'package:notion_app/feature/auth/domain/usecases/send_otp_usercase.dart';
import 'package:notion_app/feature/auth/domain/usecases/usecase_params.dart';
import 'package:notion_app/feature/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:notion_app/feature/auth/presentation/bloc/auth_event.dart';
import 'package:notion_app/feature/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRegisterUseCase _registerUseCase;
  final AuthLogoutUseCase _logoutUseCase;
  final AuthCheckSignInStatusUseCase _checkSignInStatusUseCase;
  final SendOtpUseCase _sendOtpUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;

  AuthBloc({
    required AuthRegisterUseCase registerUseCase,
    required AuthLogoutUseCase logoutUseCase,
    required AuthCheckSignInStatusUseCase checkSignInStatusUseCase,
    required SendOtpUseCase sendOtpUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
  })  : _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _checkSignInStatusUseCase = checkSignInStatusUseCase,
        _sendOtpUseCase = sendOtpUseCase,
        _verifyOtpUseCase = verifyOtpUseCase,
        super(const AuthInitial()) {
    on<RegisterEvent>(_onRegisterEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<CheckSignInStatusEvent>(_onCheckSignInStatusEvent);
    on<SendOtpEvent>(_onSendOtpEvent);
    on<VerifyOtpEvent>(_onVerifyOtpEvent);
  }

  Future<void> _onRegisterEvent(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _registerUseCase(
      RegisterParams(
        username: event.username,
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword,
      ),
    );
    result.fold(
      (failure) => emit(AuthFailure(_getFailureMessage(failure))),
      (_) => emit(const AuthSuccess()),
    );
  }

  Future<void> _onLogoutEvent(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _logoutUseCase(NoParams());
    result.fold(
      (failure) => emit(AuthFailure(_getFailureMessage(failure))),
      (_) => emit(const AuthLoggedOut()),
    );
  }

  Future<void> _onCheckSignInStatusEvent(
    CheckSignInStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _checkSignInStatusUseCase(NoParams());
    result.fold(
      (failure) {
        if (failure is CacheFailure) {
          emit(const AuthLoggedOut());
        } else {
          emit(AuthFailure(_getFailureMessage(failure)));
        }
      },
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> _onSendOtpEvent(
    SendOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _sendOtpUseCase(event.email);
    result.fold(
      (failure) => emit(AuthFailure('Không thể gửi OTP. Vui lòng thử lại')),
      (_) {
        emit(OtpSent(event.email));
      },
    );
  }

  Future<void> _onVerifyOtpEvent(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _verifyOtpUseCase(
      VerifyOtpParams(email: event.email, otpCode: event.otpCode),
    );
    result.fold(
      (failure) => emit(AuthFailure(_getFailureMessage(failure))),
      (user) => emit(AuthSuccess(user)),
    );
  }

  String _getFailureMessage(Failure failure) {
    return switch (failure) {
      InvalidEmailFailure() => 'Email không hợp lệ',
      InvalidPasswordFailure() => 'Mật khẩu phải có ít nhất 6 ký tự',
      PasswordNotMatchFailure() => 'Mật khẩu không khớp',
      CredentialFailure() => 'Email hoặc mật khẩu không đúng',
      DuplicateEmailFailure() => 'Email đã được sử dụng',
      ServerFailure() => 'Lỗi máy chủ, vui lòng thử lại',
      CacheFailure() => 'Lỗi lưu trữ, vui lòng thử lại',
      EmptyFailure() => 'Dữ liệu trống, vui lòng thử lại',
      InvalidOtpFailure() => 'Mã không đúng hoặc đã hết hạn. Vui lòng nhập lại hoặc gửi mã mới',
    };
  }
}
