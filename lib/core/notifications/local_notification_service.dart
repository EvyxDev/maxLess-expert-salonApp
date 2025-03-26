import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:maxless/core/app/maxliss.dart';
import 'package:maxless/core/constants/app_constants.dart';
import 'package:maxless/core/network/local_network.dart';
import 'package:maxless/core/services/service_locator.dart';
import 'package:maxless/features/history/presentation/pages/history.dart';
import 'package:maxless/features/requests/presentation/pages/request.dart';

import '../../features/notification/presentation/pages/notification.dart';

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static StreamController<NotificationResponse> streamController =
      StreamController();
  static onTap(NotificationResponse notificationResponse) {
    streamController.add(notificationResponse);
    Map<String, dynamic>? map =
        jsonDecode(notificationResponse.payload ?? "{}");
    if (map != null) {
      switch (map["type"]) {
        case "booking-new":
          if (sl<CacheHelper>().getData(key: AppConstants.token) != null) {
            navigatorKey.currentState?.push(
              MaterialPageRoute(builder: (context) {
                return const RequestsScreen();
              }),
            );
            break;
          }
        case "booking-completed":
          if (sl<CacheHelper>().getData(key: AppConstants.token) != null) {
            navigatorKey.currentState?.push(
              MaterialPageRoute(builder: (context) {
                return const HistoryScreen();
              }),
            );
          }
          break;
        case "booking-canceled":
          if (sl<CacheHelper>().getData(key: AppConstants.token) != null) {
            navigatorKey.currentState?.push(
              MaterialPageRoute(builder: (context) {
                return const HistoryScreen(
                  initialTabIndex: 1,
                );
              }),
            );
          }
          break;
        default:
          if (sl<CacheHelper>().getData(key: AppConstants.token) != null) {
            navigatorKey.currentState?.push(
              MaterialPageRoute(builder: (context) {
                return const NotificationPage();
              }),
            );
          }
      }
    } else {
      if (sl<CacheHelper>().getData(key: AppConstants.token) != null) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) {
            return const NotificationPage();
          }),
        );
      }
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
}
