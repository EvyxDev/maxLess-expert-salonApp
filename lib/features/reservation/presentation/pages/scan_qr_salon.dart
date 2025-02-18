import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maxless/core/component/custom_header.dart';
import 'package:maxless/core/component/custom_loading_indicator.dart';
import 'package:maxless/core/component/custom_modal_progress_indicator.dart';
import 'package:maxless/core/component/custom_toast.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/app_strings.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/home/data/models/booking_item_model.dart';
import 'package:maxless/features/reservation/presentation/cubit/session_cubit.dart';
import 'package:maxless/features/tracking/presentation/cubit/tracking_cubit.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../widgets/feedback_alert_dialog.dart';

class ScanQRSalon extends StatefulWidget {
  const ScanQRSalon({
    super.key,
    required this.model,
    this.index,
  });

  final BookingItemModel model;
  final int? index;

  @override
  State<ScanQRSalon> createState() => _ScanQRSalonState();
}

class _ScanQRSalonState extends State<ScanQRSalon> {
  late PageController _pageController;
  late int _currentStep;
  final MobileScannerController scannerController =
      MobileScannerController(autoStart: false);

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
    scannerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _currentStep = widget.index ?? 0;
    _pageController = PageController(initialPage: widget.index ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SessionCubit()
        ..bookingId = widget.model.id!
        ..userType = context.read<GlobalCubit>().isExpert ? "expert" : "salon"
        ..userId = context.read<GlobalCubit>().userId!
        ..bookingModel = widget.model,
      child: BlocConsumer<SessionCubit, SessionState>(
        listener: (context, state) {
          if (state is ScanQrCodeSuccessState) {
            _nextStep();
          }
          if (state is ScanQrCodeErrorState) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.error,
            );
          }
          if (state is StartSessionSuccessState) {
            _nextStep();
          }
          if (state is StartSessionErrorState) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.error,
            );
          }
          if (state is TakePhotoSuccessState) {
            _nextStep();
          }
          if (state is TakePhotoErrorState) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.error,
            );
          }
          if (state is EndSessionSuccessState) {
            setSessionPriceDialog(context);
          }
          if (state is EndSessionErrorState) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.error,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<SessionCubit>();
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: CustomModalProgressIndicator(
              inAsyncCall: state is ScanQrCodeLoadingState ||
                      state is StartSessionLoadingState ||
                      state is TakePhotoLoadingState ||
                      state is EndSessionLoadingState
                  ? true
                  : false,
              child: SafeArea(
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
                          BuildQRStep(
                            controller: scannerController,
                          ),
                          _buildStep1(
                            onTap: () {
                              cubit.startSession();
                            },
                          ),
                          const BuildStep2(),
                          _buildStep3(
                            onTap: () {
                              cubit.endSession();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> setSessionPriceDialog(BuildContext oldContext) {
    GlobalKey<FormState> priceFormKey = GlobalKey<FormState>();
    return showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BlocProvider.value(
            value: oldContext.read<SessionCubit>(),
            child: BlocConsumer<SessionCubit, SessionState>(
              listener: (context, state) {
                if (state is SetSessionPriceSuccessState) {
                  showToast(
                    context,
                    message: state.message,
                    state: ToastStates.success,
                  );
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => BlocProvider.value(
                      value: oldContext.read<SessionCubit>(),
                      child: const FeedbackAlertDialog(),
                    ),
                  );
                }
                if (state is SetSessionPriceErrorState) {
                  showToast(
                    context,
                    message: state.message,
                    state: ToastStates.error,
                  );
                }
              },
              builder: (context, state) {
                final cubit = context.read<SessionCubit>();
                return PopScope(
                  // canPop: false,
                  canPop: true,
                  child: Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Form(
                        key: priceFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //! Title
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "session_ended_popup_title".tr(context),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            //! Price
                            Text(
                              "session_ended_popup_description".tr(context),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff09031B),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            TextFormField(
                              controller: cubit.priceController,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return AppStrings.thisFieldIsRequired
                                      .tr(context);
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "service_cost_hint".tr(context),
                                hintStyle: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.grey,
                                ),
                                suffix: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("egp".tr(context)),
                                  ],
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            //! Discount
                            Text(
                              AppStrings.enterTheDiscount.tr(context),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff09031B),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            TextFormField(
                              controller: cubit.discountController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText:
                                    AppStrings.serviceDiscount.tr(context),
                                hintStyle: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.grey,
                                ),
                                suffix: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("egp".tr(context)),
                                  ],
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            state is SetSessionPriceLoadingState
                                ? const CustomLoadingIndicator()
                                : CustomElevatedButton(
                                    text: "send".tr(context),
                                    color: AppColors.primaryColor,
                                    textColor: Colors.white,
                                    onPressed: () {
                                      if (priceFormKey.currentState!
                                          .validate()) {
                                        FocusScope.of(context).unfocus();
                                        cubit.setSessionPrice();
                                      }
                                    },
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }).whenComplete(() {
      // ignore: use_build_context_synchronously
      oldContext.read<SessionCubit>().priceController.clear();
    });
  }

  Widget _buildStep1({required Function() onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 80.h),
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
          const Spacer(),
          CustomElevatedButton(
            text: "start_session".tr(context),
            color: AppColors.primaryColor,
            textColor: Colors.white,
            onPressed: onTap,
          ),
          SizedBox(height: 43.h),
        ],
      ),
    );
  }

  Widget _buildStep3({required Function() onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 80.h),
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
          const Spacer(),
          CustomElevatedButton(
            text: "end_session".tr(context),
            color: AppColors.primaryColor,
            textColor: Colors.white,
            onPressed: onTap,
            //  () {
            // عرض البوب-أب الأول
            // Future.delayed(const Duration(seconds: 1), () {

            //     },
            //   );
            // });
            // },
          ),
          SizedBox(height: 43.h),
        ],
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
}

class BuildStep2 extends StatefulWidget {
  const BuildStep2({super.key});

  @override
  State<BuildStep2> createState() => _BuildStep2State();
}

class _BuildStep2State extends State<BuildStep2> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        final cubit = context.read<SessionCubit>();
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 80.h),
              cubit.image != null
                  ? SizedBox(
                      height: 300.h,
                      width: 300.w,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: Image.file(
                              File(cubit.image!.path),
                              height: 300.h,
                              width: 300.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional.topEnd,
                            child: GestureDetector(
                              onTap: () {
                                cubit.image = null;
                                setState(() {});
                              },
                              child: Container(
                                margin: EdgeInsets.all(8.h),
                                padding: EdgeInsets.all(4.h),
                                decoration: BoxDecoration(
                                  color: AppColors.lightGrey.withOpacity(.3),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Icon(
                                  Icons.close,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SvgPicture.asset(
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
              const Spacer(),
              CustomElevatedButton(
                text: cubit.image != null
                    ? "next".tr(context)
                    : "step_2_button_text".tr(context),
                color: AppColors.primaryColor,
                textColor: Colors.white,
                onPressed: () async {
                  if (cubit.image != null) {
                    cubit.takePhoto();
                  } else {
                    await cubit.pickImage();
                    setState(() {});
                  }
                },
              ),
              SizedBox(height: 43.h),
            ],
          ),
        );
      },
    );
  }
}

