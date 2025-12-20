import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lens/features/onboarding/presentation/cubit/auth_cubit.dart';
import 'package:lens/routing/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lens/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => AuthCubit()..checkAuthState(),
      child: ScreenUtilInit(
        designSize: const Size(384.0, 856.1777777777778),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp.router(
            routerConfig: appRouter,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'Inter'),
          );
        },
      ),
    );
  }
}
