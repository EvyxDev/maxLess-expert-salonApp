import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/component/custom_post_image.dart';
import 'package:maxless/core/component/custom_toast.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/navigation.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/network/local_network.dart';
import 'package:maxless/core/services/service_locator.dart';
import 'package:maxless/features/community/data/models/community_item_model.dart';
import 'package:maxless/features/community/presentation/cubit/community_cubit.dart';
import 'package:maxless/features/profile/presentation/pages/expert_profile.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.model});

  final CommunityItemModel model;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommunityCubit, CommunityState>(
      listener: (context, state) {
        if (state is LikeCommunityErrorState) {
          showToast(
            context,
            message: state.message,
            state: ToastStates.error,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<CommunityCubit>();
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            color: const Color(0xffFBFBFB),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    navigateTo(
                        context,
                        ExpertProfilePage(
                          id: model.expert?.id ==
                                  context.read<GlobalCubit>().userId
                              ? null
                              : model.expert?.id,
                        ));
                  },
                  child: Row(
                    children: [
                      //! User Image
                      model.expert?.image != null
                          ? SizedBox(
                              height: 35.h,
                              width: 35.h,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(model.expert!.image!),
                              ),
                            )
                          : Container(),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //! Name
                          Text(
                            model.expert?.name ?? "...",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                          //! Location
                          Text(
                            model.expert?.location ?? "...",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      //! Post Time
                      Text(
                        model.time ?? "...",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                //! Image
                model.images.length == 1
                    ? CustomPostImage(imageUrl: model.images[0])
                    : model.images.isEmpty
                        ? Container()
                        : Directionality(
                            textDirection:
                                sl<CacheHelper>().getCachedLanguage() == "en"
                                    ? TextDirection.ltr
                                    : TextDirection.rtl,
                            child: CarouselSlider(
                              items: model.images
                                  .map((e) => CustomPostImage(imageUrl: e))
                                  .toList(),
                              disableGesture: false,
                              options: CarouselOptions(
                                height: 300.h,
                                aspectRatio: 16 / 9,
                                viewportFraction: .8,
                                initialPage: 0,
                                enableInfiniteScroll: false,
                                reverse: false,
                                autoPlay: false,
                                enlargeCenterPage: true,
                                enlargeFactor: 0.2,
                                scrollDirection: Axis.horizontal,
                              ),
                            ),
                          ),
                SizedBox(height: 12.h),
                //! Description
                Text(
                  model.title ?? "...",
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 12.h),
                //! Likes
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        model.id != null
                            ? cubit.expertLikeCommunity(model.id!)
                            : null;
                      },
                      child: Icon(
                        model.isWishlist == true
                            ? CupertinoIcons.heart_fill
                            : CupertinoIcons.heart,
                        color: AppColors.primaryColor,
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      "${model.likes ?? 0}",
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
