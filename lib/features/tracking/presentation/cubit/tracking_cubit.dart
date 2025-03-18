import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/app_constants.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/database/api/dio_consumer.dart';
import 'package:maxless/core/network/local_network.dart';
import 'package:maxless/core/services/service_locator.dart';
import 'package:maxless/features/home/data/models/booking_item_model.dart';
import 'package:maxless/features/reservation/data/repository/session_repo.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'tracking_state.dart';

class TrackingCubit extends Cubit<TrackingState> {
  TrackingCubit() : super(TrackingInitial());

  init({
    required LatLng latLng,
    required GlobalCubit globalCubit,
    required BookingItemModel model,
  }) {
    userLocation = latLng;
    markers = {
      Marker(
        markerId: const MarkerId("to"),
        position: latLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      ),
    };
    bookingId = model.id!;
    initWebSocket(globalCubit);
  }

  late int bookingId;
  bool isNotificationSentSent = false;

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
  Set<Circle> circles = {};
  Set<Polyline> polylines = {};
  StreamSubscription<Position>? positionStream;
  Duration? estimatedTime;
  String? arrivalTime;
  String? remainingDistance;

  Future<void> startTracking() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      log("Location permission denied.");
      return;
    }
    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 50,
      ),
    ).listen((Position position) async {
      expertLocation = LatLng(position.latitude, position.longitude);
      mapController?.animateCamera(CameraUpdate.newLatLng(expertLocation!));

      await getRoute();

      emit(GetCurrentLocationSuccessState());
    });
  }

  void stopTracking() {
    positionStream?.cancel();
  }

  Future<void> getRoute() async {
    emit(GetRouteLoadingState());
    if (expertLocation == null || userLocation == null) return;
    const String apiKey = "AIzaSyByGILjqDwyW9fMzjnXSCcPB11K8qboJEI";
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${expertLocation!.latitude},${expertLocation!.longitude}&destination=${userLocation!.latitude},${userLocation!.longitude}&key=$apiKey";

    try {
      final response = await sl<DioConsumer>().get(url);
      if (response.statusCode == 200) {
        List<LatLng> polylineCoordinates = _decodePolyline(
            response.data['routes'][0]['overview_polyline']['points']);
        polylines = {};
        polylines.add(Polyline(
          polylineId: const PolylineId("route"),
          color: AppColors.primaryColor,
          width: 5,
          points: polylineCoordinates,
        ));

        int durationInSeconds =
            response.data['routes'][0]['legs'][0]['duration']['value'];
        estimatedTime = Duration(seconds: durationInSeconds);

        if (((estimatedTime?.inMinutes)! <= 15) &&
            isNotificationSentSent == false) {
          sendTrackNotification();
        }

        arrivalTime =
            formatTimeWithLocale(DateTime.now().add(estimatedTime!).toString());

        num distanceInMeters =
            response.data['routes'][0]['legs'][0]['distance']['value'];
        double distanceInKm = distanceInMeters.toDouble() / 1000;
        remainingDistance = formatDistance(distanceInKm);

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

  //!WebSocket
  late WebSocketChannel channel;
  void initWebSocket(GlobalCubit globalCubit) {
    log("========== WSS Token: ${sl<CacheHelper>().getDataString(key: AppConstants.wssToken)}");
    //! Connect
    channel = WebSocketChannel.connect(
      Uri.parse(
        "wss://maxliss.evyx.lol/comm2?wss_token=${sl<CacheHelper>().getDataString(key: AppConstants.wssToken)}&user_type=expert",
      ),
    );
    //! Listener
    channel.stream.listen(
      (message) {
        log("========== from web socket $message");
        Future.delayed(
          const Duration(seconds: 10),
          () {
            sendMessage();
          },
        );
      },
      onDone: () {
        log(" ================ Web Socket Done ================");
      },
      onError: (error) {
        log(" ================ $error ================");
      },
    );
  }

  sendMessage() {
    String jsonEncoded = jsonEncode(
        {"lat": expertLocation?.latitude, "long": expertLocation?.longitude});
    channel.sink.add(jsonEncoded);

    emit(SendMessageState());
  }

  @override
  Future<void> close() {
    channel.sink.close();
    return super.close();
  }

  String formatDistance(double distanceInKm) {
    double distanceInMeters = distanceInKm * 1000;
    if (distanceInMeters < 1000) {
      return "${distanceInMeters.toInt()} ${sl<CacheHelper>().getCachedLanguage() == "en" ? "M" : "متر"}";
    } else {
      return "${distanceInKm.toStringAsFixed(2)} ${sl<CacheHelper>().getCachedLanguage() == "en" ? "KM" : "كيلومتر"}";
    }
  }

  String formatTimeWithLocale(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat.jm(sl<CacheHelper>().getCachedLanguage())
        .format(dateTime);
  }

  //! Send Track Notification

  Future<void> sendTrackNotification() async {
    final result = await sl<SessionRepo>().sessionTrackingNotification(
      bookingId: bookingId,
    );
    result.fold(
      (l) {},
      (r) {
        isNotificationSentSent = true;
      },
    );
  }

  //! Formate Time
  String formatDuration() {
    if (estimatedTime != null) {
      final minutes = estimatedTime!.inMinutes;
      if (minutes >= 60) {
        return '${(minutes / 60).floor()} ${sl<CacheHelper>().getCachedLanguage() == "en" ? "hour" : "ساعة"}${(minutes ~/ 60) == 1 ? '' : 's'}';
      } else {
        return '$minutes ${sl<CacheHelper>().getCachedLanguage() == "en" ? "minute" : "دقيقة"}${minutes == 1 ? '' : 's'}';
      }
    } else {
      return "0";
    }
  }
}
