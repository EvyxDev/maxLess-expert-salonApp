import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/app/maxliss.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/network/local_network.dart';
import 'package:maxless/core/services/service_locator.dart';
import 'package:maxless/firebase_options.dart';

import 'core/constants/app_constants.dart';
import 'core/notifications/local_notification_service.dart';
import 'core/notifications/notification_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ScreenUtil.ensureScreenSize();
  //! Orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  //! Status Bar Settings
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  //! Service Locator
  initServiceLocator();
  //! Cache Helper
  await sl<CacheHelper>().init();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (!kReleaseMode) log('Firebase initialized successfully.');
  } catch (e) {
    if (!kReleaseMode) log('Firebase initialization failed: $e');
  }

  //! Initialize Firebase Messaging
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  try {
    String? fcmToken = await firebaseMessaging.getToken();
    if (!kReleaseMode) log('FCM Token: $fcmToken');
    // SharedPreferencesHelper.saveFcmToken(fcmToken ?? '');
    sl<CacheHelper>().saveData(key: AppConstants.fcmToken, value: fcmToken);
  } catch (e) {
    if (!kReleaseMode) log('Failed to fetch FCM Token: $e');
  }

  //! Initialize Notification
  Future.wait([
    NotificationHandler.init(),
    LocalNotificationService.init(),
  ]);

  //! Application Starts From here.
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GlobalCubit()..init(),
        ),
      ],
      child: const MaxLiss(),
    ),
  );
}
