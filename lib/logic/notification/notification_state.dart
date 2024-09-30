import 'package:firebase_messaging/firebase_messaging.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationReceived extends NotificationState {
  final RemoteMessage message;
  NotificationReceived(this.message);
}

class NotificationPayloadReceived extends NotificationState {
  final Map<String, dynamic> payload;

  NotificationPayloadReceived(this.payload);
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}
