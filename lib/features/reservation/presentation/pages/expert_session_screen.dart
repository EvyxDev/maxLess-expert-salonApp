import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maxless/core/component/custom_header.dart';
import 'package:maxless/core/component/custom_modal_progress_indicator.dart';
import 'package:maxless/core/component/custom_toast.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/navigation.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/chatting/presentation/pages/customer_service_chat.dart';
import 'package:maxless/features/home/data/models/booking_item_model.dart';
import 'package:maxless/features/home/presentation/pages/home.dart';
import 'package:maxless/features/reservation/presentation/cubit/session_cubit.dart';

import '../widgets/feedback_alert_dialog.dart';

class ExpertSessionScreen extends StatefulWidget {
  const ExpertSessionScreen({
    super.key,
    required this.bookingId,
    required this.model,
    this.index,
  });

  final int bookingId;
  final BookingItemModel model;
  final int? index;

  @override
  State<ExpertSessionScreen> createState() => _ExpertSessionScreenState();
}

class _ExpertSessionScreenState extends State<ExpertSessionScreen> {
  late PageController _pageController;
  int _currentStep = 0;

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  // ignore: unused_element
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
        ..bookingId = widget.bookingId
        ..userType = context.read<GlobalCubit>().isExpert ? "expert" : "salon"
        ..userId = context.read<GlobalCubit>().userId!
        ..bookingModel = widget.model,
      child: BlocConsumer<SessionCubit, SessionState>(
        listener: (context, state) {
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
            _nextStep();
          }
          if (state is EndSessionErrorState) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.error,
            );
          }
          if (state is ExpertSafeSuccessState) {
            final cubit = context.read<SessionCubit>();
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) => BlocProvider.value(
                value: cubit,
                child: const FeedbackAlertDialog(),
              ),
            ).whenComplete(() {
              cubit.rating = 1;
              cubit.feedbackController.clear();
            });
          }
          if (state is ExpertSafeErrorState) {
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
            canPop: false,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: CustomModalProgressIndicator(
                inAsyncCall: state is StartSessionLoadingState ||
                        state is TakePhotoLoadingState ||
                        state is EndSessionLoadingState ||
                        state is ExpertSafeLoadingState
                    ? true
                    : false,
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    // if (_currentStep == 0)
                    CustomHeader(
                      title: "session_title".tr(context),
                      showPopButton: _currentStep == 0 ? true : false,
                      onBackPress: () {
                        if (_currentStep == 0) {
                          navigateAndFinish(context, HomePage());
                        } else {
                          _prevStep();
                        }
                      },
                      trailing: GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CustomerServiceChat()),
                            (route) => route.isFirst,
                          );
                        },
                        child: SvgPicture.asset(
                          "lib/assets/icons/new/sos.svg",
                          width: 37.w,
                          height: 37.h,
                        ),
                      ),
                    ),

                    //! Pages
                    Column(
                      children: [
                        SizedBox(height: 72.h),
                        _buildStepIndicator(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.75,
                            child: PageView(
                              controller: _pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                _buildStep1(
                                  onTap: () async {
                                    await cubit.startSession();
                                  },
                                ),
                                const BuildStep2(),
                                _buildStep3(
                                  onTap: () async {
                                    await cubit.endSession();
                                  },
                                ),
                                _buildStep4(
                                  onTap: () {
                                    cubit.expertSafe();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildStep1({required Function() onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 50.h),
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
          const Spacer(),
          CustomElevatedButton(
            text: "step_1_button_text".tr(context),
            color: AppColors.primaryColor,
            textColor: Colors.white,
            onPressed: onTap,
          ),
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
          SizedBox(height: 50.h),
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
          const Spacer(),
          CustomElevatedButton(
            text: "step_3_button_text".tr(context),
            color: AppColors.primaryColor,
            textColor: Colors.white,
            onPressed: onTap,
          ),
        ],
      ),
    );
  }

  Widget _buildStep4({required Function() onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 50.h),
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
            './lib/assets/icons/done.svg',
            height: 244.h,
            fit: BoxFit.cover,
            width: 244.w,
          ),
          SizedBox(height: 30.h),

          const Spacer(),
          CustomElevatedButton(
            text: "step_4_button_text".tr(context),
            color: AppColors.primaryColor,
            textColor: Colors.white,
            onPressed: onTap,
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
                : const Color(0xffD9D9D9), // اللون الرمادي للخطوات القادمة
            borderRadius: BorderRadius.circular(4.r),
          ),
        );
      }),
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
              SizedBox(height: 68.h),
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
            ],
          ),
        );
      },
    );
  }
}
