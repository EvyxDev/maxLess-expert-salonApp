import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/navigation.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/features/reservation/presentation/pages/receipt_details.dart';
import 'package:maxless/features/reservation/presentation/pages/scan_qr.dart';
import 'package:url_launcher/url_launcher.dart';

class ReservationCard extends StatefulWidget {
  final String name;
  final String date;
  final String time;
  final String? image;
  final bool isExpandable;
  final String status; // مكتملة، معلقة، ملغاة
  final VoidCallback? onViewProfile;
  final VoidCallback? onCancel;

  const ReservationCard({
    super.key,
    required this.name,
    required this.date,
    required this.time,
    this.image,
    this.isExpandable = false,
    required this.status,
    this.onViewProfile,
    this.onCancel,
  });

  @override
  State<ReservationCard> createState() => _ReservationCardState();
}

class _ReservationCardState extends State<ReservationCard>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // الصورة
              if (widget.image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.asset(
                    widget.image!,
                    height: 60.h,
                    width: 60.w,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(width: 12.w),
              // النصوص
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // الصف الأول: التاريخ والوقت
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.date,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: const Color(0xff525252),
                            ),
                          ),
                          Text(
                            widget.time,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: const Color(0xff525252),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // الصف الثاني: الاسم
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.name,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        if (widget.isExpandable && widget.status == "Pending")
                          IconButton(
                            icon: Icon(
                              isExpanded
                                  ? CupertinoIcons.chevron_up
                                  : CupertinoIcons.chevron_down,
                              size: 20.sp,
                              color: AppColors.primaryColor,
                            ),
                            onPressed: toggleExpansion,
                          ),
                      ],
                    ),
                    if (widget.status == "Pending")
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          "Service name",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          // أكورديون (في حالة Pending)
          if (widget.isExpandable && isExpanded)
            SizeTransition(
              sizeFactor: _animation,
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  // إضافة اللوكيشن ورقم الهاتف
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (widget.isExpandable &&
                          isExpanded &&
                          widget.name.contains("Salon"))
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // توجيه المستخدم إلى تطبيق الخرائط
                              // مثال: يمكنك استخدام مكتبة `url_launcher`
                              const locationUrl =
                                  "https://www.google.com/maps/search/?api=1&query=Salon+Location";
                              launchUrl(Uri.parse(locationUrl));
                            },
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.location,
                                  color: AppColors.primaryColor,
                                  size: 16.sp,
                                ),
                                SizedBox(width: 5.w),
                                Expanded(
                                  child: Text(
                                    "Salon Location",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.primaryColor,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      SizedBox(width: 16.w),
                      // عرض رقم الهاتف مع رمز الاتصال
                      if (widget.isExpandable &&
                          isExpanded &&
                          widget.name.contains("Salon"))
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // إجراء مكالمة باستخدام `url_launcher`
                              const phoneNumber = "tel:+0123456789";
                              launchUrl(Uri.parse(phoneNumber));
                            },
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.phone,
                                  color: AppColors.primaryColor,
                                  size: 16.sp,
                                ),
                                SizedBox(width: 5.w),
                                Expanded(
                                  child: Text(
                                    "+0123456789",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.primaryColor,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // إذا كان نوع الحجز صالون، أظهر زر QR
                      if (widget.name.contains("Salon"))
                        Expanded(
                          child: CustomElevatedButton(
                            text: "",
                            width: 50,
                            color: AppColors.primaryColor,
                            textColor: AppColors.white,
                            icon: Icon(
                              CupertinoIcons.qrcode,
                              color: AppColors.white,
                              size: 30.sp,
                            ),
                            onPressed: () {
                              navigateTo(context, const ScanQRPage());
                            },
                          ),
                        )
                      else
                        Expanded(
                          child: CustomElevatedButton(
                            text: "View Profile",
                            color: AppColors.primaryColor,
                            textColor: Colors.white,
                            onPressed: widget.onViewProfile,
                          ),
                        ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: CustomElevatedButton(
                          text: "Cancel",
                          color: Colors.white,
                          textColor: AppColors.primaryColor,
                          borderColor: AppColors.primaryColor,
                          onPressed: widget.onCancel,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          // الفوتر (في حالة Completed أو Canceled)
          if (widget.status == "Completed") ...[
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    navigateTo(context, const ReceiptDetailsPage());
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        width: 1.5,
                        color: AppColors.primaryColor,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Details",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Icon(
                          CupertinoIcons.arrow_right,
                          color: AppColors.black,
                          size: 16.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (widget.status == "Canceled") ...[
            SizedBox(height: 10.h),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!widget.name.contains(
                      "Salon")) // الشرط للتحقق من أن الحجز ليس لـ"Salon"
                    GestureDetector(
                      onTap: widget.onViewProfile,
                      child: Text(
                        "View profile",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 12.sp,
                          color: AppColors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  Text(
                    "Canceled",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xff9C9C9C),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
