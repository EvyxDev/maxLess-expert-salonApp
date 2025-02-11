import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/features/chatting/data/models/message_model.dart';
import 'package:maxless/features/chatting/presentation/cubit/chatting_cubit.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    super.key,
    required this.model,
    required this.isUser,
    required this.onRepliedToTap,
  });

  final MessageModel model;
  final bool isUser;
  final Function() onRepliedToTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChattingCubit, ChattingState>(
      builder: (context, state) {
        final cubit = context.read<ChattingCubit>();
        return Align(
          alignment: isUser
              ? AlignmentDirectional.centerEnd
              : AlignmentDirectional.centerStart,
          child: Column(
            crossAxisAlignment:
                isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              //! Replied Message
              if (model.reply != null)
                GestureDetector(
                  onTap: onRepliedToTap,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5.h),
                    padding:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      // borderRadius: BorderRadius.only(
                      //   topLeft: Radius.circular(isUser ? 0 : 16.r),
                      //   topRight: Radius.circular(isUser ? 16.r : 0.0),
                      //   bottomLeft: Radius.circular(16.r),
                      //   bottomRight: Radius.circular(16.r),
                      // ),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      model.reply?.message ?? "",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 12.sp,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              //! Message
              Container(
                margin: EdgeInsets.symmetric(vertical: 5.h),
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                decoration: BoxDecoration(
                  color: isUser ? AppColors.primaryColor : Colors.grey.shade200,
                  borderRadius: BorderRadiusDirectional.only(
                    // topEnd: Radius.circular(!isUser ? 20.r : 0),
                    // topStart: Radius.circular(!isUser ? 0 : 20.r),
                    // bottomEnd: Radius.circular(20.r),
                    // bottomStart: Radius.circular(20.r),
                    bottomStart: Radius.circular(isUser ? 16.r : 0),
                    bottomEnd: Radius.circular(isUser ? 0 : 16.r),
                    topStart: Radius.circular(20.r),
                    topEnd: Radius.circular(16.r),
                  ),
                ),
                child:
                    // message['type'] == 'audio'
                    // ? Row(
                    //     children: [
                    //       Icon(Icons.play_arrow,
                    //           color: isUser ? Colors.white : Colors.black),
                    //       SizedBox(width: 10.w),
                    //       Expanded(
                    //         child: Container(
                    //           height: 20.h,
                    //           decoration: BoxDecoration(
                    //             color: isUser ? Colors.white : Colors.black12,
                    //             borderRadius: BorderRadius.circular(10.r),
                    //           ),
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //             children: List.generate(
                    //               8,
                    //               (index) => Container(
                    //                 height: index % 2 == 0 ? 10.h : 15.h,
                    //                 width: 3.w,
                    //                 color: AppColors.primaryColor.withOpacity(0.7),
                    //                 margin: EdgeInsets.symmetric(horizontal: 1.w),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       SizedBox(width: 10.w),
                    //       Text(
                    //         message['duration'] ?? '0:00',
                    //         style: TextStyle(
                    //             color: isUser ? Colors.white : Colors.black,
                    //             fontSize: 12.sp),
                    //       ),
                    //     ],
                    //   )
                    // :
                    Text(
                  model.message ?? "",
                  style: TextStyle(
                    color: isUser ? Colors.white : Colors.black,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                child: Text(
                  model.createdAt != null
                      ? cubit.formateTime(model.createdAt!)
                      : "",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
