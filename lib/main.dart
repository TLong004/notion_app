import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notion_app/core/di/service_locator.dart';
import 'package:notion_app/feature/auth/data/model/adapter/user_adapter_model.dart';
import 'package:notion_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:notion_app/feature/auth/presentation/bloc/auth_event.dart';
import 'package:notion_app/feature/auth/presentation/bloc/auth_state.dart' as auth_state;
import 'package:notion_app/feature/auth/presentation/pages/login_page.dart';
import 'package:notion_app/feature/auth/presentation/pages/otp_verification_page.dart';
import 'package:notion_app/feature/auth/presentation/pages/register_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');

  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    // ignore: deprecated_member_use
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = getIt<AuthBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authBloc.add(const CheckSignInStatusEvent());
    });
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>.value(
      value: _authBloc,
      child: BlocListener<AuthBloc, auth_state.AuthState>(
        listener: (context, state) {
          if (state is auth_state.AuthLoggedOut) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) => AlertDialog(
                title: const Text('Session Expired'),
                content: const Text('Your login session has expired. Please login again.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        LoginPage.routeName,
                        (route) => false,
                      );
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Notion App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          initialRoute: LoginPage.routeName,
          routes: {
            LoginPage.routeName: (context) => const LoginPage(),
            RegisterPage.routeName: (context) => const RegisterPage(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == OtpVerificationPage.routeName) {
              final email = settings.arguments as String;
              return MaterialPageRoute(
                builder: (context) => OtpVerificationPage(email: email),
              );
            }
            return null;
          },
        ),
      ),
    );
  }
}
