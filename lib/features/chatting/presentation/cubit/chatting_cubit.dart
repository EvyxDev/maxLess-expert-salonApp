import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:maxless/core/constants/app_constants.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/network/local_network.dart';
import 'package:maxless/core/services/service_locator.dart';
import 'package:maxless/features/chatting/data/models/message_model.dart';
import 'package:maxless/features/chatting/data/models/receiver_model.dart';
import 'package:maxless/features/chatting/data/models/sender_model.dart';
import 'package:maxless/features/chatting/data/repository/chatting_repo.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../data/models/reply_model.dart';

part 'chatting_state.dart';

class ChattingCubit extends Cubit<ChattingState> {
  ChattingCubit() : super(ChattingInitial());

  init(GlobalCubit globalCubit) async {
    initWebSocket(globalCubit);
    await getExpertChatHistory();
  }

  //! Get Expert Chat History
  List<MessageModel> chat = [];
  Future<void> getExpertChatHistory() async {
    emit(GetChatHistoryLoadingState());
    final result = await sl<ChattingRepo>().getExpertChatHistory();
    result.fold(
      (l) => emit(GetChatHistoryErrorState()),
      (r) {
        chat = r.reversed.toList();
        emit(GetChatHistorySuccessState());
      },
    );
  }

  //! Formate Time
  String formateTime(String time) {
    DateTime dateTime = DateTime.parse(time);
    String formattedTime = DateFormat('hh:mm a').format(dateTime.toLocal());
    return formattedTime;
  }

  final ScrollController scrollController = ScrollController();

  //!WebSocket
  late WebSocketChannel channel;
  void initWebSocket(GlobalCubit globalCubit) {
    //! Connect
    channel = WebSocketChannel.connect(
      Uri.parse(
        "wss://maxliss.evyx.lol/comm?wss_token=${sl<CacheHelper>().getDataString(key: AppConstants.wssToken)}&user_type=expert",
      ),
    );
    //! Listener
    channel.stream.listen(
      (message) {
        log(message);
        Map<String, dynamic> json = jsonDecode(message);
        switch (json["type"]) {
          case 0:
            List<MessageModel> newList = [];
            newList.insert(
              0,
              MessageModel(
                id: json["id"],
                message: json["msg"],
                createdAt: DateTime.now().toString(),
                sender: SenderModel(
                  id: globalCubit.userId,
                  name: globalCubit.userName,
                  image: globalCubit.userImageUrl,
                ),
                receiver: ReceiverModel(
                  id: null,
                  name: null,
                  avatar: null,
                ),
                reply: json["replyMessage"] != null
                    ? ReplyModel.fromJson(json["replyMessage"])
                    : null,
              ),
            );
            chat = newList + chat;
            emit(GetChatHistorySuccessState());
            break;
          case 1:
            List<MessageModel> newList = [];
            newList.insert(
              0,
              MessageModel(
                id: json["id"],
                message: json["msg"],
                createdAt: DateTime.now().toString(),
                sender: SenderModel(
                  id: null,
                  name: null,
                  image: null,
                ),
                receiver: ReceiverModel(
                  id: json["receiver"]["id"],
                  name: json["receiver"]["name"],
                  avatar: null,
                ),
                reply: json["replyMessage"] != null
                    ? ReplyModel.fromJson(json["replyMessage"])
                    : null,
              ),
            );
            chat = newList + chat;
            emit(GetChatHistorySuccessState());
            break;
          default:
        }

        Future.delayed(const Duration(milliseconds: 100), () {
          scrollController.animateTo(
            scrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
        emit(GetChatHistorySuccessState());
      },
      onDone: () {
        log(" ================ Web Socket Done");
      },
      onError: (error) {
        log(" ================ $error");
      },
    );
  }

  sendMessage(BuildContext context, String message) {
    String jsonEncoded = replyingMessage != null
        ? jsonEncode({"msg": message, "reply_id": replyingMessage!.id})
        : jsonEncode({"msg": message});
    channel.sink.add(jsonEncoded);

    replyingMessage = null;
    Future.delayed(const Duration(milliseconds: 100), () {
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
    emit(AddMessageState());
  }

  @override
  Future<void> close() {
    channel.sink.close();
    scrollController.dispose();
    return super.close();
  }

  //! Reply Message
  MessageModel? replyingMessage;

  setReplyMessage(int index) {
    replyingMessage = chat[index];
    emit(AddMessageState());
  }

  cleaarReplyingMessage() {
    replyingMessage = null;
    emit(ClearMessageState());
  }

  //! Image Picker
  XFile? pickedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage({required ImageSource source}) async {
    XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      pickedImage = image;
      emit(PickImageState());
    }
  }
}
