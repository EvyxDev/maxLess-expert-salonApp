import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'set_location_state.dart';

class SetLocationCubit extends Cubit<SetLocationState> {
  SetLocationCubit() : super(SetLocationInitial());

  // //! Set Location
  // Future<void> expertSetLocation() async {
  //   if (latitude != null && longitude != null) {
  //     emit(SetLocationLoadingState());
  //     final result = await sl<AuthRepo>().expertSetLocation(
  //       lat: latitude!,
  //       lon: longitude!,
  //     );
  //     result.fold(
  //       (l) => emit(SetLocationErrorState(message: l)),
  //       (r) => emit(SetLocationSuccessState(message: r)),
  //     );
  //   }
  // }
}
