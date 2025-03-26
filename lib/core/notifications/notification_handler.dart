import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:maxless/core/app/maxliss.dart';

import 'local_notification_service.dart';

class NotificationHandler {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static String? fcmToken = '';
  static Future init() async {
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
    if (Platform.isIOS) {
      await firebaseMessaging.getAPNSToken();
      fcmToken = await firebaseMessaging.getToken();
    } else {
      fcmToken = await firebaseMessaging.getToken();
    }
    log('FCM Token: $fcmToken');

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    //! Ensure notifications show in foreground for iOS
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    //! Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotificationService.showBasicNotification(message);
      if (!kReleaseMode) {
        log('Notification onMessage: ${message.notification?.title}');
        log('Notification Data: ${message.data}');
      }
    });

    //! Handle taps on notifications when the app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNavigation(message.data);
    });

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleNavigation(initialMessage.data);
    }
  }

  //! Handle background message
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    if (message.notification == null) {
      LocalNotificationService.showBasicNotification(message);
    }

    if (!kReleaseMode) log('Notification: ${message.notification?.title}');
  }

  static void _handleNavigation(Map<String, dynamic> data) {
    if (navigatorKey.currentState != null && data.isNotEmpty) {
      LocalNotificationService.navigateBasedOnPayload(data);
    } else {
      Future.delayed(
        const Duration(milliseconds: 500),
        () {
          if (navigatorKey.currentState != null && data.isNotEmpty) {
            LocalNotificationService.navigateBasedOnPayload(data);
          }
        },
      );
    }
  }
}
