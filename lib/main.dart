import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/route.dart';
import 'di/module.dart';
import 'firebase_options.dart';
import 'logic/auth/auth_cubit.dart';
import 'logic/firestore/firestore_cubit.dart';
import 'logic/notification/notification_cubit.dart';
import 'logic/notification/notification_handler.dart';
import 'logic/storage/storage_cubit.dart';
import 'util/bloc_observer.dart';
import 'util/firebase_message_service.dart';

Future<void> main() async {
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupDependencies();
  await FirebaseMessageService().setupFirebaseMessaging();
  // NotificationHandler.handleNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(create: (context) => getIt<AuthCubit>()),
          BlocProvider<StorageCubit>(
              create: (context) => getIt<StorageCubit>()),
          BlocProvider<FirestoreCubit>(
              create: (context) => getIt<FirestoreCubit>()),
          BlocProvider<NotificationCubit>(
              create: (context) => getIt<NotificationCubit>()),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialRoute: '/',
          routes: routes,
        ));
  }
}
