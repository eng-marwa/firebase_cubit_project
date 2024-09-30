import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cubit_project/logic/notification/notification_cubit.dart';
import 'package:firebase_cubit_project/logic/storage/storage_cubit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

import '../logic/auth/auth_cubit.dart';
import '../logic/firestore/firestore_cubit.dart';

GetIt getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  getIt.registerLazySingleton<AuthCubit>(
    () => AuthCubit(getIt()),
  );

  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  getIt.registerLazySingleton<FirestoreCubit>(
    () => FirestoreCubit(getIt()),
  );

  getIt.registerLazySingleton<StorageCubit>(
    () => StorageCubit(),
  );

  getIt.registerSingleton<FirebaseStorage>(FirebaseStorage.instance);
  getIt.registerLazySingleton<Reference>(
    () => getIt<FirebaseStorage>().ref(),
  );

  getIt.registerSingleton<FirebaseMessaging>(FirebaseMessaging.instance);
  getIt.registerLazySingleton<NotificationCubit>(
    () => NotificationCubit(),
  );
}
