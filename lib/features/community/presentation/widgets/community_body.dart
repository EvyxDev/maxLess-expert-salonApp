import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/component/custom_cached_image.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/community/presentation/cubit/community_cubit.dart';
import 'package:maxless/features/community/presentation/widgets/post_card.dart';

import 'add_post_bottom_sheet.dart';

class CommunityBody extends StatelessWidget {
  const CommunityBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityCubit, CommunityState>(
      builder: (context, state) {
        final cubit = context.read<CommunityCubit>();
        return Expanded(
          child: RefreshIndicator(
            color: AppColors.primaryColor,
            onRefresh: () {
              return cubit.init();
            },
            child: Column(
              children: [
                SizedBox(height: 10.h),
                //! Add Community
                GestureDetector(
                  onTap: () async {
                    await addPostBottomSheet(context).then((value) {
                      if (value != null) {
                        cubit.addPostToList(value);
                      }
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        CustomCachedImage(
                          imageUrl: context.read<GlobalCubit>().userImageUrl,
                          h: 40.h,
                          w: 40.h,
                          borderRadius: 40,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Container(
                            // height: 40.h,
                            decoration: BoxDecoration(
                              color: const Color(0xffFBFBFB),
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                  color: const Color(0xffFFE2EC), width: 1),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: TextField(
                                    enabled: false,
                                    decoration: InputDecoration(
                                      border: InputBorder.none, // إزالة الحدود
                                      hintText: "write_about_your_work_hint"
                                          .tr(context),
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    CupertinoIcons.cloud_upload,
                                    color: Colors.grey,
                                    size: 20.sp,
                                  ),
                                  onPressed: null,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                //! Communities Listview
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: cubit.community.length,
                    itemBuilder: (context, index) {
                      return PostCard(
                        model: cubit.community[index],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
