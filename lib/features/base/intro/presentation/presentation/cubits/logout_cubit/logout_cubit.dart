import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maxless/core/services/service_locator.dart';
import 'package:maxless/features/auth/data/repository/auth_repo.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(LogoutInitial());

  //! Logout
  Future<void> expertLogout() async {
    emit(LogoutLoadingState());
    final result = await sl<AuthRepo>().expertlogout();
    result.fold(
      (l) => emit(LogoutErrorState(message: l)),
      (r) => emit(LogoutSuccessState(message: r)),
    );
  }
}
