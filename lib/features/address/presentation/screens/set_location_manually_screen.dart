import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maxless/core/component/custom_header.dart';
import 'package:maxless/core/component/custom_loading_indicator.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/address/presentation/cubit/address_cubit.dart';

class SetLocationManuallyScreen extends StatelessWidget {
  const SetLocationManuallyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressCubit, AddressState>(
      builder: (context, state) {
        final cubit = context.read<AddressCubit>();
        return Scaffold(
          backgroundColor: AppColors.white,
          body: Column(
            children: [
              SizedBox(height: 20.h),
              //! Header
              CustomHeader(
                title: "set_location_manually_text".tr(context),
                onBackPress: () => Navigator.pop(context),
              ),
              SizedBox(height: 24.h),
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
                              onMapCreated: (GoogleMapController controller) {
                                cubit.mapController = controller;
                              },
                              onCameraMove: (postion) {
                                cubit.selectLocationManually(postion);
                              },
                              mapToolbarEnabled: false,
                              zoomControlsEnabled: false,
                            ),
                          )
                        : state is GetCurrentLocationLoadingState
                            ? const Center(
                                child: CustomLoadingIndicator(),
                              )
                            : Container(),
                    //! Overlay Centered Marker
                    if (cubit.latitude != null && cubit.longitude != null)
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 40.h),
                          child: Icon(
                            Icons.location_pin,
                            size: 40.h,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    //! Confirm Button
                    if (cubit.latitude != null && cubit.longitude != null)
                      Positioned(
                        left: 16.w,
                        right: 16.w,
                        bottom: 24.h,
                        child: CustomElevatedButton(
                          text: "selectLocation".tr(context),
                          onPressed: () {
                            Navigator.pop(context, [
                              cubit.manuallyLatitude ?? cubit.latitude,
                              cubit.manuallyLongitude ?? cubit.longitude
                            ]);
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
