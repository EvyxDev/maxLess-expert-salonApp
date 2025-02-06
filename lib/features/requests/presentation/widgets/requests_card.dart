import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/home/data/models/answer_and_question_model.dart';
import 'package:maxless/features/home/data/models/booking_item_model.dart';
import 'package:maxless/features/requests/presentation/cubit/requests_cubit.dart';

class RequestCard extends StatefulWidget {
  final bool completed;
  final BookingItemModel model;

  const RequestCard({
    super.key,
    required this.completed,
    required this.model,
  });

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestsCubit, RequestsState>(
      builder: (context, state) {
        final cubit = context.read<RequestsCubit>();
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(
              color: const Color(0xffFFE2EC),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //! Date
              Text(
                widget.model.date ?? "",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff525252),
                ),
              ),
              SizedBox(height: 8.h),

              //! Service and Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text(
                  //   "service_name".tr(context),
                  //   style: TextStyle(
                  //     fontSize: 14.sp,
                  //     fontWeight: FontWeight.w600,
                  //     color: AppColors.primaryColor,
                  //   ),
                  // ),
                  const Spacer(),
                  Text(
                    "${cubit.formateTime(widget.model.expertSlot?.start ?? "00:00:00")} - ${cubit.formateTime(widget.model.expertSlot?.end ?? "00:00:00")}",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xff525252),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              //! Customer Details
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget
                      .completed) // Only show the arrow icon if not completed
                    Icon(
                      isExpanded
                          ? CupertinoIcons.arrow_up_left
                          : CupertinoIcons.arrow_down_right,
                      color: const Color(0xff9C9C9C),
                      size: 20.sp,
                    ),
                  if (!widget.completed) SizedBox(width: 8.w),
                  //! User Picture
                  CircleAvatar(
                    radius: 18.r,
                    backgroundImage:
                        NetworkImage(widget.model.user!.image ?? ""),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "customer_name".tr(context),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  IconButton(
                    icon: Icon(
                      isExpanded
                          ? CupertinoIcons.chevron_up
                          : CupertinoIcons.chevron_down,
                      color: const Color(0xff9C9C9C),
                    ),
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                  ),
                ],
              ),

              // Expanded Section
              // Expanded Section
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: isExpanded
                    ? Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Location Link
                            Row(
                              children: [
                                Icon(CupertinoIcons.location, size: 14.sp),
                                SizedBox(width: 4.w),
                                //! Google Maps Link
                                widget.model.lat != null &&
                                        widget.model.lon != null
                                    ? Expanded(
                                        child: GestureDetector(
                                          onTap: () async {
                                            cubit.launchGoogleMapLink(
                                                lat: widget.model.lat!,
                                                lon: widget.model.lat!);
                                          },
                                          child: Text(
                                            cubit.formateGoogleMapLink(
                                                lat: widget.model.lat!,
                                                lon: widget.model.lat!),
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: AppColors.primaryColor,
                                            ),
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                            SizedBox(height: 8.h),

                            // Description
                            ...List.generate(
                              widget.model.answersAndQuestions.length,
                              (index) {
                                AnswerAndQuestionModel model =
                                    widget.model.answersAndQuestions[index];
                                return Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Text(
                                    "${model.question} : ${model.answer}",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey,
                                    ),
                                    overflow: TextOverflow.clip,
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 12.h),

                            // Buttons (Cancel or Accept/Reject)
                            // Buttons (Cancel or Accept/Reject)
                            if (widget.completed)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // print("Accepted");
                                        Fluttertoast.showToast(
                                          msg: "toast_request_accepted"
                                              .tr(context),
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          textColor: Colors.black,
                                          backgroundColor: Colors.white,
                                          fontSize: 16.sp,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.h),
                                      ),
                                      child: Text(
                                        "accept_button".tr(context),
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        // print("Rejected");
                                        _showCancelDialog(context);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                            color: AppColors.primaryColor),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.h),
                                      ),
                                      child: Text(
                                        "reject_button".tr(context),
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            else
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        // print("Cancelled");
                                        _showCancelDialogReason(context);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                            color: AppColors.primaryColor),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.h),
                                      ),
                                      child: Text(
                                        "cancel_button".tr(context),
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }

  // مربع الحوار للتأكيد على الإلغاء

  void _showCancelDialog(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          Row(
            children: [
              Expanded(
                child: CustomElevatedButton(
                  text: "cancel_dialog_yes".tr(context),
                  color: Colors.white,
                  borderRadius: 10,
                  borderColor: AppColors.primaryColor,
                  textColor: AppColors.primaryColor,
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog

                    // عرض التوست
                    Fluttertoast.showToast(
                      msg: "toast_request_rejected".tr(context),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      fontSize: 16.sp,
                    );
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
      ),
    );
  }

  void _showCancelDialogReason(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        alignment: Alignment.center,
        title: Text(
          "cancel_dialog_title".tr(context),
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black),
        ),
        // content: Text(
        //   "You will not be able to reply to this chat again.",
        //   textAlign: TextAlign.center,
        //   style: TextStyle(
        //     fontSize: 12.sp,
        //     fontWeight: FontWeight.w400,
        //     color: AppColors.primaryColor,
        //   ),
        // ),
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          Row(
            children: [
              Expanded(
                child: CustomElevatedButton(
                  text: "yes_button".tr(context),
                  color: Colors.white,
                  borderRadius: 10,
                  borderColor: AppColors.primaryColor,
                  textColor: AppColors.primaryColor,
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    // Navigator.pushAndRemoveUntil(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => CartPage()),
                    //   (route) =>
                    //       route.isFirst, // يبقي فقط أول صفحة (عادةً صفحة Home)
                    // );
                    _showReasonDialog(context);
                  },
                ),
              ),
              SizedBox(width: 10.h), // مسافة بين الأزرار

              Expanded(
                child: CustomElevatedButton(
                  text: "no_button".tr(context),
                  borderRadius: 10,
                  color: AppColors.primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigator.pop(context); // إغلاق المودال
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showReasonDialog(BuildContext context) {
    TextEditingController reasonController = TextEditingController();
    bool isEmergencyChecked = false; // Track checkbox state

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // TextField for custom reason
                    TextField(
                      controller: reasonController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "reason_dialog_checkbox".tr(context),
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

                    // Checkbox for predefined reason
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
                                    "reason_dialog_checkbox".tr(context);
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
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        text: "reason_dialog_send_button".tr(context),
                        color: AppColors.primaryColor,
                        borderRadius: 10,
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                          // navigateTo(context, HistoryScreen());
                          Fluttertoast.showToast(
                            msg: "toast_request_cancelled".tr(context),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            textColor: Colors.black,
                            backgroundColor: Colors.white,
                            fontSize: 16.sp,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
