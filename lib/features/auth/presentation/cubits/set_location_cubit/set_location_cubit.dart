import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maxless/core/services/service_locator.dart';
import 'package:maxless/features/auth/data/repository/auth_repo.dart';

part 'set_location_state.dart';

class SetLocationCubit extends Cubit<SetLocationState> {
  SetLocationCubit() : super(SetLocationInitial());

  double? latitude;
  double? longitude;
  String? address;
  Marker? currentLocationMarker;

  //! Set Location
  Future<void> expertSetLocation() async {
    if (latitude != null && longitude != null) {
      emit(SetLocationLoadingState());
      final result = await sl<AuthRepo>().expertSetLocation(
        lat: latitude!,
        lon: longitude!,
      );
      result.fold(
        (l) => emit(SetLocationErrorState(message: l)),
        (r) => emit(SetLocationSuccessState(message: r)),
      );
    }
  }

  //! Return Current Location
  Future<void> returnCurrentLocation() async {
    emit(SaveLocationLoadingState());
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
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      );
    }
    emit(SaveLocationSuccessState());
    // return [googleMapsLink, position.latitude, position.longitude];
  }
}
