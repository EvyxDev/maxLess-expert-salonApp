import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maxless/core/component/custom_cached_image.dart';
import 'package:maxless/core/component/custom_header.dart';
import 'package:maxless/core/component/custom_loading_indicator.dart';
import 'package:maxless/core/component/custom_toast.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/app_strings.dart';
import 'package:maxless/core/constants/navigation.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/core/network/local_network.dart';
import 'package:maxless/core/services/service_locator.dart';
import 'package:maxless/features/address/presentation/screens/address_screen.dart';
import 'package:maxless/features/community/presentation/screens/community.dart';
import 'package:maxless/features/history/presentation/pages/history.dart';
import 'package:maxless/features/home/presentation/cubit/home_cubit.dart';
import 'package:maxless/features/profile/presentation/pages/expert_profile.dart';
import 'package:maxless/features/profile/presentation/pages/reviews_view.dart';
import 'package:maxless/features/requests/presentation/pages/request.dart';
import 'package:maxless/features/wallet/presentation/screens/wallet.dart';

import '../widgets/logout_alert_dialog.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  static bool isArabic = sl<CacheHelper>().getCachedLanguage() == 'ar';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          // العنوان
          CustomHeader(
            title: "",
            onBackPress: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                //! User Details
                BlocBuilder<GlobalCubit, GlobalState>(
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () {
                        navigateTo(context, const ExpertProfilePage());
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 20.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomCachedImage(
                              imageUrl:
                                  context.read<GlobalCubit>().userImageUrl,
                              w: 60.h,
                              h: 60.h,
                              borderRadius: 30,
                              errorWidget: Container(
                                  width: 60.h,
                                  height: 60.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    color: AppColors.primaryColor,
                                    size: 28.h,
                                  )),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //! Name
                                  Text(
                                    context.read<GlobalCubit>().userName ??
                                        "...",
                                    style: TextStyle(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  //! Phone
                                  Text(
                                    context.read<GlobalCubit>().userPhone ??
                                        "...",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: const Color(0xff9C9C9C),
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  //! Rating
                                  Row(
                                    children: List.generate(
                                      5,
                                      (index) {
                                        double starValue = index + 1;
                                        return Icon(
                                          starValue <=
                                                  (context
                                                          .read<GlobalCubit>()
                                                          .userRating ??
                                                      0)
                                              ? Icons.star
                                              : starValue - 0.5 <=
                                                      (context
                                                              .read<
                                                                  GlobalCubit>()
                                                              .userRating ??
                                                          0)
                                                  ? Icons.star_half
                                                  : Icons.star_border,
                                          color: Colors.amber,
                                          size: 16.sp,
                                        );
                                      },
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
                //! Freeze Button
                BlocBuilder<GlobalCubit, GlobalState>(
                  builder: (context, state) {
                    return BlocConsumer<HomeCubit, HomeState>(
                      listener: (context, state) {
                        if (state is FreezeToggleSuccessState) {
                          showToast(
                            context,
                            message: state.message,
                            state: ToastStates.success,
                          );
                        }
                        if (state is FreezeToggleErrorState) {
                          showToast(
                            context,
                            message: state.message,
                            state: ToastStates.error,
                          );
                        }
                      },
                      builder: (context, state) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: state is FreezeToggleLoadingState
                              ? const CustomLoadingIndicator()
                              : CustomElevatedButton(
                                  text: context.read<GlobalCubit>().freeze == 1
                                      ? "unfreeze".tr(context)
                                      : "freeze".tr(context),
                                  onPressed: () {
                                    context.read<HomeCubit>().freezeToggle(
                                        context,
                                        context.read<GlobalCubit>().freeze == 1
                                            ? 0
                                            : 1);
                                  },
                                  heigth: 40.h,
                                ),
                        );
                      },
                    );
                  },
                ),
                //! Language
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: _buildLanguageField(context),
                ),
                //! Address
                if (context.read<GlobalCubit>().isSalon)
                  _buildNavItem(
                    context,
                    icon: "lib/assets/address.svg",
                    label: AppStrings.address.tr(context),
                    onTap: () {
                      navigateTo(context, const AddressScreen());
                    },
                  ),
                //! Requests
                _buildNavItem(
                  context,
                  icon: "lib/assets/reviews.svg",
                  label: "reviews_label".tr(context),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReviewsView(
                          userId: context.read<GlobalCubit>().userId!,
                        ),
                      ),
                    );
                  },
                ),
                //! Requests
                _buildNavItem(
                  context,
                  icon: "lib/assets/icons/new/req.svg",
                  label: "requests_title".tr(context),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RequestsScreen()),
                    );
                  },
                ),
                //! Requests History
                _buildNavItem(
                  context,
                  icon: "lib/assets/icons/new/history.svg",
                  label: "history_title".tr(context),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HistoryScreen()),
                    );
                  },
                ),
                //! Community
                _buildNavItem(
                  context,
                  icon: "lib/assets/icons/new/community.svg",
                  label: "community_title".tr(context),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CommunityPage()),
                    );
                  },
                ),
                //! Wallet
                _buildNavItem(
                  context,
                  icon: "lib/assets/icons/new/wallet.svg",
                  label: "Wallet",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WalletPage()),
                    );
                  },
                ),
                //! Logout
                _buildNavItem(
                  context,
                  icon: "lib/assets/icons/new/logout.svg",
                  label: "logout_option_title".tr(context),
                  onTap: () {
                    Scaffold.of(context).closeDrawer();
                    logoutAlertDialog(context);
                  },
                  iconColor: AppColors.primaryColor,
                ),
                // Spacer(),
                // Privacy Policy and Help
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.privacy_tip,
                            color: const Color(0xff9C9C9C),
                            size: 20.sp,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            "privacy_policy".tr(context),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.question_circle_fill,
                            color: const Color(0xff9C9C9C),
                            size: 20.sp,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            "help".tr(context),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context,
      {required String icon,
      required String label,
      required VoidCallback onTap,
      Color iconColor = Colors.black}) {
    bool isRTL = Directionality.of(context) == TextDirection.ltr;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 0.h,
        horizontal: 20.w,
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(
              vertical: 0.h,
            ),
            leading: SvgPicture.asset(
              icon,
              width: 20.w,
              colorFilter: const ColorFilter.mode(
                AppColors.primaryColor,
                BlendMode.srcIn,
              ),
            ),
            minLeadingWidth: 5.w,
            title: Row(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                Icon(
                  isRTL
                      ? CupertinoIcons
                          .chevron_forward // إذا كانت RTL، يظهر سهم للخلف
                      : CupertinoIcons.chevron_back,
                  color: const Color(0xff525252),
                  size: 18.sp,
                )
              ],
            ),
            onTap: onTap,
          ),
          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }

  Widget _buildLanguageField(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isArabic = sl<CacheHelper>().getCachedLanguage() == 'ar';

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "change_language".tr(context),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            CupertinoSwitch(
              value: isArabic,
              activeColor: AppColors.primaryColor,
              onChanged: (value) {
                setState(() {
                  isArabic = value;
                });

                context.read<GlobalCubit>().changeLanguage();
              },
            ),
          ],
        );
      },
    );
  }
}
