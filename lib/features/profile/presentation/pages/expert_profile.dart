import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/component/custom_cached_image.dart';
import 'package:maxless/core/component/custom_header.dart';
import 'package:maxless/core/component/custom_loading_indicator.dart';
import 'package:maxless/core/component/custom_modal_progress_indicator.dart';
import 'package:maxless/core/component/custom_network_image.dart';
import 'package:maxless/core/component/custom_post_image.dart';
import 'package:maxless/core/component/custom_toast.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/app_strings.dart';
import 'package:maxless/core/constants/navigation.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/core/network/local_network.dart';
import 'package:maxless/core/services/service_locator.dart';
import 'package:maxless/features/community/data/models/community_item_model.dart';
import 'package:maxless/features/community/presentation/cubit/community_cubit.dart';
import 'package:maxless/features/community/presentation/widgets/add_post_bottom_sheet.dart';
import 'package:maxless/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:maxless/features/profile/presentation/pages/reviews_view.dart';

class ExpertProfilePage extends StatelessWidget {
  const ExpertProfilePage({
    super.key,
    this.id,
    this.isExpert,
  });

  final int? id;
  final bool? isExpert;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => (ProfileCubit()
        ..showProfileDetails(id: id ?? context.read<GlobalCubit>().userId!)),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is GetProfileErrorState) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.error,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<ProfileCubit>();
          return Scaffold(
            backgroundColor: AppColors.white,
            body: CustomModalProgressIndicator(
              inAsyncCall: state is GetProfileLoadingState ? true : false,
              child: RefreshIndicator(
                color: AppColors.primaryColor,
                onRefresh: () {
                  return cubit.showProfileDetails(
                      id: id ?? context.read<GlobalCubit>().userId!);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    //! Header
                    CustomHeader(
                      title: isExpert != null
                          ? isExpert == true
                              ? AppStrings.beautyExpertDetails.tr(context)
                              : AppStrings.salonDetails.tr(context)
                          : context.read<GlobalCubit>().isExpert
                              ? AppStrings.beautyExpertDetails.tr(context)
                              : AppStrings.salonDetails.tr(context),
                      onBackPress: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(height: 10.h),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //! User Details
                              cubit.user != null
                                  ? Center(
                                      child: Column(
                                        children: [
                                          //!Pp Image
                                          CustomCachedImage(
                                            imageUrl: cubit.user!.image,
                                            h: 107.h,
                                            w: 107.h,
                                            borderRadius: 100,
                                            errorWidget: Container(
                                              height: 107.h,
                                              width: 107.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                border: Border.all(
                                                  color: AppColors.primaryColor,
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.person,
                                                size: 60.h,
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10.h),
                                          //! Name
                                          Text(
                                            cubit.user!.name ?? "...",
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primaryColor,
                                            ),
                                          ),
                                          //! Rating
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: List.generate(
                                              5,
                                              (index) {
                                                double starValue = index + 1;

                                                return Icon(
                                                  starValue <=
                                                          (cubit.user!.rating ??
                                                              0)
                                                      ? Icons.star
                                                      : starValue - 0.5 <=
                                                              (cubit.user!
                                                                      .rating ??
                                                                  0)
                                                          ? Icons.star_half
                                                          : Icons.star_border,
                                                  color: Colors.amber,
                                                  size: 16.sp,
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 10.h),
                                          //! Experince & Reviews
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "experience_label"
                                                        .tr(context),
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4.h),
                                                  Text(
                                                    "reviews_label".tr(context),
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "${cubit.user!.experience ?? 0} ${AppStrings.years.tr(context)}",
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4.h),
                                                  GestureDetector(
                                                    onTap: () {
                                                      navigateTo(
                                                        context,
                                                        ReviewsView(
                                                          userId: id ??
                                                              context
                                                                  .read<
                                                                      GlobalCubit>()
                                                                  .userId!,
                                                        ),
                                                      );
                                                    },
                                                    child: Text(
                                                      (cubit.user!.ratingCount ??
                                                              0)
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14.sp,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        decorationColor:
                                                            AppColors
                                                                .primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 12.h),
                                          Divider(
                                            thickness: 1,
                                            color: Colors.grey.shade300,
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              Text(
                                "posts_title".tr(context),
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10.h),
                              //! Add Post
                              id != null
                                  ? Container()
                                  : GestureDetector(
                                      onTap: () async {
                                        await addPostBottomSheet(context).then(
                                          (value) {
                                            cubit.showProfileDetails(
                                                id: id ??
                                                    // ignore: use_build_context_synchronously
                                                    context
                                                        .read<GlobalCubit>()
                                                        .userId!);
                                          },
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xffFBFBFB),
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          border: Border.all(
                                            color: const Color(0xffFFE2EC),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(width: 10.w),
                                            Expanded(
                                              child: TextField(
                                                enabled: false,
                                                decoration: InputDecoration(
                                                  border: InputBorder
                                                      .none, // إزالة الحدود
                                                  hintText:
                                                      "write_about_your_work_hint"
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
                                              onPressed: () {
                                                // حدث عند الضغط على زر الرفع
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                              SizedBox(height: 10.h),
                              //! Posts
                              ...List.generate(
                                cubit.posts.length,
                                (index) => _buildPostCard(
                                  context,
                                  model: cubit.posts[index],
                                  canEdit: id == null ? true : false,
                                ),
                              ),
                              SizedBox(height: 70.h),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPostCard(
    BuildContext context, {
    required CommunityItemModel model,
    required bool canEdit,
  }) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final cubit = context.read<ProfileCubit>();
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xffFBFBFB),
            borderRadius: BorderRadius.circular(10.r),
          ),
          margin: EdgeInsets.only(bottom: 16.h),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    //! User Image
                    CustomCachedImage(
                      imageUrl: model.expert?.image,
                      h: 35.h,
                      w: 35.h,
                      borderRadius: 50,
                      errorWidget: Container(
                        height: 35.h,
                        width: 35.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 24.h,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //! User Name
                            Text(
                              model.expert?.name ?? "...",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                            //! Locations
                            Text(
                              model.expert?.location ?? "...",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        canEdit == true
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(width: 10.w),
                                  //! Edit Post
                                  GestureDetector(
                                    onTap: () {
                                      addPostBottomSheet(context, model: model)
                                          .then((value) {
                                        // ignore: use_build_context_synchronously
                                        cubit.showProfileDetails(
                                            id: id ??
                                                // ignore: use_build_context_synchronously
                                                context
                                                    .read<GlobalCubit>()
                                                    .userId!);
                                      });
                                    },
                                    child: Icon(
                                      CupertinoIcons.pencil_ellipsis_rectangle,
                                      size: 20.sp,
                                      color: const Color(0xff9C9C9C),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  //! Delete Post
                                  GestureDetector(
                                    onTap: () {
                                      model.id != null
                                          ? showCancelDialog(
                                              context, model.id!, id)
                                          : null;
                                    },
                                    child: Icon(
                                      CupertinoIcons.xmark,
                                      size: 20.sp,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        SizedBox(height: 10.w),
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
                  ],
                ),
                SizedBox(height: 12.h),
                //! Post Images
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
                //! Post Title
                Text(
                  model.title ?? "...",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
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
                      (model.likes ?? 0).toString(),
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

  showCancelDialog(
    BuildContext context,
    int id,
    int? userId,
  ) {
    showDialog<bool?>(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => CommunityCubit(),
        child: BlocConsumer<CommunityCubit, CommunityState>(
          listener: (context, state) {
            if (state is DeleteCommunitySuccessState) {
              Navigator.pop(context, true);
            }
            if (state is DeleteCommunityErrorState) {
              showToast(
                context,
                message: state.message,
                state: ToastStates.error,
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<CommunityCubit>();
            return AlertDialog(
              alignment: Alignment.center,
              title: Text(
                "delete_post_confirmation".tr(context),
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
                state is DeleteCommunityLoadingState
                    ? const Center(
                        child: CustomLoadingIndicator(),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: CustomElevatedButton(
                              text: "yes_button".tr(context),
                              color: Colors.white,
                              borderRadius: 10,
                              borderColor: AppColors.primaryColor,
                              textColor: AppColors.primaryColor,
                              onPressed: () {
                                cubit.experDeleteCommunity(id);
                                // Fluttertoast.showToast(
                                //   msg: "post_deleted_toast".tr(context),
                                //   toastLength: Toast.LENGTH_SHORT,
                                //   gravity: ToastGravity.CENTER,
                                //   backgroundColor: Colors.white,
                                //   textColor: AppColors.primaryColor,
                                //   fontSize: 16.sp,
                                // );
                              },
                            ),
                          ),
                          SizedBox(width: 10.h),
                          Expanded(
                            child: CustomElevatedButton(
                              text: "no_button".tr(context),
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
    ).then((value) {
      if (value == true) {
        // ignore: use_build_context_synchronously
        context.read<ProfileCubit>().showProfileDetails(
            // ignore: use_build_context_synchronously
            id: userId ?? context.read<GlobalCubit>().userId!);
      }
    });
  }

  Widget buildPostImages(List<String> images) {
    if (images.length == 1) {
      return CustomNetworkImage(imageUrl: images[0]);
    } else if (images.length == 2) {
      return Row(
        children: [
          Expanded(
            child: CustomNetworkImage(imageUrl: images[0]),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: CustomNetworkImage(imageUrl: images[1]),
          ),
        ],
      );
    } else if (images.isNotEmpty) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 8.h,
        ),
        itemCount: 2,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [],
                  ),
                ),
              );
            },
            child: Hero(
              tag: images[index],
              child: CustomNetworkImage(imageUrl: images[index]),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
