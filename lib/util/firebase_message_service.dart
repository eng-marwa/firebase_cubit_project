import 'package:firebase_cubit_project/di/module.dart';
import 'package:firebase_cubit_project/main.dart';
import 'package:firebase_cubit_project/util/context_extension.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseMessageService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationDetails? notificationDetails;

  Future<void> setupFirebaseMessaging() async {
    String? token = await getIt<FirebaseMessaging>().getToken();
    if (token != null) {
      print('Token: $token');
      //register token in backend
    }
    getIt<FirebaseMessaging>().onTokenRefresh.listen((token) {
      print('Token: $token');
      //register token in backend
    });
  }

  Future<void> showNotification() async {
    initializeLocalNotification();
    // setup local notification details
  }

  void initializeLocalNotification() {
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('app_icon');
    DarwinInitializationSettings darwinInitializationSettings =
        const DarwinInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: darwinInitializationSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) {
      if (GlobalNotificationHandler.remoteMessage?.data['data'] != null) {
        navigateToPage(GlobalNotificationHandler.remoteMessage!.data['data']);
      }
    },
        onDidReceiveBackgroundNotificationResponse:
            _onTapBackgroundNotification);
  }

  Future<void> setupLocalNotificationDetails() async {
    String channelId = 'flutter_cubit_project_id';
    String channelName = 'flutter_cubit_project_name';
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      channelId,
      channelName,
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(channelId, channelName);

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      presentSound: true,
      presentBadge: true,
      presentAlert: true,
      presentBanner: true,
    );
    notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
  }

  void showLocalNotification(RemoteMessage message) {
    setupLocalNotificationDetails();
    flutterLocalNotificationsPlugin.show(
        message.hashCode,
        message.notification!.title,
        message.notification!.body,
        notificationDetails);
  }

  Future<bool> getPermission() async {
    bool? permissionGranted = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    return permissionGranted ?? false;
  }
}

void _onTapBackgroundNotification(NotificationResponse details) {
  if (GlobalNotificationHandler.remoteMessage?.data['data'] != null) {
    navigateToPage(GlobalNotificationHandler.remoteMessage!.data['data']);
  }
}

void navigateToPage(data) {
  if (data is String) {
    print(data);
    navigationState.currentContext?.navigateTo('/item', args: data);
  }
}

class GlobalNotificationHandler {
  static RemoteMessage? remoteMessage;
}
