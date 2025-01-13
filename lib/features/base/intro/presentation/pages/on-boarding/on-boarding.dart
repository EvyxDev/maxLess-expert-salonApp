import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/navigation.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/auth/presentation/pages/login.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  List<Map<String, String>> onboardingData = []; // تعريف القائمة هنا بدون سياق

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });

    // تهيئة القائمة داخل initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        onboardingData = [
          {
            "image": 'lib/assets/1-intro.png',
            "title": "onboarding_title".tr(context),
            "subtitle": "onboarding_subtitle".tr(context),
          },
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingData.length,
            itemBuilder: (context, index) {
              return _buildOnboardingPage(
                image: onboardingData[index]["image"]!,
                title: onboardingData[index]["title"]!,
                subtitle: onboardingData[index]["subtitle"]!,
              );
            },
          ),
          // اللوجو في الأعلى يسار
          Positioned(
            top: 50.h,
            left: 20.w,
            child: SvgPicture.asset(
              './lib/assets/logo.svg',
              height: 31.h,
              width: 100.w,
            ),
          ),
          // النقاط السفلية
        ],
      ),
    );
  }

  Widget _buildOnboardingPage({
    required String image,
    required String title,
    required String subtitle,
  }) {
    return Stack(
      children: [
        // الخلفية الرئيسية
        Positioned.fill(
          child: Image.asset(
            image,
            fit: BoxFit.cover,
          ),
        ),
        // الشكل المائل كخلفية
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SvgPicture.asset(
            './lib/assets/icons/on-shape.svg',
            fit: BoxFit.cover,
          ),
        ),
        // النصوص في الأسفل
        Positioned(
          bottom: 20.h,
          left: 20.w,
          right: 20.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 10.h),
              GestureDetector(
                onTap: () {
                  if (_currentPage < onboardingData.length - 1) {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    // انتقل إلى الشاشة التالية (عند انتهاء الـ onboarding)
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  }
                },
                child: Text(
                  textAlign: TextAlign.left,
                  subtitle,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Align(
                alignment: Alignment.centerLeft,
                child: CustomElevatedButton(
                  text: "login".tr(context),
                  color: AppColors.white,
                  borderColor: AppColors.white,
                  textColor: AppColors.primaryColor,
                  icon: Icon(
                    CupertinoIcons.right_chevron,
                    color: AppColors.primaryColor,
                    size: 15.sp,
                  ),
                  onPressed: () {
                    if (_currentPage < onboardingData.length - 1) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => Login()),
                      // );
                      navigateAndFinish(context, Login());
                    }
                  },
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ],
    );
  }
}
