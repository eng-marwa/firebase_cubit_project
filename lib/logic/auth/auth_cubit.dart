import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cubit_project/core/exception/firebase_auth_exception_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/app_user.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth;
  AuthCubit(this._auth) : super(Idle());

  Future<void> login(String email, String password) async {
    emit(Loading());
    _handleAuthOperation(() =>
        _auth.signInWithEmailAndPassword(email: email, password: password));
  }

  Future<void> register(String email, String password) async {
    emit(Loading());
    _handleAuthOperation(() =>
        _auth.createUserWithEmailAndPassword(email: email, password: password));
  }

  Future<void> logoutUser() async {
    emit(Loading());
    try {
      await _auth.signOut();
      emit(LogoutSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(FirebaseAuthExceptionHandler.handleException(e)));
    }
  }

  Future<void> _handleAuthOperation(
      Future<UserCredential> Function() authMethod) async {
    emit(Loading());
    try {
      final userCredential = await authMethod();
      if (userCredential.user != null) {
        AppUser appUser = AppUser(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email!,
        );
        emit(AuthSuccess(appUser));
      } else {
        emit(AuthFailure('Authentication failed'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(FirebaseAuthExceptionHandler.handleException(e)));
    } catch (e) {
      emit(AuthFailure('An unknown error occurred'));
    }
  }
}
