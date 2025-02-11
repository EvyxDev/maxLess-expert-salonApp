import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/locale/app_loacl.dart';

import '../cubit/chatting_cubit.dart';

class ChatReplyBox extends StatefulWidget {
  const ChatReplyBox({super.key});

  @override
  State<ChatReplyBox> createState() => _ChatReplyBoxState();
}

class _ChatReplyBoxState extends State<ChatReplyBox> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChattingCubit, ChattingState>(
      builder: (context, state) {
        final cubit = context.read<ChattingCubit>();
        return cubit.replyingMessage != null
            ? Container(
                color: Colors.grey.shade200,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "replying_to_label".tr(context),
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            cubit.replyingMessage?.message ?? "",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14.sp,
                              fontStyle: FontStyle.italic,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () {
                        cubit.cleaarReplyingMessage();
                        setState(() {});
                        // _animationController.reverse();
                      },
                    ),
                  ],
                ),
              )
            : Container();
      },
    );
  }
}
