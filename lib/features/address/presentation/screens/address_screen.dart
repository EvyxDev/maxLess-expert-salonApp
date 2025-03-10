import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/component/custom_header.dart';
import 'package:maxless/core/component/custom_modal_progress_indicator.dart';
import 'package:maxless/core/component/custom_toast.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/app_strings.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/constants/widgets/custom_text_form_field.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/address/presentation/cubit/address_cubit.dart';
import 'package:maxless/features/address/presentation/screens/set_location_screen.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddressCubit()
        ..init(
          address: context.read<GlobalCubit>().address ?? "",
          lat: context.read<GlobalCubit>().salonLat,
          lon: context.read<GlobalCubit>().salonLon,
        ),
      child: BlocConsumer<AddressCubit, AddressState>(
        listener: (context, state) {
          if (state is SetAddressSuccessState) {
            context.read<GlobalCubit>().updateUserData().whenComplete(() {
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            });
          }
          if (state is SetAddressErrorState) {
            showToast(
              context,
              message: state.messgae,
              state: ToastStates.success,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<AddressCubit>();
          return Scaffold(
            backgroundColor: AppColors.white,
            body: CustomModalProgressIndicator(
              inAsyncCall: state is SetAddressLoadingState,
              child: Form(
                key: cubit.formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    //! Header
                    CustomHeader(
                      title: AppStrings.address.tr(context),
                      onBackPress: () => Navigator.pop(context),
                    ),
                    //! Content
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          SizedBox(height: 24.h),
                          //! Address In Details
                          CustomTextFormField(
                            controller: cubit.addressController,
                            hintText: "address_detail_label".tr(context),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppStrings.thisFieldIsRequired
                                    .tr(context);
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),
                          //! Select Location
                          GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SetLocationScreen(),
                                ),
                              ).then((value) {
                                if (value != null) {
                                  // ignore: use_build_context_synchronously
                                  cubit.locationController.text = context
                                      .read<GlobalCubit>()
                                      .formateGoogleMapLink(
                                        lat: value[0],
                                        lon: value[1],
                                      );
                                  cubit.manuallyLatitude = value[0];
                                  cubit.manuallyLongitude = value[1];
                                }
                              });
                            },
                            child: CustomTextFormField(
                              controller: cubit.locationController,
                              hintText: AppStrings.selectLocation.tr(context),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return AppStrings.thisFieldIsRequired
                                      .tr(context);
                                }
                                return null;
                              },
                              enabled: false,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          //! Add & Edit Button
                          CustomElevatedButton(
                            text: context.read<GlobalCubit>().address != null
                                ? AppStrings.editLocation.tr(context)
                                : AppStrings.setLocation.tr(context),
                            onPressed: () async {
                              if (cubit.formKey.currentState!.validate()) {
                                await cubit.setSalonAddress();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
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
