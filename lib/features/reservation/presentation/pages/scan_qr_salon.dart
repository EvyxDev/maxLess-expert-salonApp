import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maxless/core/component/custom_header.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/reservation/presentation/pages/receipt_details.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQRSalon extends StatefulWidget {
  const ScanQRSalon({super.key});

  @override
  State<ScanQRSalon> createState() => _ScanQRSalonState();
}

class _ScanQRSalonState extends State<ScanQRSalon> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _capturedImage;
  QRViewController? _controller;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    controller = controller;
    controller.scannedDataStream.listen((scanData) {
      _controller?.pauseCamera(); // إيقاف الكاميرا بعد المسح
      _nextStep(); // الانتقال إلى الخطوة التالية
    });
  }

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
      // print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // الهيدر: يظهر فقط في شاشة QR Code
            if (_currentStep == 0)
              CustomHeader(
                title: "qr_code_title".tr(context),
                onBackPress: () {
                  Navigator.pop(context);
                },
              ),
            // المؤشر: يظهر فقط في الخطوات
            if (_currentStep > 0)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: SafeArea(
                  child: Column(
                    children: [
                      SizedBox(height: 30.h),
                      Text(
                        "session_title".tr(context),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.sp, // Responsive font size
                          color: const Color(0xff525252),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: _buildStepIndicator(),
                      ),
                    ],
                  ),
                ),
              ),

            // المحتوى
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildQRStep(), // شاشة QR Code
                  _buildStep1(), // الخطوات الأخرى
                  _buildStep2(),
                  _buildStep3(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQRStep() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 280.h,
                  width: 280.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        width: 2),
                  ),
                ),
                Container(
                  height: 230.h,
                  width: 230.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        width: 2),
                  ),
                ),
                Container(
                  height: 180.h,
                  width: 180.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: QRView(
                    key: _qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderColor: AppColors.primaryColor,
                      borderRadius: 10.r,
                      borderLength: 30.w,
                      borderWidth: 10.w,
                      cutOutSize: 300.w,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.h),
            Text(
              "qr_code_instruction".tr(context),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
            ),
            SizedBox(height: 40.h),
            CustomElevatedButton(
              text: "scan_qr_button".tr(context),
              color: AppColors.primaryColor,
              textColor: Colors.white,
              onPressed: _nextStep, // الانتقال إلى الخطوات
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              './lib/assets/icons/new/step1.svg',
              height: 244.h,
              fit: BoxFit.cover,
              width: 244.w,
            ),
            SizedBox(height: 30.h),
            Text(
              "step_1_title".tr(context),
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
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 30.h),
            CustomElevatedButton(
              text: "start_session".tr(context),
              color: AppColors.primaryColor,
              textColor: Colors.white,
              onPressed: _nextStep,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              './lib/assets/icons/camera-shot.svg',
              height: 244.h,
              fit: BoxFit.cover,
              width: 244.w,
            ),
            SizedBox(height: 30.h),
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
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 30.h),
            CustomElevatedButton(
              text: "take_photo_button".tr(context),
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
      ),
    );
  }

  Widget _buildStep3() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              './lib/assets/icons/new/clock.svg',
              height: 200.h,
            ),
            SizedBox(height: 30.h),
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
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 30.h),
            CustomElevatedButton(
              text: "end_session".tr(context),
              color: AppColors.primaryColor,
              textColor: Colors.white,
              onPressed: () {
                // عرض البوب-أب الأول
                Future.delayed(const Duration(seconds: 1), () {
                  showDialog(
                    // ignore: use_build_context_synchronously
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "session_ended_popup_title".tr(context),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Text(
                                "session_ended_popup_description".tr(context),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "service_cost_hint".tr(context),
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.h),
                              CustomElevatedButton(
                                text: "send".tr(context),
                                color: AppColors.primaryColor,
                                textColor: Colors.white,
                                onPressed: () {
                                  Navigator.pop(
                                      context); // إغلاق البوب-أب الأول
                                  // عرض البوب-أب الثاني
                                  _showRatingPopup(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    int totalSteps = 3;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.only(top: 30.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(totalSteps, (index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            width: 53.w,
            height: 2.h,
            decoration: BoxDecoration(
              color: index <= _currentStep - 1
                  ? AppColors.primaryColor
                  : const Color(0xffD9D9D9),
              borderRadius: BorderRadius.circular(4.r),
            ),
          );
        }),
      ),
    );
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
                    "feedback_prompt".tr(context),
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
                    "feedback_rate_expert".tr(context),
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
                          // print("Star $index clicked");
                        },
                      );
                    }),
                  ),
                  SizedBox(height: 20.h),

                  // حقل النص لإضافة تعليق
                  TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "write_something".tr(context),
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
                    text: "send".tr(context),
                    color: AppColors.primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.pop(context); // إغلاق النافذة

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReceiptDetailsPage()),
                        (route) => route.isFirst,
                        // يبقي فقط أول صفحة (عادةً صفحة Home)
                      );
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
}
