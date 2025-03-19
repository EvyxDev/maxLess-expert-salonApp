import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:maxless/core/constants/app_constants.dart';
import 'package:maxless/core/services/service_locator.dart';

import '../network/local_network.dart';
import 'local_notification_service.dart';

class NotificationHandler {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static String? fcmToken = '';
  static Future init() async {
    //! Request for permission
    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    //! Get the token
    fcmToken = await firebaseMessaging.getToken();
    if (!kReleaseMode) log('FCM Token: $fcmToken');
    sl<CacheHelper>().saveData(key: AppConstants.fcmToken, value: fcmToken);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    //! Handle foreground message
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotificationService.showBasicNotification(message);
      if (!kReleaseMode) {
        log('Notification onMessage: ${message.notification?.title}');
      }
    });
  }

  //! Handle background message
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    LocalNotificationService.showBasicNotification(message);

    if (!kReleaseMode) log('Notification: ${message.notification?.title}');
  }
}
