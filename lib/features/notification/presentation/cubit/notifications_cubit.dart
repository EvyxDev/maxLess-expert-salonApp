import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maxless/core/services/service_locator.dart';
import 'package:maxless/features/notification/data/models/notification_model.dart';
import 'package:maxless/features/notification/data/repository/notifications_repo.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial());

  //! Get Notifications
  List<NotificationModel> notifications = [];
  Future<void> getExpertNotifications() async {
    emit(GetNotificationsLoadingState());
    final result = await sl<NotificationsRepo>().getExpertNotifications();
    result.fold(
      (l) => emit(GetNotificationsErrorState(message: l)),
      (r) {
        notifications = r;
        emit(GetNotificationsSuccessState());
      },
    );
  }
}
