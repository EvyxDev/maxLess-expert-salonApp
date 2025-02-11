import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/app_strings.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/chatting/presentation/cubit/chatting_cubit.dart';

import 'chat_reply_box.dart';

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({super.key});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar>
    with SingleTickerProviderStateMixin {
  final TextEditingController messageController = TextEditingController();
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChattingCubit, ChattingState>(
      builder: (context, state) {
        final cubit = context.read<ChattingCubit>();
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //! Reply Message Box
              const ChatReplyBox(),
              //! Picked Image
              if (cubit.pickedImage != null)
                Container(
                  height: 200.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Image.file(
                          File(cubit.pickedImage!.path),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: GestureDetector(
                          onTap: () {
                            cubit.pickedImage = null;
                            setState(() {});
                          },
                          child: Container(
                            margin: EdgeInsets.all(8.h),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(.4),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(
                              Icons.close,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              //! Input Bar
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                child: Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    //! Add Document
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(15.r),
                            ),
                          ),
                          builder: (context) => Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title:
                                      Text(AppStrings.takeAPhoto.tr(context)),
                                  onTap: () {
                                    Navigator.pop(context);
                                    cubit
                                        .pickImage(source: ImageSource.camera)
                                        .then((value) {
                                      setState(() {});
                                    });
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: Text(
                                      AppStrings.chooseFromGallery.tr(context)),
                                  onTap: () {
                                    Navigator.pop(context);
                                    cubit
                                        .pickImage(source: ImageSource.gallery)
                                        .then((value) {
                                      setState(() {});
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: const Icon(
                        CupertinoIcons.plus,
                        color: Color(0xffADB5BD),
                      ),
                    ),

                    SizedBox(width: 8.w),

                    //! Text Field
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffF7F7FC),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: TextField(
                          onTap: () {
                            Future.delayed(const Duration(milliseconds: 100),
                                () {
                              cubit.scrollController.animateTo(
                                cubit.scrollController.position.minScrollExtent,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            });
                          },
                          controller: messageController,
                          style: TextStyle(fontSize: 14.sp),
                          decoration: InputDecoration(
                            hintText: AppStrings.writeYourMessage.tr(context),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 12.h,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),

                    //! Send Button
                    messageController.text.isNotEmpty
                        ? AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) =>
                                ScaleTransition(
                              scale: animation,
                              child: child,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                if (messageController.text.isNotEmpty) {
                                  cubit.sendMessage(
                                      context, messageController.text);
                                  messageController.clear();
                                  // _animationController?.reverse();
                                  setState(() {});
                                }
                              },
                              child: const Icon(
                                CupertinoIcons.paperplane,
                                color: Color(0xffADB5BD),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
