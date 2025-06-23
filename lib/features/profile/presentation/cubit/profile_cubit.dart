import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/services/service_locator.dart';
import 'package:maxless/features/auth/data/models/user_model.dart';
import 'package:maxless/features/community/data/models/community_item_model.dart';
import 'package:maxless/features/community/data/repo/community_repo.dart';
import 'package:maxless/features/profile/data/models/review_model.dart';
import 'package:maxless/features/profile/data/models/states/my_states.dart';
import 'package:maxless/features/profile/data/repository/profile_repo.dart';

import '../../data/models/states/city.dart';
import '../../data/models/states/datum.dart';

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
    await getSates();
    await getMySates();
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

  //! Get Reviews
  List<ReviewModel> reviews = [];
  Future<void> getReviews({required int id}) async {
    emit(GetReviewsLoadingState());
    final result = await sl<ProfileRepo>().getReviews(id: id);
    result.fold(
      (l) => emit(GetReviewsErrorState(message: l)),
      (r) {
        reviews = r;
        emit(GetReviewsSuccessState());
      },
    );
  }

  //! Upload Xfile to API
  Future<MultipartFile> uploadToApi(XFile image) async {
    return await MultipartFile.fromFile(
      image.path,
      filename: image.path.split('/').last,
    );
  }

  //! Update Profile Image
  Future<void> updateProfileImage(BuildContext context,
      {required ImageSource source}) async {
    XFile? pickedImage;
    ImagePicker picker = ImagePicker();

    pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      pickedImage = pickedImage;
      emit(PickImageState());
    }
    emit(UpdateProfileImageLoadingState());
    final result = await sl<ProfileRepo>().updateProfileImage(
      image: pickedImage != null ? await uploadToApi(pickedImage) : null,
    );

    result.fold(
      (l) => emit(UpdateProfileImageErrorState(message: l)),
      (r) {
        showProfileDetails(id: context.read<GlobalCubit>().userId!);
        emit(UpdateProfileImageSuccessState(message: r));
      },
    );
  }

  //! Get States
  List<Governorate> governorates = [];
  List<City> cities = [];
  getSates() async {
    final result = await sl<ProfileRepo>().getStates();
    result.fold(
      (l) => {log(l)},
      (r) {
        governorates = r.governorates ?? [];
        log(governorates.length.toString());
      },
    );
  }

  MyStates? myStates;
  getMySates() async {
    final result = await sl<ProfileRepo>().getMyStates();
    result.fold(
      (l) => {},
      (r) {
        myStates = r;
      },
    );
  }
}
