import 'package:flutter/material.dart';
import 'package:maxless/core/component/custom_header.dart';
import 'package:maxless/core/locale/app_loacl.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      title: "sos".tr(context),
      onBackPress: () {
        Navigator.pop(context);
      },
      // trailing: TextButton(
      //   onPressed: _showEndChatDialog,
      //   child: Text(
      //     "End Chat",
      //     style: TextStyle(color: AppColors.primaryColor, fontSize: 14.sp),
      //   ),
      // ),
    );
  }
}
