import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:notion_app/core/cache/hive_local_storage.dart';
import 'package:notion_app/core/cache/secure_local_storage.dart';
import 'package:notion_app/feature/auth/data/datasources/auth_local_datasource.dart';
import 'package:notion_app/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:notion_app/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:notion_app/feature/auth/domain/repositories/auth_repository.dart';
import 'package:notion_app/feature/auth/domain/usecases/check_signin_status_usecase.dart';
import 'package:notion_app/feature/auth/domain/usecases/login_usecase.dart';
import 'package:notion_app/feature/auth/domain/usecases/logout_usecase.dart';
import 'package:notion_app/feature/auth/domain/usecases/register_usecase.dart';
import 'package:notion_app/feature/auth/domain/usecases/send_otp_usercase.dart';
import 'package:notion_app/feature/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:notion_app/feature/auth/presentation/bloc/auth_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // External
  final supabaseClient = Supabase.instance.client;

  // Cache
  getIt.registerSingleton<HiveLocalStorage>(
    HiveLocalStorage(),
  );
  getIt.registerSingleton<SecureLocalStorage>(
    SecureLocalStorage(const FlutterSecureStorage()),
  );

  // Data sources
  getIt.registerSingleton<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl(supabaseClient),
  );
  getIt.registerSingleton<AuthLocalDataSource>(
    AuthLocalDataSourceImpl(
      getIt<SecureLocalStorage>(),
      getIt<HiveLocalStorage>(),
    ),
  );

  // Repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      getIt<AuthLocalDataSource>(),
      getIt<SecureLocalStorage>(),
      getIt<HiveLocalStorage>(),
    ),
  );

  // Use cases
  getIt.registerSingleton<AuthLoginUseCase>(
    AuthLoginUseCase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<AuthRegisterUseCase>(
    AuthRegisterUseCase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<AuthLogoutUseCase>(
    AuthLogoutUseCase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<AuthCheckSignInStatusUseCase>(
    AuthCheckSignInStatusUseCase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<SendOtpUseCase>(
    SendOtpUseCase(),
  );
  getIt.registerSingleton<VerifyOtpUseCase>(
    VerifyOtpUseCase(getIt<AuthRepository>()),
  );

  // BLoCs
  getIt.registerSingleton<AuthBloc>(
    AuthBloc(
      loginUseCase: getIt<AuthLoginUseCase>(),
      registerUseCase: getIt<AuthRegisterUseCase>(),
      logoutUseCase: getIt<AuthLogoutUseCase>(),
      checkSignInStatusUseCase: getIt<AuthCheckSignInStatusUseCase>(),
      sendOtpUseCase: getIt<SendOtpUseCase>(),
      verifyOtpUseCase: getIt<VerifyOtpUseCase>(),
    ),
  );
}