class BuildQRStep extends StatefulWidget {
  const BuildQRStep({super.key, required this.controller});

  final MobileScannerController controller;

  @override
  State<BuildQRStep> createState() => _BuildQRStepState();
}

class _BuildQRStepState extends State<BuildQRStep> {
  bool scannerStarted = false;

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SessionCubit, SessionState>(
      listener: (context, state) {
        if (state is ScanQrCodeSuccessState) {
          widget.controller.dispose();
        }
      },
      builder: (context, state) {
        final cubit = context.read<SessionCubit>();
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 80.h),
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
                    height: 300.h,
                    width: 300.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          width: 2),
                    ),
                  ),
                  Container(
                    height: 300.h,
                    width: 300.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: scannerStarted
                          ? [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: scannerStarted
                          ? MobileScanner(
                              controller: widget.controller,
                              onDetect: state is ArrivedLocationLoadingState
                                  ? null
                                  : (capture) async {
                                      final List<Barcode> barcodes =
                                          capture.barcodes;

                                      if (barcodes.isNotEmpty) {
                                        final Barcode barcode = barcodes.first;
                                        final String? code = barcode.rawValue;

                                        if (code != null) {
                                          widget.controller.pause();
                                          if (code == cubit.bookingModel.code) {
                                            await cubit.scanQrCode();
                                            widget.controller.stop();
                                          } else {
                                            showToast(
                                              context,
                                              message: AppStrings.invalidCode
                                                  .tr(context),
                                              state: ToastStates.error,
                                            );
                                            Future.delayed(
                                              const Duration(seconds: 1),
                                              () => widget.controller.start(),
                                            );
                                          }
                                        }
                                      }
                                    },
                            )
                          : Image.asset(
                              "assets/images/scann_logo.png",
                            ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              const Spacer(),
              !scannerStarted
                  ? CustomElevatedButton(
                      text: "scan_qr_button".tr(context),
                      color: AppColors.primaryColor,
                      textColor: Colors.white,
                      onPressed: () async {
                        widget.controller.start();
                        scannerStarted = true;
                        setState(() {});
                      },
                    )
                  : Container(),
              SizedBox(height: 43.h),
            ],
          ),
        );
      },
    );
  }
}
