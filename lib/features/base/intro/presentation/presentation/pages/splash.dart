import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maxless/core/constants/app_constants.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/navigation.dart';
import 'package:maxless/core/network/local_network.dart';
import 'package:maxless/core/services/service_locator.dart';
import 'package:maxless/features/base/intro/presentation/presentation/pages/on-boarding/on_boarding.dart';
import 'package:maxless/features/home/presentation/pages/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // مدة الأنيميشن
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward().whenComplete(() {
      sl<CacheHelper>().getData(key: AppConstants.token) != null
          ? navigateAndFinish(context, HomePage())
          : navigateAndFinish(context, const OnboardingScreen());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor, // اللون الأحمر الداكن
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: SvgPicture.asset(
            'lib/assets/icons/nav/white.svg', // ضع هنا مسار صورة الشعار
            width: 212.w,
            height: 75.h,
          ),
        ),
      ),
    );
  }
}
