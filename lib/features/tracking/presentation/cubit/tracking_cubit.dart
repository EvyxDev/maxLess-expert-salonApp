import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/database/api/dio_consumer.dart';
import 'package:maxless/core/services/service_locator.dart';
import 'package:maxless/features/reservation/data/repository/session_repo.dart';

part 'tracking_state.dart';

class TrackingCubit extends Cubit<TrackingState> {
  TrackingCubit() : super(TrackingInitial());

  init(LatLng latLng) {
    userLocation = latLng;
    markers = {
      Marker(
        markerId: const MarkerId("from"),
        position: latLng,
      ),
    };
  }

  //! Arrived Location
  Future<void> expertArrivedLocation({
    required int bookingId,
    required int userId,
  }) async {
    emit(ArrivedLocationLoadingState());
    final result = await sl<SessionRepo>().expertArrivedLocation(
      bookingId: bookingId,
      userId: userId,
    );
    result.fold(
      (l) => emit(ArrivedLocationErrorState(message: l)),
      (r) => emit(ArrivedLocationSuccessState(message: r)),
    );
  }

  GoogleMapController? mapController;
  LatLng? expertLocation;
  LatLng? userLocation;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  StreamSubscription<Position>? positionStream;
  Duration? estimatedTime; // Store remaining time
  DateTime? arrivalTime; // Store expected arrival time

  Future<void> startTracking() async {
    emit(GetCurrentLocationLoadingState());

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      log("Location permission denied.");
      return;
    }
    await Geolocator.getCurrentPosition().then((value) async {
      expertLocation = LatLng(value.latitude, value.longitude);
      mapController?.animateCamera(CameraUpdate.newLatLng(expertLocation!));

      // ✅ Update ETA dynamically
      await getRoute(); //
    });
    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // Update every 5 meters
      ),
    ).listen((Position position) async {
      expertLocation = LatLng(position.latitude, position.longitude);

      // ✅ Update marker position
      markers = markers.map((marker) {
        if (marker.markerId.value == "to") {
          return marker.copyWith(positionParam: expertLocation);
        }
        return marker;
      }).toSet();

      mapController?.animateCamera(CameraUpdate.newLatLng(expertLocation!));

      // ✅ Update ETA dynamically
      await getRoute(); // Fetch new route and update time

      emit(GetCurrentLocationSuccessState());
    });
  }

  void stopTracking() {
    positionStream?.cancel();
  }

  Future<void> getRoute() async {
    if (expertLocation == null || userLocation == null) return;
    polylines = {};
    const String apiKey = "AIzaSyByGILjqDwyW9fMzjnXSCcPB11K8qboJEI";
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${expertLocation!.latitude},${expertLocation!.longitude}&destination=${userLocation!.latitude},${userLocation!.longitude}&key=$apiKey";

    try {
      final response = await sl<DioConsumer>().get(url);
      if (response.statusCode == 200) {
        List<LatLng> polylineCoordinates = _decodePolyline(
            response.data['routes'][0]['overview_polyline']['points']);

        polylines.clear();
        polylines.add(Polyline(
          polylineId: const PolylineId("route"),
          color: AppColors.primaryColor,
          width: 5,
          points: polylineCoordinates,
        ));

        // ✅ Extract duration from API response
        int durationInSeconds = response.data['routes'][0]['legs'][0]
            ['duration']['value']; // In seconds
        estimatedTime = Duration(seconds: durationInSeconds);

        // ✅ Calculate expected arrival time
        arrivalTime = DateTime.now().add(estimatedTime!);

        emit(GetRouteSuccessState());
      }
    } catch (e) {
      log("Error fetching route: $e");
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polylineCoordinates = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int shift = 0, result = 0;
      int byte;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);
      int deltaLat = ((result & 1) == 1 ? ~(result >> 1) : (result >> 1));
      lat += deltaLat;

      shift = 0;
      result = 0;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);
      int deltaLng = ((result & 1) == 1 ? ~(result >> 1) : (result >> 1));
      lng += deltaLng;

      polylineCoordinates.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return polylineCoordinates;
  }
}
