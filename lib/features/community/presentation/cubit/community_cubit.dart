import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maxless/core/services/service_locator.dart';
import 'package:maxless/features/community/data/models/community_item_model.dart';
import 'package:maxless/features/community/data/repo/community_repo.dart';

part 'community_state.dart';

class CommunityCubit extends Cubit<CommunityState> {
  CommunityCubit() : super(CommunityInitial());

  init() async {
    await getExpertCommunity();
  }

  final Dio dio = Dio();
  //! Get Community
  List<CommunityItemModel> community = [];
  Future<void> getExpertCommunity() async {
    emit(GetCommunityLoadingState());
    final result = await sl<CommunityRepo>().expertCommunity();
    result.fold(
      (l) => emit(GetCommunityErrorState(message: l)),
      (r) {
        community = r.data;
        emit(GetCommunitySuccessState());
      },
    );
  }

  //! Like Community
  Future<void> expertLikeCommunity(int id) async {
    emit(LikeCommunityLoadingState());
    int likes = community[community.indexWhere((i) => i.id == id)].likes ?? 0;
    if (community[community.indexWhere((i) => i.id == id)].isWishlist == true) {
      if (likes != 0) {
        community[community.indexWhere((i) => i.id == id)].likes = likes - 1;
      }
    } else {
      community[community.indexWhere((i) => i.id == id)].likes = likes + 1;
    }
    community[community.indexWhere((i) => i.id == id)].isWishlist =
        !(community[community.indexWhere((i) => i.id == id)].isWishlist
            as bool);
    final result = await sl<CommunityRepo>().expertLikeCommunity(id);
    result.fold(
      (l) {
        if (community[community.indexWhere((i) => i.id == id)].isWishlist ==
            true) {
          if (likes != 0) {
            community[community.indexWhere((i) => i.id == id)].likes =
                likes - 1;
          }
        } else {
          community[community.indexWhere((i) => i.id == id)].likes = likes + 1;
        }
        community[community.indexWhere((i) => i.id == id)].isWishlist =
            !(community[community.indexWhere((i) => i.id == id)].isWishlist
                as bool);
        emit(LikeCommunityErrorState(message: l));
      },
      (r) {
        emit(LikeCommunitySuccessState(message: r));
      },
    );
  }

  //! Delete Community
  Future<void> experDeleteCommunity(int id) async {
    emit(DeleteCommunityLoadingState());
    final result = await sl<CommunityRepo>().expertDeleteCommunity(id);
    result.fold(
      (l) => emit(DeleteCommunityErrorState(message: l)),
      (r) => emit(DeleteCommunitySuccessState(message: r)),
    );
  }

  //! Create Post
  GlobalKey<FormState> addPostFormKey = GlobalKey<FormState>();
  TextEditingController postTitleController = TextEditingController();
  List<XFile> postImages = [];
  CommunityItemModel? post;
  Future<void> expertCreatePost() async {
    emit(CreateCommunityLoadingState());
    List<MultipartFile> images = [];
    for (var item in postImages) {
      images.add(await uploadToApi(item));
    }
    final result = await sl<CommunityRepo>().expertCreateCommunity(
      title: postTitleController.text,
      images: images.isNotEmpty ? images : [],
    );
    result.fold(
      (l) => emit(CreateCommunityErrorState(message: l)),
      (r) {
        post = r;
        emit(CreateCommunitySuccessState());
      },
    );
  }

  //! Update Community
  Future<void> expertUpdateCommunity(int id) async {
    emit(UpdateCommunityLoadingState());
    final result = await sl<CommunityRepo>().expertUpdateCommunity(
      id,
      title: null,
      images: null,
      oldImages: null,
    );
    result.fold(
      (l) => emit(UpdateCommunityErrorState(message: l)),
      (r) => emit(UpdateCommunitySuccessState()),
    );
  }

  //! Image Picker
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage({required ImageSource source}) async {
    XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      postImages.add(image);
      emit(PickImageState());
    }
  }

  addPostToList(CommunityItemModel model) {
    community.insert(0, model);
    emit(CreateCommunitySuccessState());
  }

  Future<MultipartFile> uploadToApi(XFile image) async {
    return await MultipartFile.fromFile(
      image.path,
      filename: image.path.split('/').last,
    );
  }
}
