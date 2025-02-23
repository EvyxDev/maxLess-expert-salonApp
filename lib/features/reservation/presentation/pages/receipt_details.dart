import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/component/custom_cached_image.dart';
import 'package:maxless/core/component/custom_header.dart';
import 'package:maxless/core/component/custom_modal_progress_indicator.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/home/data/models/booking_item_model.dart';
import 'package:maxless/features/reservation/data/models/receipt_booking_model.dart';
import 'package:maxless/features/reservation/presentation/cubit/session_cubit.dart';

class ReceiptDetailsPage extends StatelessWidget {
  const ReceiptDetailsPage({
    super.key,
    required this.model,
  });

  final BookingItemModel model;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SessionCubit()
        ..userId = context.read<GlobalCubit>().userId!
        ..userType = "user"
        ..bookingModel = model
        ..bookingId = model.id!
        ..getSessionReceiptDetails(),
      child: BlocBuilder<SessionCubit, SessionState>(
        builder: (context, state) {
          final cubit = context.read<SessionCubit>();
          return Scaffold(
            backgroundColor: AppColors.white,
            body: CustomModalProgressIndicator(
              inAsyncCall: state is SessionReceiptLoadingState ? true : false,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    //! Header
                    CustomHeader(
                      title: "receipt_details".tr(context),
                      onBackPress: () {
                        Navigator.pop(context);
                      },
                    ),
                    cubit.receiptDetailModel != null
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 20.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20.h),
                                Row(
                                  children: [
                                    //! صورة الملف الشخصي
                                    CustomCachedImage(
                                      imageUrl:
                                          cubit.receiptDetailModel?.salon.image,
                                      borderRadius: 12.r,
                                      h: 60.r,
                                      w: 60.w,
                                      fit: BoxFit.cover,
                                      errorWidget: Container(
                                        height: 60.h,
                                        width: 60.w,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                          border: Border.all(
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          color: AppColors.primaryColor,
                                          size: 30.h,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    // النصوص
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //! Name
                                        Text(
                                          cubit.receiptDetailModel?.salon
                                                  .name ??
                                              "",
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        //! Location
                                        cubit.receiptDetailModel!.salon.lat !=
                                                    null &&
                                                cubit.receiptDetailModel!.salon
                                                        .lon !=
                                                    null
                                            ? GestureDetector(
                                                onTap: () {
                                                  context
                                                      .read<GlobalCubit>()
                                                      .launchGoogleMapLink(
                                                        lat: double.tryParse(cubit
                                                                .receiptDetailModel!
                                                                .salon
                                                                .lat!) ??
                                                            0,
                                                        lon: double.tryParse(cubit
                                                                .receiptDetailModel!
                                                                .salon
                                                                .lon!) ??
                                                            0,
                                                      );
                                                },
                                                child: SizedBox(
                                                  width: 250.w,
                                                  child: Row(children: [
                                                    Icon(
                                                      CupertinoIcons
                                                          .location_solid,
                                                      size: 16.sp,
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        context
                                                            .read<GlobalCubit>()
                                                            .formateGoogleMapLink(
                                                              lat: double.tryParse(cubit
                                                                      .receiptDetailModel!
                                                                      .salon
                                                                      .lat!) ??
                                                                  0,
                                                              lon: double.tryParse(cubit
                                                                      .receiptDetailModel!
                                                                      .salon
                                                                      .lon!) ??
                                                                  0,
                                                            ),
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color:
                                                              AppColors.black,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                              )
                                            : Container(),
                                        SizedBox(height: 4.h),
                                        //! Phone
                                        cubit.receiptDetailModel?.salon.phone !=
                                                null
                                            ? Row(children: [
                                                Icon(
                                                  CupertinoIcons.phone_fill,
                                                  size: 16.sp,
                                                  color: AppColors.primaryColor,
                                                ),
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                                Text(
                                                  cubit.receiptDetailModel!
                                                      .salon.phone!,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors.black,
                                                  ),
                                                ),
                                              ])
                                            : Container(),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.h),
                                _buildSectionTitle("your_booking".tr(context)),
                                SizedBox(height: 10.h),
                                _buildBookingDetails(
                                  context,
                                  model: cubit.receiptDetailModel!.booking,
                                ),
                                SizedBox(height: 20.h),
                                _buildDashedDivider(),
                                SizedBox(height: 20.h),
                                _buildSectionTitle("price_details".tr(context)),
                                SizedBox(height: 10.h),
                                _buildPriceDetails(
                                  context,
                                  model: cubit.receiptDetailModel!.booking,
                                ),
                                SizedBox(height: 20.h),
                              ],
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildBookingDetails(BuildContext context,
      {required ReceiptBookingModel model}) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xffFFE2EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
              CupertinoIcons.calendar, "dates".tr(context), model.date ?? "??"),
          SizedBox(height: 10.h),
          _buildDetailRow(CupertinoIcons.time, "start_session".tr(context),
              model.startSession ?? "??"),
          SizedBox(height: 10.h),
          _buildDetailRow(CupertinoIcons.time, "end_session".tr(context),
              model.endSession ?? "??"),
          SizedBox(height: 10.h),
          _buildDetailRow(
              CupertinoIcons.phone, "phone".tr(context), model.phone ?? "??"),
        ],
      ),
    );
  }

  Widget _buildPriceDetails(BuildContext context,
      {required ReceiptBookingModel model}) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xffFFE2EC)),
      ),
      child: Column(
        children: [
          _buildPriceRow("price".tr(context), "${model.amount ?? 0.0}"),
          SizedBox(height: 8.h),
          _buildDashedDivider(),
          SizedBox(height: 10.h),
          _buildPriceRow("discount".tr(context), "${model.discount ?? 0.0}"),
          SizedBox(height: 8.h),
          _buildDashedDivider(),
          SizedBox(height: 10.h),
          _buildPriceRow(
              "total_price".tr(context), "${model.totalPrice ?? 0.0}",
              isBold: true),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: const Color(0xff9C9C9C)),
        SizedBox(width: 10.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.black,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String title, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
            color: isBold ? Colors.black : Colors.grey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildDashedDivider() {
    return SizedBox(
      width: double.infinity,
      height: 1.h,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final dashWidth = 5.w;
          final dashSpace = 3.w;
          final dashCount =
              (constraints.constrainWidth() / (dashWidth + dashSpace)).floor();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              dashCount,
              (index) => Container(
                width: dashWidth,
                height: 1.h,
                color: Colors.grey.shade400,
              ),
            ),
          );
        },
      ),
    );
  }
}
