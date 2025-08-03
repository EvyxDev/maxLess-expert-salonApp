import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maxless/core/component/custom_header.dart';
import 'package:maxless/core/component/custom_loading_indicator.dart';
import 'package:maxless/core/component/custom_modal_progress_indicator.dart';
import 'package:maxless/core/component/custom_toast.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/app_strings.dart';
import 'package:maxless/core/constants/navigation.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/home/data/models/booking_item_model.dart';
import 'package:maxless/features/home/presentation/pages/home.dart';
import 'package:maxless/features/requests/presentation/cubit/requests_cubit.dart';
import 'package:maxless/features/reservation/presentation/pages/expert_session_screen.dart';
import 'package:maxless/features/tracking/presentation/cubit/tracking_cubit.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({
    super.key,
    required this.lat,
    required this.lon,
    required this.bookingId,
    required this.model,
  });

  final double lat, lon;
  final int bookingId;
  final BookingItemModel model;

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool isTracking = false; // حالة التتبع
  TextEditingController reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    log(widget.lat.toString());
    log(widget.lon.toString());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TrackingCubit()
        ..init(
          latLng: LatLng(widget.lat, widget.lon),
          globalCubit: context.read<GlobalCubit>(),
          model: widget.model,
        ),
      child: BlocConsumer<TrackingCubit, TrackingState>(
        listener: (context, state) {
          if (state is ArrivedLocationSuccessState) {
            navigateAndFinish(
              context,
              ExpertSessionScreen(
                bookingId: widget.bookingId,
                model: widget.model,
              ),
            );
          }
          if (state is ArrivedLocationErrorState) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.error,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<TrackingCubit>();
          return Scaffold(
            backgroundColor: AppColors.white,
            body: CustomModalProgressIndicator(
              inAsyncCall: state is ArrivedLocationLoadingState ? true : false,
              child: Column(
                children: [
                  SizedBox(height: 20.h),

                  //! Header
                  CustomHeader(
                    title: "track_title".tr(context),
                    onBackPress: () {
                      Navigator.pop(context);
                    },
                  ),

                  //! Map
                  if (cubit.userLocation != null)
                    Expanded(
                      child: Stack(
                        children: [
                          //! Map Body
                          Positioned.fill(
                            child: GoogleMap(
                              mapType: MapType.terrain,
                              initialCameraPosition: CameraPosition(
                                target: cubit.userLocation!,
                                zoom: 14.4746,
                              ),
                              onMapCreated: (GoogleMapController controller) {
                                cubit.mapController = controller;
                              },
                              markers: cubit.markers,
                              polylines: cubit.polylines,
                              myLocationEnabled: true,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x80EEEEEE),
                                    offset: Offset(0, 1),
                                    blurRadius: 9,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Stack(
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              //! Remaining Time
                                              Text(
                                                cubit.formatDuration(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 24.sp,
                                                  color:
                                                      const Color(0xff000000),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(width: 4.w),
                                              const Icon(
                                                Icons.directions_car_rounded,
                                                color: AppColors.primaryColor,
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 8.h),
                                          if (cubit.remainingDistance != null &&
                                              cubit.arrivalTime != null)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                //! Arrive Time
                                                Text(
                                                  cubit.remainingDistance
                                                          ?.toString() ??
                                                      "0.0",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    color:
                                                        const Color(0xff000000),
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                SizedBox(width: 28.w),
                                                Text(
                                                  cubit.arrivalTime ?? "?",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    color:
                                                        const Color(0xff000000),
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                      //! Cancel Session
                                      Align(
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: Icon(
                                            CupertinoIcons.clear_circled,
                                            color: AppColors.primaryColor,
                                            size: 35.sp,
                                          ),
                                          onPressed: () async {
                                            // _showCancelDialog(context);
                                            await _showCancelDialog(
                                              context,
                                            )?.then(
                                              (value) async {
                                                if (value == true) {
                                                  // ignore: use_build_context_synchronously
                                                  await showReasonDialog(
                                                      // ignore: use_build_context_synchronously
                                                      context);
                                                }
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 16.h),

                                  //! User Phone
                                  if ((cubit.estimatedTime?.inMinutes ?? 10) <=
                                      5)
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 16.h),
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.phone,
                                              color: AppColors.primaryColor,
                                            ),
                                            SizedBox(width: 8.w),
                                            Text(
                                              widget.model.user?.phone ?? "",
                                              style: TextStyle(
                                                fontSize: 18.sp,
                                                color: AppColors.primaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  //! زر التتبع
                                  if ((cubit.estimatedTime?.inMinutes ?? 10) <=
                                          5 ||
                                      !isTracking)
                                    CustomElevatedButton(
                                      text: isTracking
                                          ? "tracking_button_done".tr(context)
                                          : "tracking_button_track_me"
                                              .tr(context),
                                      color: isTracking
                                          ? AppColors.primaryColor
                                          : AppColors.primaryColor,
                                      borderColor: isTracking
                                          ? AppColors.primaryColor
                                          : AppColors.primaryColor,
                                      borderRadius: 8,
                                      onPressed: () async {
                                        if (!isTracking) {
                                          await cubit.startTracking(
                                            expertId: context
                                                .read<GlobalCubit>()
                                                .userId!,
                                          );
                                          cubit.sendMessage();

                                          setState(() {
                                            isTracking = !isTracking;
                                          });
                                        } else {
                                          cubit.expertArrivedLocation(
                                            bookingId: widget.bookingId,
                                            userId: context
                                                .read<GlobalCubit>()
                                                .userId!,
                                          );
                                        }
                                        // setState(() {
                                        //   isTracking = !isTracking;
                                        //   isTracking
                                        //       ? null
                                        //       : navigateTo(
                                        //           context,
                                        //           ExpertSessionScreen(
                                        //             bookingId: widget.bookingId,
                                        //           ),
                                        //         );
                                        // });
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // مربع الحوار للتأكيد على الإلغاء
  Future<bool>? _showCancelDialog(BuildContext context) async {
    bool? yes = await showDialog<bool>(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => RequestsCubit(),
        child: BlocConsumer<RequestsCubit, RequestsState>(
          listener: (context, state) {
            if (state is BookingChangeStatusSuccessState) {
              showToast(
                context,
                message: state.message,
                state: ToastStates.success,
              );
              Navigator.pop(context, true);
            }
            if (state is BookingChangeStatusErrorState) {
              showToast(
                context,
                message: state.message,
                state: ToastStates.error,
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<RequestsCubit>();
            final globalCubit = context.read<GlobalCubit>();
            return AlertDialog(
              alignment: Alignment.center,
              title: Text(
                "cancel_dialog_title".tr(context),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              actions: [
                state is BookingChangeStatusLoadingState
                    ? const CustomLoadingIndicator()
                    : Row(
                        children: [
                          Expanded(
                            child: CustomElevatedButton(
                              text: "cancel_dialog_yes".tr(context),
                              color: Colors.white,
                              borderRadius: 10,
                              borderColor: AppColors.primaryColor,
                              textColor: AppColors.primaryColor,
                              onPressed: () async {
                                //* If Expert
                                globalCubit.isExpert
                                    ? await cubit.expertChangeBookingStatus(
                                        bookingId: widget.model.id!,
                                        status: 4,
                                        userId: globalCubit.userId!,
                                      )
                                    : null;
                                //* If Salon
                                globalCubit.isSalon
                                    ? await cubit.salonChangeBookingStatus(
                                        bookingId: widget.model.id!,
                                        status: 4,
                                        userId: globalCubit.userId!,
                                      )
                                    : null;
                              },
                            ),
                          ),
                          SizedBox(width: 10.h), // مسافة بين الأزرار
                          Expanded(
                            child: CustomElevatedButton(
                              text: "cancel_dialog_no".tr(context),
                              borderRadius: 10,
                              color: AppColors.primaryColor,
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
              ],
            );
          },
        ),
      ),
    );
    if (yes == true) {
      return true;
    }
    return false;
  }

  Future<bool>? showReasonDialog(BuildContext context) async {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController reasonController = TextEditingController();
    bool isEmergencyChecked = false; // Track checkbox state
    bool? isTrue = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return PopScope(
              canPop: false,
              child: BlocProvider(
                create: (context) => RequestsCubit(),
                child: BlocConsumer<RequestsCubit, RequestsState>(
                  listener: (context, state) {
                    if (state is CancelReasonSuccessState) {
                      navigateAndFinish(context, HomePage());
                    }
                    if (state is CancelReasonErrorState) {
                      showToast(
                        context,
                        message: state.message,
                        state: ToastStates.error,
                      );
                    }
                  },
                  builder: (context, state) {
                    final cubit = context.read<RequestsCubit>();
                    final globalCubit = context.read<GlobalCubit>();
                    return AlertDialog(
                      alignment: Alignment.center,
                      title: Text(
                        "reason_dialog_title".tr(context),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff09031B),
                        ),
                      ),
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      content: SingleChildScrollView(
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              //! TextField
                              TextFormField(
                                controller: reasonController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return AppStrings.thisFieldIsRequired
                                        .tr(context);
                                  }
                                  return null;
                                },
                                maxLines: 5,
                                decoration: InputDecoration(
                                  hintText:
                                      "reason_dialog_checkbox".tr(context),
                                  hintStyle: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey,
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 12.h,
                                    horizontal: 16.w,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 1.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: const BorderSide(
                                      color: AppColors.primaryColor,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),

                              //! Checkbox
                              Row(
                                children: [
                                  Checkbox(
                                    value: isEmergencyChecked,
                                    activeColor: AppColors.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                      side: const BorderSide(
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    checkColor: AppColors.white,
                                    onChanged: (value) {
                                      setState(() {
                                        isEmergencyChecked = value ?? false;
                                        if (isEmergencyChecked) {
                                          reasonController.text =
                                              "reason_dialog_checkbox"
                                                  .tr(context);
                                        } else {
                                          reasonController
                                              .clear(); // Clear reason if unchecked
                                        }
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: Text(
                                      "reason_dialog_checkbox".tr(context),
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      //! Send Button
                      actions: [
                        state is CancelReasonLoadingState
                            ? const CustomLoadingIndicator()
                            : Row(
                                children: [
                                  Expanded(
                                    child: CustomElevatedButton(
                                      text: "reason_dialog_send_button"
                                          .tr(context),
                                      color: AppColors.primaryColor,
                                      borderRadius: 10,
                                      textColor: Colors.white,
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        if (formKey.currentState!.validate()) {
                                          globalCubit.isExpert
                                              ? cubit.expertCancelReason(
                                                  bookingId: widget.model.id!,
                                                  userId: globalCubit.userId!,
                                                  reason: reasonController.text,
                                                  isEmergncy:
                                                      isEmergencyChecked,
                                                )
                                              : null;
                                          globalCubit.isSalon
                                              ? cubit.salonCancelReason(
                                                  bookingId: widget.model.id!,
                                                  userId: globalCubit.userId!,
                                                  reason: reasonController.text,
                                                  isEmergncy:
                                                      isEmergencyChecked,
                                                )
                                              : null;
                                        }
                                        // navigateTo(context, HistoryScreen());
                                        // Fluttertoast.showToast(
                                        //   msg: "toast_request_cancelled".tr(context),
                                        //   toastLength: Toast.LENGTH_SHORT,
                                        //   gravity: ToastGravity.CENTER,
                                        //   textColor: Colors.black,
                                        //   backgroundColor: Colors.white,
                                        //   fontSize: 16.sp,
                                        // );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
    if (isTrue == true) {
      return true;
    }
    return false;
  }
}
