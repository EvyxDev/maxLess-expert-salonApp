import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maxless/core/component/custom_cached_image.dart';
import 'package:maxless/core/component/custom_header.dart';
import 'package:maxless/core/component/custom_modal_progress_indicator.dart';
import 'package:maxless/core/component/custom_toast.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/app_strings.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:maxless/features/profile/presentation/widgets/pick_image_source_bottom_sheet.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../../../../core/component/custom_drop_down_button.dart';
import '../../../../core/constants/widgets/text_style.dart';
import '../cubit/profile_state.dart';

class EditExpertProfilePage extends StatelessWidget {
  const EditExpertProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => (ProfileCubit()
        ..showProfileDetails(id: context.read<GlobalCubit>().userId!)),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) async {
          if (state is GetProfileErrorState) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.error,
            );
          }
          if (state is UpdateProfileImageErrorState) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.error,
            );
          }
          if (state is UpdateProfileImageSuccessState) {
            context.read<GlobalCubit>().updateUserData();
            showToast(
              // ignore: use_build_context_synchronously
              context,
              message: state.message,
              state: ToastStates.success,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<ProfileCubit>();
          return Scaffold(
            backgroundColor: AppColors.white,
            body: CustomModalProgressIndicator(
              inAsyncCall: state is GetProfileLoadingState ||
                      state is UpdateProfileImageLoadingState
                  ? true
                  : false,
              child: RefreshIndicator(
                color: AppColors.primaryColor,
                onRefresh: () {
                  return cubit.showProfileDetails(
                      id: context.read<GlobalCubit>().userId!);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    //! Header
                    CustomHeader(
                      title: AppStrings.editProfile.tr(context),
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
                                          //! Image
                                          SizedBox(
                                            height: 107.h,
                                            width: 107.h,
                                            child: Stack(
                                              children: [
                                                //! Image
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
                                                          BorderRadius.circular(
                                                              100),
                                                      border: Border.all(
                                                        color: AppColors
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                    child: Icon(
                                                      Icons.person,
                                                      size: 60.h,
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                ),
                                                //! Edit Icon

                                                GestureDetector(
                                                  onTap: () async {
                                                    ImageSource? source =
                                                        await pickeImageSourceBottomSheet(
                                                            context);
                                                    if (source != null) {
                                                      await cubit
                                                          .updateProfileImage(
                                                              // ignore: use_build_context_synchronously
                                                              context,
                                                              source: source);
                                                    }
                                                  },
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .bottomEnd,
                                                    child: Container(
                                                      width: 28.h,
                                                      height: 28.h,
                                                      decoration: BoxDecoration(
                                                        color: AppColors
                                                            .primaryColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                      ),
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.edit,
                                                          color:
                                                              AppColors.white,
                                                          size: 16.h,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
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

                                          SizedBox(height: 5.h),
                                          //! Governorate
                                          Form(
                                            key: cubit.formKey,
                                            child: Column(
                                              children: [
                                                CustomDropDownButton(
                                                  items: cubit.governorates
                                                      .map((element) =>
                                                          DropdownMenuItem(
                                                            value: element.name,
                                                            child: Text(
                                                              "${element.name}",
                                                              style: CustomTextStyle
                                                                  .font400sized14Black,
                                                            ),
                                                          ))
                                                      .toList(),
                                                  label: AppStrings.governorate
                                                      .tr(context),
                                                  value:
                                                      cubit.selectedGovernorate,
                                                  enabled: true,
                                                  onChanged: (value) {
                                                    cubit.selectGovernorate(
                                                        value);
                                                  },
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value == "") {
                                                      return AppStrings
                                                          .thisFieldIsRequired
                                                          .tr(context);
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                SizedBox(height: 10.h),
                                                if (cubit.selectedGovernorate !=
                                                        'القاهرة' &&
                                                    cubit.selectedGovernorate !=
                                                        "المدن الجديدة")
                                                  CustomDropDownButton(
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value == "") {
                                                        return AppStrings
                                                            .thisFieldIsRequired
                                                            .tr(context);
                                                      }
                                                      return null;
                                                    },
                                                    items: cubit.cities
                                                        .map((element) =>
                                                            DropdownMenuItem(
                                                              value:
                                                                  element.name,
                                                              child: Text(
                                                                "${element.name}",
                                                                style: CustomTextStyle
                                                                    .font400sized14Black,
                                                              ),
                                                            ))
                                                        .toList(),
                                                    label: AppStrings
                                                        .primaryCity
                                                        .tr(context),
                                                    value:
                                                        cubit.selectedMainCity,
                                                    enabled: true,
                                                    onChanged: (value) {
                                                      cubit.selectMainCity(
                                                          value);
                                                    },
                                                  ),
                                                SizedBox(height: 10.h),
                                                if (cubit.selectedGovernorate !=
                                                        'القاهرة' &&
                                                    cubit.selectedGovernorate !=
                                                        "المدن الجديدة")
                                                  MultiSelectDialogField(
                                                    colorator: (p0) {
                                                      return AppColors
                                                          .primaryColor;
                                                    },
                                                    items: cubit.cities
                                                        .map((e) =>
                                                            MultiSelectItem(
                                                                e.name,
                                                                e.name ?? ""))
                                                        .toList(),
                                                    title: Text(AppStrings
                                                        .secondaryCity
                                                        .tr(context)),
                                                    checkColor: AppColors.white,
                                                    chipDisplay:
                                                        MultiSelectChipDisplay(
                                                            onTap: (p0) {},
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              side:
                                                                  const BorderSide(
                                                                color: AppColors
                                                                    .grey,
                                                                width: 1,
                                                              ),
                                                            ),
                                                            chipColor:
                                                                AppColors.white,
                                                            // icon: const Icon(
                                                            //   Icons.close,
                                                            //   color: AppColors
                                                            //       .white,
                                                            // ),
                                                            colorator: (p0) {
                                                              return AppColors
                                                                  .white;
                                                            },
                                                            textStyle:
                                                                CustomTextStyle
                                                                    .font400sized12Black),
                                                    dialogHeight: 200,
                                                    backgroundColor:
                                                        AppColors.white,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      border: Border.all(
                                                        color:
                                                            AppColors.lightGrey,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    // validator: (value) {
                                                    //   if ((value ?? [])
                                                    //       .isEmpty) {
                                                    //     return AppStrings
                                                    //         .thisFieldIsRequired
                                                    //         .tr(context);
                                                    //   }
                                                    //   return null;
                                                    // },
                                                    buttonIcon: const Icon(
                                                      Icons.arrow_drop_down,
                                                      color: AppColors.black,
                                                    ),
                                                    buttonText: Text(
                                                      AppStrings.secondaryCity
                                                          .tr(context),
                                                      style: CustomTextStyle
                                                          .font400sized14Black,
                                                    ),
                                                    onConfirm: (values) {
                                                      cubit.selectSubCities(
                                                          values);
                                                    },
                                                    initialValue:
                                                        cubit.selectedSubCities,
                                                  ),
                                              ],
                                            ),
                                          ),

                                          SizedBox(height: 10.h),
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ),

                    //! Save Button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: CustomElevatedButton(
                        onPressed: cubit.isDataChanged()
                            ? () {
                                if (cubit.formKey.currentState!.validate()) {
                                  cubit.storLoactions();
                                }
                              }
                            : null,
                        borderColor: cubit.isDataChanged()
                            ? AppColors.primaryColor
                            : AppColors.lightGrey,
                        text: "save".tr(context),
                      ),
                    ),

                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
