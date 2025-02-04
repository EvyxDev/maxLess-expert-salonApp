import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maxless/core/component/custom_loading_indicator.dart';
import 'package:maxless/core/component/custom_toast.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/app_strings.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/constants/widgets/custom_text_form_field.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/community/data/models/community_item_model.dart';

import '../cubit/community_cubit.dart';

Future<CommunityItemModel?> addPostBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    backgroundColor: AppColors.white,
    builder: (context) {
      return const AddPostBottomSheetBody();
    },
  );
}

class AddPostBottomSheetBody extends StatefulWidget {
  const AddPostBottomSheetBody({super.key});

  @override
  State<AddPostBottomSheetBody> createState() => _AddPostBottomSheetBodyState();
}

class _AddPostBottomSheetBodyState extends State<AddPostBottomSheetBody> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommunityCubit(),
      child: BlocConsumer<CommunityCubit, CommunityState>(
        listener: (context, state) {
          if (state is CreateCommunitySuccessState) {
            Navigator.pop(context, context.read<CommunityCubit>().post);
          }
          if (state is CreateCommunityErrorState) {
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
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 24.h,
            ),
            width: double.infinity,
            child: Form(
              key: cubit.addPostFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //! TextField
                  CustomTextFormField(
                    controller: cubit.postTitleController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return AppStrings.thisFieldIsRequired.tr(context);
                      }
                      return null;
                    },
                    filled: true,
                    fillColor: const Color(0xffFBFBFB),
                    borderRadius: 10.r,
                    hintText: "write_about_your_work_hint".tr(context),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.sp,
                    ),
                    borderColor: const Color(0xffFFE2EC),
                  ),
                  SizedBox(height: 24.h),
                  //! Images
                  SizedBox(
                    height: 200.h,
                    width: double.infinity,
                    child: Center(
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                          cubit.postImages.length + 1,
                          (index) {
                            return index == cubit.postImages.length
                                ? Container(
                                    width: 300.w,
                                    height: 200.h,
                                    margin: EdgeInsetsDirectional.only(
                                      end: 16.w,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.lightGrey.withOpacity(.5),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            cubit.pickImage(
                                                source: ImageSource.camera);
                                            setState(() {});
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: AppColors.lightGrey,
                                            ),
                                            child: const Icon(
                                              Icons.camera_alt,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 16.w),
                                        GestureDetector(
                                          onTap: () async {
                                            await cubit.pickImage(
                                                source: ImageSource.gallery);
                                            setState(() {});
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: AppColors.lightGrey,
                                            ),
                                            child: const Icon(
                                              Icons.image,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    width: 300.w,
                                    height: 200.h,
                                    margin: EdgeInsetsDirectional.only(
                                      end: 16.w,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.file(
                                        File(cubit.postImages[index].path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  //! Add Post Button
                  state is CreateCommunityLoadingState
                      ? const CustomLoadingIndicator()
                      : CustomElevatedButton(
                          text: AppStrings.addPost.tr(context),
                          onPressed: () {
                            if (cubit.addPostFormKey.currentState!.validate()) {
                              if (cubit.postImages.isNotEmpty) {
                                cubit.expertCreatePost();
                              } else {
                                showToast(
                                  context,
                                  message:
                                      AppStrings.addAtLeastOneImage.tr(context),
                                  state: ToastStates.warning,
                                );
                              }
                            }
                          },
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
