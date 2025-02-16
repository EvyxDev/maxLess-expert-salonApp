import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maxless/core/network/local_network.dart';
import 'package:maxless/core/services/service_locator.dart';
import 'package:maxless/features/home/data/models/booking_item_model.dart';
import 'package:maxless/features/requests/data/repository/requestes_repo.dart';
import 'package:url_launcher/url_launcher.dart';

part 'requests_state.dart';

class RequestsCubit extends Cubit<RequestsState> {
  RequestsCubit() : super(RequestsInitial());

  init() async {
    await getExpertRequests();
  }

  //! Get Requests
  List<BookingItemModel> pendingRequests = [];
  List<BookingItemModel> acceptedRequests = [];
  List<BookingItemModel> completedRequests = [];
  List<BookingItemModel> cancelledRequests = [];
  Future<void> getExpertRequests() async {
    emit(GetRequestsLoadingState());
    final result = await sl<RequestesRepo>().getExpertRequests();
    result.fold(
      (l) => emit(GetRequestsErrorState(message: l)),
      (r) {
        pendingRequests.clear();
        acceptedRequests.clear();
        completedRequests.clear();
        cancelledRequests.clear();
        for (var item in r) {
          switch (item.status) {
            case 1:
              pendingRequests.add(item);
              break;
            case 2:
              acceptedRequests.add(item);
              break;
            case 3:
              completedRequests.add(item);
              break;
            case 4:
              cancelledRequests.add(item);
              break;
            default:
          }
        }
        emit(GetRequestsSuccessState());
      },
    );
  }

  //! Change Booking Status
  Future<void> expertChangeBookingStatus({
    required int bookingId,
    required int status,
    required int userId,
  }) async {
    emit(BookingChangeStatusLoadingState());
    final result = await sl<RequestesRepo>().expertChangeBookingStatus(
      bookingId: bookingId,
      status: status,
      userId: userId,
    );
    result.fold(
      (l) => emit(BookingChangeStatusErrorState(message: l)),
      (r) async {
        emit(BookingChangeStatusSuccessState(message: r));
      },
    );
  }

  Future<void> salonChangeBookingStatus({
    required int bookingId,
    required int status,
    required int userId,
  }) async {
    emit(BookingChangeStatusLoadingState());
    final result = await sl<RequestesRepo>().salonChangeBookingStatus(
      bookingId: bookingId,
      status: status,
      userId: userId,
    );
    result.fold(
      (l) => emit(BookingChangeStatusErrorState(message: l)),
      (r) => emit(BookingChangeStatusSuccessState(message: r)),
    );
  }

  //! Cancel Booking Reason
  Future<void> expertCancelReason({
    required int bookingId,
    required int userId,
    required String reason,
    required bool isEmergncy,
  }) async {
    emit(CancelReasonLoadingState());
    final result = await sl<RequestesRepo>().expertCancelReason(
      bookingId: bookingId,
      userId: userId,
      reason: reason,
      isEmergncy: isEmergncy,
    );
    result.fold(
      (l) => emit(CancelReasonErrorState(message: l)),
      (r) => emit(CancelReasonSuccessState(message: r)),
    );
  }

  Future<void> salonCancelReason({
    required int bookingId,
    required int userId,
    required String reason,
    required bool isEmergncy,
  }) async {
    emit(CancelReasonLoadingState());
    final result = await sl<RequestesRepo>().salonCancelReason(
      bookingId: bookingId,
      userId: userId,
      reason: reason,
      isEmergncy: isEmergncy,
    );
    result.fold(
      (l) => emit(CancelReasonErrorState(message: l)),
      (r) => emit(CancelReasonSuccessState(message: r)),
    );
  }

  //! Formate Time
  String formateTime(String time) {
    DateTime dateTime = DateFormat("HH:mm:ss").parse(time);
    String formattedTime =
        DateFormat("h a", sl<CacheHelper>().getCachedLanguage())
            .format(dateTime);

    return formattedTime;
  }

  //! Formate Google Map Link
  String formateGoogleMapLink({required double lat, required double lon}) {
    return "https://www.google.com/maps?q=$lat,$lon";
  }

  //! Launch Url
  Future<void> launchGoogleMapLink(
      {required double lat, required double lon}) async {
    if (await canLaunchUrl(
        Uri.parse("https://www.google.com/maps?q=$lat,$lon"))) {
      launchUrl(Uri.parse("https://www.google.com/maps?q=$lat,$lon"));
    } else {
      throw "Could Not Open Link";
    }
  }
}
