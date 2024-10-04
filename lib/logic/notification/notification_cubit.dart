import 'package:firebase_cubit_project/di/module.dart';
import 'package:firebase_cubit_project/logic/notification/notification_state.dart';
import 'package:firebase_cubit_project/util/firebase_message_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial()) {
    initialize();
    //handle push notifications
    handleForegroundNotification();
    handleBackgroundNotification();
  }

  //local notification
  Future<void> initialize() async {
    bool permission = await FirebaseMessageService().getPermission();
    if (permission) {
      //handle local notification
      showNotification();
    } else {
      emit(NotificationError('Permission not granted'));
    }
  }

  //local notification
  void showNotification() {
    FirebaseMessageService().showNotification();
  }

  void handleForegroundNotification() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        print(
            'Got a message whilst in the foreground! -> onMessage ${message.notification!.body}');
        try {
          _handleNotification(message);
        } catch (e) {
          emit(NotificationError(e.toString()));
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        print(
            'A new onMessageOpenedApp event was published! -> onMessageOpenedApp');
        try {
          _handleNotification(message);
        } catch (e) {
          emit(NotificationError(e.toString()));
        }
      },
    );
  }

  void handleBackgroundNotification() {
    print('Handling background notification');
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  }

  void _handleNotification(RemoteMessage message) {
    if (message.notification != null) {
      GlobalNotificationHandler.remoteMessage = message;
      emit(NotificationReceived(message));
    }
    if (message.data.isNotEmpty) {
      emit(NotificationPayloadReceived(message.data));
    }
  }
}

Future<void> _backgroundHandler(RemoteMessage message) async {
  GlobalNotificationHandler.remoteMessage = message;
  getIt<NotificationCubit>()._handleNotification(message);
}
