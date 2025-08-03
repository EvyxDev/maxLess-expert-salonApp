import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/features/home/data/models/booking_item_model.dart';
import 'package:maxless/features/home/presentation/cubit/home_cubit.dart';
import 'package:maxless/features/home/presentation/widgets/home_booking_card_dialog.dart';

class HomeBookingCard extends StatelessWidget {
  const HomeBookingCard({
    super.key,
    required this.model,
    required this.color,
  });

  final BookingItemModel model;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();
        return Expanded(
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (innerContext) {
                  return HomeBookingCardDialog(
                    model: model,
                  );
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff1C252C).withOpacity(0.08),
                    blurRadius: 23,
                    spreadRadius: 0,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   "service_name"
                  //       .tr(context),
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 16.sp,
                  //     fontWeight:
                  //         FontWeight.bold,
                  //   ),
                  // ),
                  // SizedBox(height: 4.h),
                  //! User Name
                  Text(
                    model.user?.name ?? "...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(
                          milliseconds: 300,
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1.w, color: Colors.white),
                            shape: BoxShape.circle),
                        child: SizedBox(
                          height: 60.h,
                          width: 60.h,
                          child: model.user?.image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    model.user?.image ?? "",
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(Icons.person),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Row(
                        children: [
                          Text(
                            cubit.formateTime(model.time ?? "00:00:00"),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
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
