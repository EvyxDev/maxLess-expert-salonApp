import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maxless/core/component/custom-header.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/navigation.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/chatting/presentation/pages/customer-service/customer-service-chat.dart';
import 'package:maxless/features/reservation/presentation/pages/camera.dart';
import 'package:maxless/features/reservation/presentation/pages/reservations.dart';

class ScanQRPage extends StatefulWidget {
  @override
  State<ScanQRPage> createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _capturedImage;

  Future<void> _pickImage() async {
    try {
      final pickedImage =
          await _imagePicker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        setState(() {
          _capturedImage = pickedImage;
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return "scan_qr".tr(context);
      case 1:
        return "start_session".tr(context);
      case 2:
        return "take_photo".tr(context);
      case 3:
        return "end_session_button".tr(context);
      case 4:
        return "feedback_title".tr(context);
      default:
        return "";
    }
  }

  void _showRatingPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // العنوان الرئيسي
                  Text(
                    "rating_popup_title".tr(context),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // الوصف
                  Text(
                    "rate_salon_instruction".tr(context),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // النجوم للتقييم
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < 4 // افتراض أن التقييم الحالي هو 4
                              ? CupertinoIcons.star_fill
                              : CupertinoIcons.star,
                          color: Colors.amber,
                          size: 30.sp,
                        ),
                        onPressed: () {
                          // تحديث التقييم إذا لزم الأمر
                          print("Star $index clicked");
                        },
                      );
                    }),
                  ),
                  SizedBox(height: 20.h),

                  // حقل النص لإضافة تعليق
                  TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "write_feedback".tr(context),
                      hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // زر الإرسال
                  CustomElevatedButton(
                    text: "send_button".tr(context),
                    color: AppColors.primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReservationsPage()),
                        (route) => route
                            .isFirst, // يبقي فقط أول صفحة (عادةً صفحة Home)
                      );
                      Navigator.pop(context); // إغلاق النافذة
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20.h),
          if (_currentStep == 0)
            CustomHeader(
              title: "session_title".tr(context),
              onBackPress: () {
                if (_currentStep == 0) {
                  Navigator.pop(context);
                } else {
                  _prevStep(); // الرجوع خطوة
                }
              },
              trailing: GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomerServiceChat()),
                    (route) =>
                        route.isFirst, // يبقي فقط أول صفحة (عادةً صفحة Home)
                  );
                },
                child: SvgPicture.asset(
                  "lib/assets/icons/new/sos.svg",
                  width: 37.w,
                  height: 37.h,
                ),
              ),
            ),
// المؤشر
          if (_currentStep > 0)
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 30.h),
                    Text(
                      "session_title".tr(context),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp, // حجم الخط استجابة
                        color: Color(0xff525252),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 16.w),
                    //   child: _buildStepIndicator(),
                    // ),
                  ],
                ),
              ),
            ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 0.h),
                  _buildStepIndicator(), // المؤشر
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Container(
                      height: MediaQuery.of(context).size.height *
                          0.7, // تحديد ارتفاع للـ PageView
                      child: PageView(
                        controller: _pageController,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          _buildStep1(),
                          _buildStep2(),
                          _buildStep3(),
                          _buildStep4(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "step_1".tr(context),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            "step_1_description".tr(context),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
          ),
          SizedBox(height: 30.h),
          SvgPicture.asset(
            './lib/assets/icons/new/step1.svg',
            height: 244.h,
            fit: BoxFit.cover,
            width: 244.w,
          ),
          SizedBox(height: 30.h),
          CustomElevatedButton(
            text: "step_1_button_text".tr(context),
            color: AppColors.primaryColor,
            textColor: Colors.white,
            onPressed: _nextStep,
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "step_2_title".tr(context),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            "step_2_description".tr(context),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
          ),
          SizedBox(height: 30.h),
          SvgPicture.asset(
            './lib/assets/icons/camera-shot.svg',
            height: 244.h,
            fit: BoxFit.cover,
            width: 244.w,
          ),
          SizedBox(height: 30.h),
          CustomElevatedButton(
            text: "step_2_button_text".tr(context),
            color: AppColors.primaryColor,
            textColor: Colors.white,
            onPressed: () async {
              await _pickImage();
              if (_capturedImage != null) {
                _nextStep();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "step_3_title".tr(context),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            "step_3_description".tr(context),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
          ),
          SizedBox(height: 30.h),
          SvgPicture.asset(
            './lib/assets/icons/new/step3.svg',
            height: 244.h,
            fit: BoxFit.cover,
            width: 244.w,
          ),
          SizedBox(height: 30.h),
          CustomElevatedButton(
            text: "step_3_button_text".tr(context),
            color: AppColors.primaryColor,
            textColor: Colors.white,
            onPressed: _nextStep,
          ),
        ],
      ),
    );
  }

  Widget _buildStep4() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // عنوان المرحلة
          Text(
            "step_4_title".tr(context),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 16.h),

          // الوصف
          Text(
            "step_4_description".tr(context),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 30.h),

          // الصورة
          SvgPicture.asset(
            './lib/assets/icons/done.svg', // استبدل بمسار الصورة لديك
            height: 244.h,
            fit: BoxFit.cover,
            width: 244.w,
          ),
          SizedBox(height: 30.h),

          // زر بدء الجلسة
          CustomElevatedButton(
            text: "step_4_button_text".tr(context),
            color: AppColors.primaryColor,
            textColor: Colors.white,
            onPressed: () {
              _showRatingPopup(context);
            },
          ),
          SizedBox(height: 20.h),

          // النقاط المكتسبة
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.star_circle,
                color: Colors.orange,
                size: 16.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                "step_4_points_info".tr(context),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    int totalSteps = 4; // عدد الخطوات بناءً على عدد المراحل
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(totalSteps, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: 53.w,
          height: 2.h,
          decoration: BoxDecoration(
            color: index <= _currentStep
                ? AppColors
                    .primaryColor // اللون الأحمر للخطوات التي تمت أو الحالية
                : Color(0xffD9D9D9), // اللون الرمادي للخطوات القادمة
            borderRadius: BorderRadius.circular(4.r),
          ),
        );
      }),
    );
  }
}
