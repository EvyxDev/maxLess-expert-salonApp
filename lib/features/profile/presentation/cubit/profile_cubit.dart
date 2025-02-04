import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maxless/core/services/service_locator.dart';
import 'package:maxless/features/auth/data/models/user_model.dart';
import 'package:maxless/features/community/data/models/community_item_model.dart';
import 'package:maxless/features/profile/data/repository/profile_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  init() async {
    await getExpertProfile();
  }

  //! Get Profile
  UserModel? user;
  List<CommunityItemModel> posts = [];
  Future<void> getExpertProfile() async {
    emit(GetProfileLoadingState());
    final result = await sl<ProfileRepo>().getExpertProfile();
    result.fold(
      (l) => emit(GetProfileErrorState(message: l)),
      (r) {
        user = r.expert;
        posts = r.posts.reversed.toList();
        emit(GetProfileSuccessState());
      },
    );
  }
}
