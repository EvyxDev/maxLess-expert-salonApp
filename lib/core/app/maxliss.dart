import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/locale/localization_settings.dart';
import 'package:maxless/features/base/intro/presentation/presentation/pages/splash.dart';
import 'package:upgrader/upgrader.dart';

import '../constants/app_colors.dart';
import '../services/service_locator.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MaxLiss extends StatelessWidget {
  const MaxLiss({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalCubit, GlobalState>(
      builder: (context, state) {
        return ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) {
            return MaterialApp(
              navigatorKey: navigatorKey,
              builder: (context, child) {
                final mediaQueryData = MediaQuery.of(context);
                final scale = mediaQueryData.textScaler
                    .clamp(minScaleFactor: 1.0, maxScaleFactor: 1.0);
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaler: scale),
                  child: child!,
                );
              },
              debugShowCheckedModeBanner: false,
              //!Localization Settings
              localizationsDelegates: localizationsDelegatesList,
              supportedLocales: supportedLocalesList,
              locale: Locale(sl<GlobalCubit>().language),
              theme: ThemeData(
                fontFamily: context.read<GlobalCubit>().language == "ar"
                    ? 'Beiruti'
                    : "Jost",
                textTheme: ThemeData.dark().textTheme.apply(
                      bodyColor: Colors.black,
                      displayColor: Colors.black,
                      fontFamily: context.read<GlobalCubit>().language == "ar"
                          ? 'Beiruti'
                          : "Jost",
                    ),
                textSelectionTheme: TextSelectionThemeData(
                  cursorColor: AppColors.primaryColor,
                  selectionColor: AppColors.primaryColor.withOpacity(.3),
                  selectionHandleColor: AppColors.primaryColor,
                ),
                primarySwatch: Colors.blue,
              ),
              //!App Scroll Behavior
              scrollBehavior: ScrollConfiguration.of(context)
                  .copyWith(physics: const ClampingScrollPhysics()),

              //!Routing
              home: UpgradeAlert(
                dialogStyle: UpgradeDialogStyle.cupertino,
                showLater: false,
                barrierDismissible: false,
                showIgnore: false,
                showReleaseNotes: true,
                child: const SplashScreen(),
              ),
            );
          },
        );
      },
    );
  }
}
