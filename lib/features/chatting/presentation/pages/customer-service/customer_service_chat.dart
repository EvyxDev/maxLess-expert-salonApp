import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/component/custom_header.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/widgets/chat_input_bar.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:intl/intl.dart'; // مكتبة لتنسيق الوقت

class CustomerServiceChat extends StatefulWidget {
  const CustomerServiceChat({super.key});

  @override
  State<CustomerServiceChat> createState() => _CustomerServiceChatState();
}

class _CustomerServiceChatState extends State<CustomerServiceChat>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool isChatEnded = false;
  Map<String, dynamic>? replyingMessage;
  Map<int, double> dragOffsets = {}; // تتبع السحب لكل رسالة

  late AnimationController _animationController;
  late Animation<double> _replyBoxAnimation;

  final List<Map<String, dynamic>> messages = [
    {
      "type": "bot",
      "content": "Welcome to Maxille! I'm your AI assistant.",
      "time": "16:30",
    },
    {
      "type": "user",
      "content": "Can I come over?",
      "time": "16:44",
    },
    {
      "type": "bot",
      "content": "Of course, let me know if you’re on your way.",
      "time": "16:46",
    },
    {
      "type": "user",
      "content": "K, I’m on my way",
      "time": "16:50",
    },
    {
      "type": "user",
      "content": "Test message replying to another",
      "repliedTo": "Of course, let me know if you’re on your way.",
      "time": "12:46 PM",
    },
    {
      "type": "bot",
      "content": "Test message replying to another",
      "repliedTo": "Of course, let me know if you’re on your way.",
      "time": "12:46 PM",
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _replyBoxAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFBFBFB),
      body: Column(
        children: [
          SizedBox(height: 20.h),
          _buildHeader(),
          // SizeTransition(
          //   sizeFactor: _replyBoxAnimation,
          //   axisAlignment: -1.0,
          //   child:
          //       replyingMessage != null ? _buildReplyBox() : SizedBox.shrink(),
          // ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16.w),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUser = message['type'] == 'user';

                return GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      dragOffsets[index] =
                          (dragOffsets[index] ?? 0.0) + details.delta.dx;
                    });
                  },
                  onHorizontalDragEnd: (_) {
                    if (dragOffsets[index] != null) {
                      if (isUser && dragOffsets[index]! < 50) {
                        // عند السحب لليمين
                        setState(() {
                          replyingMessage = message;
                          dragOffsets[index] = 0.0;
                        });
                        setState(() {
                          replyingMessage = message;
                          _animationController.forward();
                        });
                      } else if (!isUser && dragOffsets[index]! > 50) {
                        // عند السحب لليسار
                        setState(() {
                          replyingMessage = message;
                          dragOffsets[index] = 0.0;
                        });
                        setState(() {
                          replyingMessage = message;
                          _animationController.forward();
                        });
                      } else {
                        setState(() {
                          dragOffsets[index] = 0.0;
                        });
                      }
                    }
                  },
                  child: Transform.translate(
                    offset: Offset(
                        dragOffsets[index] ?? 0.0, 0), // التحرك بناءً على السحب
                    child: _buildMessageBubble(message),
                  ),
                );
              },
            ),
          ),
          if (!isChatEnded)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ChatInputBar(
                onSendMessage: (message) {
                  if (message.isNotEmpty) {
                    _addMessage(message); // إضافة الرسالة إلى القائمة
                  }
                },
                // onUploadImage: () {
                //   print("Upload Image Clicked");
                // },
                replyBox: replyingMessage != null
                    ? SizeTransition(
                        sizeFactor: _replyBoxAnimation,
                        axisAlignment: -1.0,
                        child: _buildReplyBox(),
                      )
                    : null,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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

  // ignore: unused_element
  void _showEndChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        alignment: Alignment.center,
        title: Text(
          "Do you want to end chat?",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black),
        ),
        content: Text(
          "You will not be able to reply to this chat again.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.primaryColor,
          ),
        ),
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          Row(
            children: [
              Expanded(
                child: CustomElevatedButton(
                  text: "Yes",
                  color: Colors.white,
                  borderRadius: 10,
                  borderColor: AppColors.primaryColor,
                  textColor: AppColors.primaryColor,
                  onPressed: () {
                    setState(() {
                      isChatEnded = true;
                    });
                    Navigator.pop(context); // Close the dialog
                  },
                ),
              ),
              SizedBox(width: 10.h), // مسافة بين الأزرار

              Expanded(
                child: CustomElevatedButton(
                  text: "No",
                  borderRadius: 10,
                  color: AppColors.primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigator.pop(context); // إغلاق المودال
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReplyBox() {
    return Container(
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
                  replyingMessage?['content'] ?? '',
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
              setState(() {
                replyingMessage = null;
                _animationController.reverse();
              });
            },
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _buildSwipeBackground(bool isUser) {
    return Container(
      alignment: isUser ? Alignment.centerLeft : Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      color: AppColors.primaryColor.withOpacity(0.1),
      child: const Icon(
        Icons.reply,
        color: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final bool isUser = message['type'] == 'user';
    final String? repliedTo = message['repliedTo'];

    // التحقق من اتجاه اللغة
    // ignore: unrelated_type_equality_checks
    final bool isRTL = Directionality.of(context) == TextDirection.RTL;

    // تنسيق الوقت
    String formattedTime =
        message['time'] ?? DateFormat('hh:mm a').format(DateTime.now());

    return Align(
      alignment: isUser
          ? (isRTL ? Alignment.centerLeft : Alignment.centerLeft)
          : (isRTL ? Alignment.centerRight : Alignment.centerRight),
      child: Column(
        crossAxisAlignment: isUser
            ? (isRTL ? CrossAxisAlignment.start : CrossAxisAlignment.end)
            : (isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start),
        children: [
          if (repliedTo != null) // عرض الرسالة التي تم الرد عليها
            Container(
              margin: EdgeInsets.only(bottom: 5.h),
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.only(
                  topLeft:
                      Radius.circular(isUser ? (isRTL ? 16.r : 16.r) : 16.r),
                  topRight:
                      Radius.circular(isUser ? (isRTL ? 0.0 : 16.r) : 0.0),
                  bottomLeft: Radius.circular(16.r),
                  bottomRight: Radius.circular(16.r),
                ),
              ),
              child: Text(
                repliedTo,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 12.sp,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5.h),
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
            decoration: BoxDecoration(
              color: isUser ? AppColors.primaryColor : Colors.grey.shade200,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isUser ? (isRTL ? 20.r : 0) : 20.r),
                topRight: Radius.circular(isUser ? (isRTL ? 0.0 : 20.r) : 20.r),
                bottomLeft: Radius.circular(20.r),
                bottomRight: Radius.circular(20.r),
              ),
            ),
            child: message['type'] == 'audio'
                ? Row(
                    children: [
                      Icon(Icons.play_arrow,
                          color: isUser ? Colors.white : Colors.black),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Container(
                          height: 20.h,
                          decoration: BoxDecoration(
                            color: isUser ? Colors.white : Colors.black12,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              8,
                              (index) => Container(
                                height: index % 2 == 0 ? 10.h : 15.h,
                                width: 3.w,
                                color: AppColors.primaryColor.withOpacity(0.7),
                                margin: EdgeInsets.symmetric(horizontal: 1.w),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        message['duration'] ?? '0:00',
                        style: TextStyle(
                            color: isUser ? Colors.white : Colors.black,
                            fontSize: 12.sp),
                      ),
                    ],
                  )
                : Text(
                    message['content'] ?? '',
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black,
                      fontSize: 14.sp,
                    ),
                  ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            child: Text(
              formattedTime,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addMessage(String message) {
    setState(() {
      messages.add({
        "type": "user",
        "content": message,
        "time": TimeOfDay.now().format(context),
        if (replyingMessage != null) "repliedTo": replyingMessage!['content']!,
      });
      replyingMessage = null; // Reset reply
      _animationController.reverse();
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }
}
