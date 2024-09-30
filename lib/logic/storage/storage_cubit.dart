import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cubit_project/di/module.dart';
import 'package:firebase_cubit_project/logic/storage/storage_state.dart';
import 'package:firebase_cubit_project/util/file_util.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StorageCubit extends Cubit<StorageState> {
  StorageCubit() : super(UploadFileInitial());

  Future<void> uploadFile(String uid) async {
    emit(UploadFileLoading());
    try {
      String filePath = await FileUtil.pickImage();
      File file = File(filePath);
      print('File Path: $filePath');
      getIt<Reference>()
          .child('images')
          .child(uid)
          .child(file.path.split('/').last)
          .putFile(file)
          .then(
        (taskSnapshot) async {
          String downloadedUrl = await taskSnapshot.ref.getDownloadURL();
          emit(FileUploaded(downloadedUrl));
        },
      );
    } on FirebaseException catch (e) {
      emit(UploadFileFailure(e.toString()));
    }
  }
}
