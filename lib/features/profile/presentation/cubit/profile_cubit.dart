import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maxless/core/services/service_locator.dart';
import 'package:maxless/features/auth/data/models/user_model.dart';
import 'package:maxless/features/community/data/models/community_item_model.dart';
import 'package:maxless/features/community/data/repo/community_repo.dart';
import 'package:maxless/features/profile/data/repository/profile_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  // init() async {
  //   await getExpertProfile();
  // }

  //! Get Profile
  UserModel? user;
  List<CommunityItemModel> posts = [];
  // Future<void> getExpertProfile() async {
  //   emit(GetProfileLoadingState());
  //   final result = await sl<ProfileRepo>().getExpertProfile();
  //   result.fold(
  //     (l) => emit(GetProfileErrorState(message: l)),
  //     (r) {
  //       user = r.expert;
  //       posts = r.posts.reversed.toList();
  //       emit(GetProfileSuccessState());
  //     },
  //   );
  // }

  //! Show Profile Details
  Future<void> showProfileDetails({required int id}) async {
    emit(GetProfileLoadingState());
    final result = await sl<ProfileRepo>().showProfileDetails(id: id);
    result.fold(
      (l) => emit(GetProfileErrorState(message: l)),
      (r) {
        user = r;
        posts = r.community.reversed.toList();
        emit(GetProfileSuccessState());
      },
    );
  }

  //! Like Post
  Future<void> expertLikeCommunity(int id) async {
    emit(LikeProfileCommunityLoadingState());
    int likes = posts[posts.indexWhere((i) => i.id == id)].likes ?? 0;
    if (posts[posts.indexWhere((i) => i.id == id)].isWishlist == true) {
      if (likes != 0) {
        posts[posts.indexWhere((i) => i.id == id)].likes = likes - 1;
      }
    } else {
      posts[posts.indexWhere((i) => i.id == id)].likes = likes + 1;
    }
    posts[posts.indexWhere((i) => i.id == id)].isWishlist =
        !(posts[posts.indexWhere((i) => i.id == id)].isWishlist as bool);
    final result = await sl<CommunityRepo>().expertLikeCommunity(id);
    result.fold(
      (l) {
        if (posts[posts.indexWhere((i) => i.id == id)].isWishlist == true) {
          if (likes != 0) {
            posts[posts.indexWhere((i) => i.id == id)].likes = likes - 1;
          }
        } else {
          posts[posts.indexWhere((i) => i.id == id)].likes = likes + 1;
        }
        posts[posts.indexWhere((i) => i.id == id)].isWishlist =
            !(posts[posts.indexWhere((i) => i.id == id)].isWishlist as bool);
        emit(LikeProfileCommunityErrorState(message: l));
      },
      (r) {
        emit(LikeProfileCommunitySuccessState(message: r));
      },
    );
  }
}
