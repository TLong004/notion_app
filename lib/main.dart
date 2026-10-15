import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notion_app/core/di/service_locator.dart';
import 'package:notion_app/feature/auth/data/model/adapter/user_adapter_model.dart';
import 'package:notion_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:notion_app/feature/auth/presentation/pages/login_page.dart';
import 'package:notion_app/feature/auth/presentation/pages/otp_verification_page.dart';
import 'package:notion_app/feature/auth/presentation/pages/register_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Supabase.initialize(
    url: 'https://cbnmrnxtflyknxsvjwfm.supabase.co',
    // ignore: deprecated_member_use
    anonKey: 'sb_publishable_aIfcbDn31qPEfDh-ibY1ZQ_sUwIsLwq',
  );
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => getIt<AuthBloc>(),
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
    );
  }
}
