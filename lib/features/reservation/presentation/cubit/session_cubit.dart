import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/services/service_locator.dart';
import 'package:maxless/features/home/data/models/booking_item_model.dart';
import 'package:maxless/features/reservation/data/repository/session_repo.dart';

part 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit() : super(SessionInitial());

  late String userType;
  late int bookingId, userId;
  BookingItemModel? bookingModel;

  //! Start Session
  Future<void> startSession() async {
    emit(StartSessionLoadingState());
    final result = await sl<SessionRepo>().startSession(
      bookingId: bookingId,
      userType: userType,
      userId: userId,
    );
    result.fold(
      (l) => emit(StartSessionErrorState(message: l)),
      (r) => emit(StartSessionSuccessState(message: r)),
    );
  }

  //! End Session
  Future<void> endSession() async {
    emit(EndSessionLoadingState());
    final result = await sl<SessionRepo>().endSession(
      bookingId: bookingId,
      userType: userType,
      userId: userId,
    );
    result.fold(
      (l) => emit(EndSessionErrorState(message: l)),
      (r) => emit(EndSessionSuccessState(message: r)),
    );
  }

  //! Expert Safe
  Future<void> expertSafe() async {
    emit(ExpertSafeLoadingState());
    final result = await sl<SessionRepo>().expertSafe(
      bookingId: bookingId,
      userId: userId,
    );
    result.fold(
      (l) => emit(ExpertSafeErrorState(message: l)),
      (r) => emit(ExpertSafeSuccessState(message: r)),
    );
  }

  //! Take Photo
  XFile? image;
  Future<void> takePhoto() async {
    emit(TakePhotoLoadingState());
    final result = await sl<SessionRepo>().takePhoto(
      bookingId: bookingId,
      userType: userType,
      userId: userId,
      image: await uploadToApi(image!),
    );
    result.fold(
      (l) => emit(TakePhotoErrorState(message: l)),
      (r) => emit(TakePhotoSuccessState(message: r)),
    );
  }

  //! Image Picker
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    XFile? pickedImage = await _picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      image = pickedImage;
      emit(PickImageState());
    }
  }

  //! Upload Xfile to API
  Future<MultipartFile> uploadToApi(XFile image) async {
    return await MultipartFile.fromFile(
      image.path,
      filename: image.path.split('/').last,
    );
  }

  //! Expert Session Feedback
  GlobalKey<FormState> feedbackFromKey = GlobalKey<FormState>();
  TextEditingController feedbackController = TextEditingController();
  int rating = 1;
  Future<void> expertSessionFeedback(BuildContext context) async {
    emit(FeedbackLoadingState());
    final result = await sl<SessionRepo>().expertSessionFeedback(
      review: feedbackController.text,
      expertId: context.read<GlobalCubit>().userId!,
      userId: bookingModel?.id ?? 0,
      rating: rating,
    );
    result.fold(
      (l) => emit(FeedbackErrorState(message: l)),
      (r) => emit(FeedbackSuccessState(message: r)),
    );
  }

  //! Update Feedback
  void updateFeedback(int index) {
    rating = index + 1;
    emit(UpdateFeedbackState());
  }
}
