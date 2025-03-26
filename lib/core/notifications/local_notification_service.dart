import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:maxless/core/app/maxliss.dart';
import 'package:maxless/features/history/presentation/pages/history.dart';
import 'package:maxless/features/requests/presentation/pages/request.dart';

import '../../features/notification/presentation/pages/notification.dart';

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static StreamController<NotificationResponse> streamController =
      StreamController();
  static onTap(NotificationResponse notificationResponse) {
    // streamController.add(notificationResponse);
    Map<String, dynamic>? map =
        jsonDecode(notificationResponse.payload ?? "{}");
    if ((map?.isEmpty ?? false) && navigatorKey.currentState != null) {
      navigateBasedOnPayload(map ?? {});
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (navigatorKey.currentState != null && (map?.isNotEmpty ?? false)) {
          navigateBasedOnPayload(map ?? {});
        }
      });
    }
  }

  static Future init() async {
    InitializationSettings settings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/launcher_icon'),
      iOS: DarwinInitializationSettings(),
    );
    flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );

    streamController.stream.listen((response) {
      onTap(response);
    });
  }

  //basic Notification
  static void showBasicNotification(RemoteMessage message) async {
    AndroidNotificationDetails android = const AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      icon: "@drawable/ic_notification",
    );
    NotificationDetails details = NotificationDetails(
      android: android,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      details,
      payload: jsonEncode(message.data),
    );
  }

  static void navigateBasedOnPayload(Map<String, dynamic> map) {
    final String? type = map["type"];
    if (type == null) {
      debugPrint("No Type In Payload: $map");
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (context) {
          return const NotificationPage();
        }),
      );

      return;
    }

    switch (map["type"]) {
      case "booking-new":
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) {
            return const RequestsScreen();
          }),
        );
        break;
      case "booking-completed":
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) {
            return const HistoryScreen();
          }),
        );
        break;
      case "booking-canceled":
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) {
            return const HistoryScreen(
              initialTabIndex: 1,
            );
          }),
        );
        break;
      default:
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) {
            return const NotificationPage();
          }),
        );
    }
  }
}
