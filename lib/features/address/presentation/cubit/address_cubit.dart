import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maxless/core/services/service_locator.dart';
import 'package:maxless/features/address/data/repo/set_address_repo.dart';

part 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  AddressCubit() : super(AddressInitial());

  init({required String address, required String? lat, required String? lon}) {
    addressController.text = address;
    if (lat != null && lon != null) {
      locationController.text = "https://www.google.com/maps?q=$lat,$lon";
      latitude = double.tryParse(lat);
      longitude = double.tryParse(lon);
    }
  }

  double? latitude;
  double? longitude;
  String? address;
  double? manuallyLatitude;
  double? manuallyLongitude;
  Marker? currentLocationMarker;

  GoogleMapController? mapController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController addressController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  //! Set Salon Address
  Future<void> setSalonAddress() async {
    emit(SetAddressLoadingState());
    final result = await sl<SetAddressRepo>().setSalonAddress(
      address: addressController.text,
      lat: manuallyLatitude.toString(),
      lon: manuallyLongitude.toString(),
    );
    result.fold(
      (l) => emit(SetAddressErrorState(messgae: l)),
      (r) => emit(SetAddressSuccessState()),
    );
  }

  //! Get Current Location
  Future<void> getCurrentLocation() async {
    if (latitude == null && longitude == null) {
      try {
        emit(GetCurrentLocationLoadingState());
        LocationPermission permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          // return [];
        } else {
          Position position = await Geolocator.getCurrentPosition(
            locationSettings:
                const LocationSettings(accuracy: LocationAccuracy.high),
          );
          String googleMapsLink =
              'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';
          latitude = position.latitude;
          longitude = position.longitude;
          address = googleMapsLink;
          currentLocationMarker = Marker(
            markerId: const MarkerId("current_location"),
            position: LatLng(position.latitude, position.longitude),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
          );
        }
        emit(GetCurrentLocationSuccessState());
        // return [googleMapsLink, position.latitude, position.longitude];
      } catch (e) {
        emit(GetCurrentLocationErrorState(error: e.toString()));
      }
    }
  }

  //! Select Location Manually
  selectLocationManually(CameraPosition postion) {
    manuallyLatitude = postion.target.latitude;
    manuallyLongitude = postion.target.longitude;
    emit(SelectLocationManuallyState());
  }
}
