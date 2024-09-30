import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationHandler {
  NotificationHandler._();

  static void handleNotification() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        print(
            'Got a message whilst in the foreground! -> onMessage ${message.notification!.body}');
        try {
          _handleNotification(message);
        } catch (e) {
          print('Error: $e');
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
          print('Error: $e');
        }
      },
    );

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  }

  static void _handleNotification(RemoteMessage message) {
    print('Handling a message: ${message.notification!.body!}');
    if (message.notification != null) {
      print(
          'NotificationReceived ${message.notification!.title} - ${message.notification!.body}');
    }
    if (message.data.isNotEmpty) {
      print('NotificationPayloadReceived ${message.data}');
    }
  }
}

Future<void> _backgroundHandler(RemoteMessage message) async {
  NotificationHandler._handleNotification(message);
}
