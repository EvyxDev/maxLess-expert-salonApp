import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/component/custom_loading_indicator.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/features/chatting/presentation/cubit/chatting_cubit.dart';
import 'package:maxless/features/chatting/presentation/widgets/chat_header.dart';
import 'package:maxless/features/chatting/presentation/widgets/chat_input_bar.dart';
import 'package:maxless/features/chatting/presentation/widgets/chat_message_bubble.dart';

class CustomerServiceChat extends StatefulWidget {
  const CustomerServiceChat({super.key});

  @override
  State<CustomerServiceChat> createState() => _CustomerServiceChatState();
}

class _CustomerServiceChatState extends State<CustomerServiceChat>
    with SingleTickerProviderStateMixin {
  Map<int, double> dragOffsets = {};
  final Map<int, ValueKey> itemKeys = {};
  late AnimationController _animationController;
  late Animation<double> _animation;
  int? selectedIndex;
  int? swipeingIndex;
  double dragOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 0, end: 0).animate(_animationController)
      ..addListener(() {
        setState(() {
          dragOffset = _animation.value;
        });
      });
  }

  void resetSwipe(int index) {
    _animation = Tween<double>(begin: dragOffsets[index] ?? 0, end: 0)
        .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ))
      ..addListener(() {
        setState(() {
          swipeingIndex = null;
          dragOffsets[index] = _animation.value;
        });
      });

    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChattingCubit()..init(context.read<GlobalCubit>()),
      child: BlocConsumer<ChattingCubit, ChattingState>(
        listener: (context, state) {
          if (state is GetChatHistorySuccessState) {
            final cubit = context.read<ChattingCubit>();
            Future.delayed(const Duration(milliseconds: 100), () {
              cubit.scrollController.animateTo(
                cubit.scrollController.position.minScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            });
          }
          if (state is AddMessageState) {
            setState(() {});
          }
        },
        builder: (context, state) {
          final cubit = context.read<ChattingCubit>();
          return Scaffold(
            backgroundColor: const Color(0xffFBFBFB),
            body: Column(
              children: [
                SizedBox(height: 20.h),
                //! Header
                const ChatHeader(),
                //! Messages
                Expanded(
                  child: state is GetChatHistoryLoadingState
                      ? const CustomLoadingIndicator()
                      : ListView.builder(
                          reverse: true,
                          controller: cubit.scrollController,
                          padding: EdgeInsets.all(16.w),
                          itemCount: cubit.chat.length,
                          itemBuilder: (context, index) {
                            String? message = cubit.chat[index].message;
                            bool isUser = cubit.chat[index].sender.id ==
                                context.read<GlobalCubit>().userId;
                            itemKeys[index] = ValueKey(cubit.chat[index].id);
                            return message != null
                                ? Container(
                                    key: ValueKey(cubit.chat[index].id),
                                    decoration: BoxDecoration(
                                      color: selectedIndex == index
                                          ? AppColors.lightGrey.withOpacity(.3)
                                          : AppColors.transparent,
                                      borderRadius:
                                          BorderRadiusDirectional.only(
                                        bottomEnd: Radius.circular(16.r),
                                        bottomStart: Radius.circular(16.r),
                                        topEnd:
                                            Radius.circular(isUser ? 16.r : 0),
                                        topStart:
                                            Radius.circular(!isUser ? 16.r : 0),
                                      ),
                                    ),
                                    child: GestureDetector(
                                      onHorizontalDragUpdate: (details) {
                                        setState(() {
                                          if (swipeingIndex != index) {
                                            swipeingIndex = index;
                                          }
                                          dragOffset += details.delta.dx;
                                        });
                                      },
                                      onHorizontalDragEnd: (_) {
                                        if ((dragOffset < -50 && !isUser) ||
                                            dragOffset < 50 && isUser) {
                                          cubit.setReplyMessage(index);
                                          resetSwipe(index);
                                        } else {
                                          resetSwipe(index);
                                        }
                                      },
                                      child: Transform.translate(
                                        offset: Offset(
                                            swipeingIndex == index
                                                ? dragOffset
                                                : 0,
                                            0),
                                        child: ChatMessageBubble(
                                          model: cubit.chat[index],
                                          isUser: cubit.chat[index].sender.id ==
                                              context
                                                  .read<GlobalCubit>()
                                                  .userId,
                                          onRepliedToTap: () {
                                            int? messageId =
                                                cubit.chat[index].reply?.id;
                                            if (messageId != null) {
                                              final cubit =
                                                  context.read<ChattingCubit>();
                                              int messageIndex = cubit.chat
                                                  .indexWhere(
                                                      (e) => e.id == messageId);

                                              if (messageIndex != -1) {
                                                double offset =
                                                    messageIndex * 80.0;
                                                cubit.scrollController
                                                    .animateTo(
                                                  offset,
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.easeInOut,
                                                );

                                                selectedIndex = messageIndex;
                                                setState(() {});

                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 800), () {
                                                  setState(() {
                                                    selectedIndex = null;
                                                  });
                                                });
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                : Container();
                          },
                        ),
                ),
                //! Input & Replying Message
                const ChatInputBar(),
              ],
            ),
          );
        },
      ),
    );
  }
}
