import '../../data/model/app_user.dart';

abstract class FirestoreState {}

class Initial extends FirestoreState {}

class DataSaved extends FirestoreState {}

class Failure extends FirestoreState {
  String message;

  Failure(this.message);
}

class DataDeleted extends FirestoreState {}

class DataUpdated extends FirestoreState {}

class DataViewed extends FirestoreState {
  final AppUser appUser;

  DataViewed(this.appUser);
}

class DataLoading extends FirestoreState {}
