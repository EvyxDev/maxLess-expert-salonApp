import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maxless/core/network/local_network.dart';
import 'package:maxless/core/services/service_locator.dart';
import 'package:maxless/features/home/data/models/booking_item_model.dart';
import 'package:maxless/features/home/data/repository/home_repo.dart';
import 'package:maxless/features/reservation/data/repository/session_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  init() async {
    DateTime date = DateTime.now();
    await getExpertBookingsByDate(
      day: date.day,
      month: date.month,
      year: date.year,
    );
  }

  //! Get Expert Booking By Date
  List<BookingItemModel> bookings = [];
  Future<void> getExpertBookingsByDate({
    required int day,
    required int month,
    required int year,
  }) async {
    emit(GetBookingByDateLoadingState());
    bookings.clear();
    final result = await sl<HomeRepo>().getExpertBookingsByDate(
      date:
          "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}",
    );
    result.fold(
      (l) => emit(GetBookingByDateErrorState(message: l)),
      (r) {
        bookings = r;
        emit(GetBookingByDateSuccessState());
      },
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

  //! Session Last Step
  Future<void> sessionLastStep({
    required int bookingId,
    required String userType,
    required int userId,
  }) async {
    emit(SessionLastStepLoadingState());
    final result = await sl<SessionRepo>().sessionLastStep(
      bookingId: bookingId,
      userType: userType,
      userId: userId,
    );
    result.fold(
      (l) => emit(SessionLastStepErrorState(message: l)),
      (r) => emit(SessionLastStepSuccessState(message: r)),
    );
  }

  //! Check Session Price
  Future<void> checkSessionPrice({required int bookingId}) async {
    emit(CheckSessionPriceLoadingState());
    final result =
        await sl<SessionRepo>().checkSessionPrice(bookingId: bookingId);
    result.fold(
      (l) => emit(CheckSessionPriceErrorState(message: l)),
      (r) => emit(CheckSessionPriceSuccess(result: r)),
    );
  }
}
