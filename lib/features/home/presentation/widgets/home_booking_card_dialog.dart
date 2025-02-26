import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/component/custom_loading_indicator.dart';
import 'package:maxless/core/component/custom_toast.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/app_strings.dart';
import 'package:maxless/core/constants/navigation.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/history/presentation/pages/history.dart';
import 'package:maxless/features/home/data/models/answer_and_question_model.dart';
import 'package:maxless/features/home/data/models/booking_item_model.dart';
import 'package:maxless/features/home/presentation/cubit/home_cubit.dart';
import 'package:maxless/features/requests/presentation/pages/request.dart';
import 'package:maxless/features/reservation/presentation/cubit/session_cubit.dart';
import 'package:maxless/features/reservation/presentation/pages/expert_session_screen.dart';
import 'package:maxless/features/reservation/presentation/pages/receipt_details.dart';
import 'package:maxless/features/reservation/presentation/pages/scan_qr_salon.dart';
import 'package:maxless/features/reservation/presentation/widgets/feedback_alert_dialog.dart';
import 'package:maxless/features/tracking/presentation/pages/track_me.dart';

class HomeBookingCardDialog extends StatelessWidget {
  const HomeBookingCardDialog({
    super.key,
    required this.model,
  });

  final BookingItemModel model;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) async {
          if (state is SessionLastStepSuccessState) {
            if (context.read<GlobalCubit>().isExpert) {
              switch (state.message) {
                case "arrived_location":
                  Navigator.pop(context);
                  navigateTo(
                    context,
                    ExpertSessionScreen(
                      bookingId: model.id!,
                      model: model,
                    ),
                  );
                  break;
                case "start_session":
                  Navigator.pop(context);
                  navigateTo(
                    context,
                    ExpertSessionScreen(
                      bookingId: model.id!,
                      model: model,
                      index: 1,
                    ),
                  );
                  break;
                case "take_a_photo":
                  Navigator.pop(context);
                  navigateTo(
                    context,
                    ExpertSessionScreen(
                      bookingId: model.id!,
                      model: model,
                      index: 2,
                    ),
                  );
                  break;
                case "end_session":
                  Navigator.pop(context);
                  navigateTo(
                    context,
                    ExpertSessionScreen(
                      bookingId: model.id!,
                      model: model,
                      index: 3,
                    ),
                  );
                  break;
                case "im_safe":
                  break;
                case null:
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LocationScreen(
                        lat: model.lat ?? 0,
                        lon: model.lon ?? 0,
                        bookingId: model.id!,
                        model: model,
                      ),
                    ),
                  );
                  break;
                default:
              }
            } else {
              switch (state.message) {
                case "arrived_location":
                  Navigator.pop(context);
                  navigateTo(
                    context,
                    ScanQRSalon(
                      model: model,
                      index: 1,
                    ),
                  );
                  break;
                case "start_session":
                  Navigator.pop(context);
                  navigateTo(
                    context,
                    ScanQRSalon(
                      model: model,
                      index: 2,
                    ),
                  );
                  break;
                case "take_a_photo":
                  Navigator.pop(context);
                  navigateTo(
                    context,
                    ScanQRSalon(
                      model: model,
                      index: 3,
                    ),
                  );
                  break;
                case "end_session":
                  await context.read<HomeCubit>().checkSessionPrice(
                        bookingId: model.id!,
                      );
                  break;
                case null:
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScanQRSalon(model: model),
                    ),
                  );
                  break;
                default:
              }
            }
          }
          if (state is SessionLastStepErrorState) {
            showToast(
              // ignore: use_build_context_synchronously
              context,
              message: state.message,
              state: ToastStates.error,
            );
          }
          if (state is CheckSessionPriceSuccess) {
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
            if (state.result == false) {
              GlobalKey<FormState> priceFormKey = GlobalKey<FormState>();
              // ignore: use_build_context_synchronously
              return setPriceDialog(context, priceFormKey).whenComplete(() {
                // ignore: use_build_context_synchronously
                context.read<SessionCubit>().priceController.clear();
              });
            } else {
              // ignore: use_build_context_synchronously
              navigateTo(context, ReceiptDetailsPage(model: model));
            }
          }
          if (state is CheckSessionPriceErrorState) {
            showToast(
              // ignore: use_build_context_synchronously
              context,
              message: state.message,
              state: ToastStates.error,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<HomeCubit>();
          final globalCubit = context.read<GlobalCubit>();
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border:
                        Border.all(width: 2.w, color: const Color(0xffFFB017)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50.h),
                      //! Service Title
                      // النص الوصفي
                      // Text(
                      //   "service_name".tr(context),
                      //   style: TextStyle(
                      //     color: const Color(0xFFB2284C),
                      //     fontSize: 20.sp,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      // SizedBox(height: 10.h),
                      //! Description
                      ...List.generate(
                        model.answersAndQuestions.length,
                        (index) {
                          AnswerAndQuestionModel answerAndQuestionModel =
                              model.answersAndQuestions[index];
                          return Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              "${answerAndQuestionModel.question} : ${answerAndQuestionModel.answer}",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.clip,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20.h),

                      //! Client Details
                      Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(
                              milliseconds: 300,
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: .5.w, color: Colors.black),
                                shape: BoxShape.circle),
                            child: SizedBox(
                              height: 40.h,
                              width: 40.h,
                              child: model.user?.image != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        model.user!.image!,
                                        fit: BoxFit.cover,
                                      ))
                                  : const Icon(Icons.person),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  model.user?.name ?? "",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (model.lat != null && model.lon != null)
                                  GestureDetector(
                                    onTap: () {
                                      context
                                          .read<GlobalCubit>()
                                          .launchGoogleMapLink(
                                            lat: model.lat!,
                                            lon: model.lon!,
                                          );
                                    },
                                    child: Text(
                                      context
                                          .read<GlobalCubit>()
                                          .formateGoogleMapLink(
                                            lat: model.lat!,
                                            lon: model.lon!,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10.w),
                          //! Start Way Button
                          state is SessionLastStepLoadingState ||
                                  state is CheckSessionPriceLoadingState
                              ? SizedBox(
                                  width: 100.w,
                                  child: const CustomLoadingIndicator(),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    switch (model.status) {
                                      case 1:
                                        Navigator.pop(context);
                                        // navigateTo(
                                        //   context,
                                        //   const RequestsScreen(
                                        //     isFromBooking: true,
                                        //   ),
                                        // );
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration: const Duration(
                                                milliseconds: 1100),
                                            reverseTransitionDuration:
                                                const Duration(
                                                    milliseconds: 700),
                                            pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                const RequestsScreen(
                                              isFromBooking: true,
                                            ),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              return const ZoomPageTransitionsBuilder()
                                                  .buildTransitions(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const RequestsScreen(
                                                    isFromBooking: true,
                                                  ),
                                                ),
                                                context,
                                                animation,
                                                secondaryAnimation,
                                                child,
                                              );
                                            },
                                          ),
                                        );
                                        break;
                                      case 2:
                                        cubit.sessionLastStep(
                                          bookingId: model.id!,
                                          userType: globalCubit.isExpert
                                              ? "expert"
                                              : "salon",
                                          userId: globalCubit.userId!,
                                        );
                                        break;
                                      case 3:
                                        Navigator.pop(context);
                                        navigateTo(
                                          context,
                                          context.read<GlobalCubit>().isExpert
                                              ? const HistoryScreen()
                                              : ReceiptDetailsPage(
                                                  model: model),
                                        );
                                        break;
                                      case 4:
                                        Navigator.pop(context);
                                        navigateTo(
                                          context,
                                          const HistoryScreen(
                                            initialTabIndex: 1,
                                          ),
                                        );
                                        break;
                                      default:
                                        break;
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFB2284C),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 10.h,
                                    ),
                                    child: Text(
                                      model.status == 2
                                          ? context.read<GlobalCubit>().isExpert
                                              ? "start_the_way_button"
                                                  .tr(context)
                                              : "start_button".tr(context)
                                          : model.status == 1
                                              ? AppStrings.acceptRequest
                                                  .tr(context)
                                              : model.status == 3
                                                  ? AppStrings.completed
                                                      .tr(context)
                                                  : model.status == 4
                                                      ? AppStrings.canceled
                                                          .tr(context)
                                                      : "",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),

                // الشعار في الأعلى
                Positioned(
                  top: 30.h,
                  left: 20, // ضبط موضع الشعار
                  child: Image.asset(
                    'lib/assets/logo.png', // مسار الشعار
                    width: 70.w,
                    height: 30.h,
                    fit: BoxFit.contain,
                  ),
                ),

                // الديفايدر الجانبي
                Positioned(
                  top: 10,
                  left: -25,
                  child: Container(
                    width: 33.w,
                    height: 104.h,
                    decoration: BoxDecoration(
                      color: const Color(0xffFFB017), // لون الديفايدر البرتقالي
                      borderRadius: BorderRadius.all(Radius.circular(20.r)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> setPriceDialog(
      BuildContext context, GlobalKey<FormState> priceFormKey) {
    return showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return BlocProvider(
            create: (context) => SessionCubit()
              ..userId = context.read<GlobalCubit>().userId!
              ..bookingId = model.id!
              ..bookingModel = model,
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
                    builder: (newContext) => BlocProvider(
                      create: (context) => SessionCubit()
                        ..userId = context.read<GlobalCubit>().userId!
                        ..bookingId = model.id!
                        ..bookingModel = model,
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
        });
  }
}
