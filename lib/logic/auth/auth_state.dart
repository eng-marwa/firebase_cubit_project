import '../../data/model/app_user.dart';

abstract class AuthState {}

class AuthSuccess extends AuthState {
  final AppUser appUser;
  AuthSuccess(this.appUser);
}

class AuthFailure extends AuthState {
  String error;
  AuthFailure(this.error);
}

class Loading extends AuthState {}

class LogoutSuccess extends AuthState {}

class Idle extends AuthState {}
