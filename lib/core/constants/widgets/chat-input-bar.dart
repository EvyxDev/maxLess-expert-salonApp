import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/widgets/custom_text_form_field.dart';

class ChatInputBar extends StatefulWidget {
  final Function(String)? onSendMessage; // جعلها اختيارية
  final Function(File)? onImagePicked; // جعلها اختيارية
  final Widget? replyBox;

  ChatInputBar({
    this.onSendMessage, // اختيارية
    this.onImagePicked, // اختيارية
    this.replyBox,
  });

  @override
  _ChatInputBarState createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  bool isTyping = false;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  void _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null && widget.onImagePicked != null) {
      widget
          .onImagePicked!(File(pickedFile.path)); // استدعاء فقط إذا تم توفيرها
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.replyBox != null) widget.replyBox!,
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
          child: Row(
            textDirection: TextDirection.ltr, // تثبيت الاتجاه ليكون LTR دائمًا

            children: [
              // زر إضافة صورة
              GestureDetector(
                  onTap: () {
                    if (widget.onImagePicked != null) {
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
                                leading: Icon(Icons.camera_alt),
                                title: Text("Take a photo"),
                                onTap: () {
                                  Navigator.pop(context);
                                  _pickImage(ImageSource.camera);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.photo_library),
                                title: Text("Choose from gallery"),
                                onTap: () {
                                  Navigator.pop(context);
                                  _pickImage(ImageSource.gallery);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                  child: Icon(
                    CupertinoIcons.plus,
                    color: Color(0xffADB5BD),
                  )),
              SizedBox(width: 8.w),

              // الحقل النصي باستخدام الويدجت المخصصة
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffF7F7FC), // لون الخلفية المطلوب
                    borderRadius: BorderRadius.circular(10.r), // زوايا دائرية
                  ),
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(fontSize: 14.sp),
                    decoration: InputDecoration(
                      hintText: Directionality.of(context) == TextDirection.rtl
                          ? "اكتب رسالتك..."
                          : "Aa",
                      border: InputBorder.none, // إزالة البوردر
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 12.h),
                    ),
                    onChanged: (value) {
                      setState(() {
                        isTyping = value.isNotEmpty;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(width: 8.w),

              // زر إرسال أو ميكروفون مع أنيميشن
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300), // مدة الانتقال
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation, // تأثير التكبير/التصغير
                  child: child,
                ),
                child: GestureDetector(
                  onTap: () {
                    if (isTyping && widget.onSendMessage != null) {
                      widget.onSendMessage!(_controller.text);
                      _controller.clear();
                      setState(() {
                        isTyping = false;
                        _animationController?.reverse();
                      });
                    } else if (!isTyping) {
                      print("Start voice recording...");
                    }
                  },
                  child: Icon(
                    key: ValueKey<bool>(isTyping), // مفتاح مميز لكل حالة
                    isTyping ? CupertinoIcons.paperplane : CupertinoIcons.mic,
                    color: Color(0xffADB5BD),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
