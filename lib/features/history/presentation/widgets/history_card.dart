import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/features/home/data/models/answer_and_question_model.dart';
import 'package:maxless/features/home/data/models/booking_item_model.dart';
import 'package:maxless/features/requests/presentation/cubit/requests_cubit.dart';

class HistoryCard extends StatefulWidget {
  final bool completed;
  final BookingItemModel model;

  const HistoryCard({
    super.key,
    required this.completed,
    required this.model,
  });

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard>
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
                // "5 April 2023",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff525252),
                ),
              ),
              SizedBox(height: 8.h),
              //! Service Name & Start & EndTime
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
                  //! Start & End Time
                  Text(
                    cubit.formateTime(widget.model.time ?? "00:00:00"),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xff525252),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              //! User Image & Name & Arrow Icon
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget.completed)
                    Icon(
                      isExpanded
                          ? CupertinoIcons.arrow_up_left
                          : CupertinoIcons.arrow_down_right,
                      color: const Color(0xff9C9C9C),
                      size: 20.sp,
                    ),
                  if (!widget.completed) SizedBox(width: 8.w),
                  //! User Picture
                  Container(
                    width: 34.h,
                    height: 34.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: AppColors.black,
                        width: .5.w,
                      ),
                    ),
                    child: widget.model.user!.image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              widget.model.user!.image!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            Icons.person,
                            color: AppColors.black,
                          ),
                  ),
                  SizedBox(width: 8.w),
                  //! User Name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.model.user?.name ?? "",
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
                  //! Arrow Icon
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
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: isExpanded
                    ? Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: Column(
                          children: [
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
                                                lon: widget.model.lon!);
                                          },
                                          child: Text(
                                            cubit.formateGoogleMapLink(
                                                lat: widget.model.lat!,
                                                lon: widget.model.lon!),
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
}
