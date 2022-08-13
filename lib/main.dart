import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_assignment/bloc/user_bloc/user_bloc.dart';
import 'package:test_assignment/models/user_model.dart';
import 'package:test_assignment/repositories/medication_repository.dart';
import 'package:test_assignment/repositories/user_repository.dart';
import 'package:test_assignment/services/medication_service.dart';
import 'package:test_assignment/services/user_service.dart';
import 'package:test_assignment/ui/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter<UserModel>(UserModelAdapter());
  await Hive.openBox<UserModel>('users_list');
  await Hive.openBox<UserModel>('logged_user');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Assignment',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          useMaterial3: true),
      builder: (context, child) => MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
              create: (context) => UserRepository(UserService())),
          RepositoryProvider(
              create: (context) => MedicationRepository(MedicationService())),
        ],
        child: BlocProvider(
                create: (context) => UserCubit(context.read<UserRepository>()),
          child: child!,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
