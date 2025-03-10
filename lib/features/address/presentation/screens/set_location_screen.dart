import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maxless/core/component/custom_header.dart';
import 'package:maxless/core/component/custom_loading_indicator.dart';
import 'package:maxless/core/component/custom_modal_progress_indicator.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/address/presentation/cubit/address_cubit.dart';
import 'package:maxless/features/address/presentation/screens/set_location_manually_screen.dart';
import 'package:maxless/features/auth/presentation/cubits/set_location_cubit/set_location_cubit.dart';

class SetLocationScreen extends StatelessWidget {
  const SetLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddressCubit()..getCurrentLocation(),
      child: BlocConsumer<AddressCubit, AddressState>(
        listener: (context, state) {
          // if (state is SetLocationSuccessState) {
          //   // navigateAndFinish(context, HomePage());
          // }
          // if (state is SetLocationErrorState) {
          //   showToast(
          //     context,
          //     message: state.message,
          //     state: ToastStates.error,
          //   );
          // }
        },
        builder: (context, state) {
          final cubit = context.read<AddressCubit>();
          return Scaffold(
            backgroundColor: AppColors.white,
            body: CustomModalProgressIndicator(
              inAsyncCall: state is SetLocationLoadingState ? true : false,
              child: Column(
                children: [
                  SizedBox(height: 20.h),

                  //! Title
                  CustomHeader(
                    title: "location_access_title".tr(context),
                    onBackPress: () {
                      Navigator.pop(context);
                    },
                    // showPopButton: false,
                  ),

                  // محتوى الشاشة
                  Expanded(
                    child: Stack(
                      children: [
                        //! Google Map
                        cubit.latitude != null && cubit.longitude != null
                            ? Positioned.fill(
                                child: GoogleMap(
                                  mapType: MapType.terrain,
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                      cubit.latitude!,
                                      cubit.longitude!,
                                    ),
                                    // target: LatLng(context.read<GlobalCubit>().latitude!,
                                    //     context.read<GlobalCubit>().longitude!),
                                    zoom: 14.4746,
                                  ),
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    // controller.complete(controller);
                                  },
                                  markers: {
                                    cubit.currentLocationMarker!,
                                  },
                                ),
                              )
                            : state is GetCurrentLocationLoadingState
                                ? const Center(
                                    child: CustomLoadingIndicator(),
                                  )
                                : Container(),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white, // لون خلفية الـ Container
                              borderRadius:
                                  BorderRadius.circular(12), // الحواف الدائرية
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(
                                      0x80EEEEEE), // لون الظل (بنسبة شفافية 50%)
                                  offset: Offset(0, 1), // إزاحة الظل
                                  blurRadius: 9, // نصف القطر (التشويش)
                                  spreadRadius: 0, // مدى الانتشار
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20.h),

                                // النص "Set Location"
                                Text(
                                  "set_location_title".tr(context),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),

                                SizedBox(height: 20.h),

                                //! Set Current Location
                                if (cubit.latitude != null &&
                                    cubit.longitude != null)
                                  CustomElevatedButton(
                                    text: "use_current_location_button"
                                        .tr(context),
                                    color: AppColors.primaryColor,
                                    borderColor: AppColors.primaryColor,
                                    textColor: Colors.white,
                                    borderRadius: 8,
                                    icon: Icon(
                                      CupertinoIcons.location_fill,
                                      color: Colors.white,
                                      size: 20.sp,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(
                                        context,
                                        [cubit.latitude, cubit.longitude],
                                      );
                                    },
                                  ),
                                SizedBox(height: 15.h),

                                //! Set Location Manually
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BlocProvider.value(
                                          value: cubit..getCurrentLocation(),
                                          child:
                                              const SetLocationManuallyScreen(),
                                        ),
                                      ),
                                    ).then((value) {
                                      if (value != null) {
                                        Navigator.pop(
                                          // ignore: use_build_context_synchronously
                                          context,
                                          [value[0], value[1]],
                                        );
                                      }
                                    });
                                  },
                                  child: Center(
                                    child: Text(
                                      "set_location_manually_text".tr(context),
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        decoration: TextDecoration.underline,
                                        decorationColor: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 6.h),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
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
