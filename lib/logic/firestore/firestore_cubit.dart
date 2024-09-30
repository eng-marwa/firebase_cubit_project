import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/model/app_user.dart';
import 'firestore_state.dart';

class FirestoreCubit extends Cubit<FirestoreState> {
  final FirebaseFirestore _firestore;
  FirestoreCubit(this._firestore) : super(Initial());

  Future<void> saveUserData(AppUser appUser) async {
    emit(DataLoading());
    try {
      await _firestore
          .collection('users')
          .doc(appUser.uid)
          .set(appUser.toMap());
      emit(DataSaved());
    } on FirebaseException catch (e) {
      emit(Failure(e.message ?? 'Error'));
    }
  }

  Future<void> deleteUserData(String uid) async {
    emit(DataLoading());
    try {
      await _firestore.collection('users').doc(uid).delete();
      emit(DataDeleted());
    } on FirebaseException catch (e) {
      emit(Failure(e.message ?? 'Error'));
    }
  }

  Future<void> viewUserData(String uid) async {
    emit(DataLoading());
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(uid).get();
      AppUser appUser =
          AppUser.fromMap(snapshot.data() as Map<String, dynamic>);
      emit(DataViewed(appUser));
    } on FirebaseException catch (e) {
      emit(Failure(e.message ?? 'Error'));
    }
  }

  Future<void> updateUserData(String uid, String downloadUrl) async {
    emit(DataLoading());
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .update({'pic': downloadUrl});
      emit(DataUpdated());
    } on FirebaseException catch (e) {
      emit(Failure(e.message ?? 'Error'));
    }
  }
}
