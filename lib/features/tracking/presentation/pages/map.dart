import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/component/custom-header.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/navigation.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';

class TrackingPage extends StatefulWidget {
  @override
  _TrackingPageState createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  bool isArrived = false;

  void showFeedbackPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان الرئيسي
                  Center(
                    child: Text(
                      "Tell us your feedback 🙌",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Center(
                    child: Text(
                      "Rate the expert based on your experience to improve the service for everyone",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // الخيارات مع مربعات الاختيار
                  _buildFeedbackOption("ID"),
                  _buildFeedbackOption("Lab coat"),
                  SizedBox(height: 20.h),

                  // الفئات مع تقييم النجوم
                  _buildRatingCategory("Efficiency"),
                  SizedBox(height: 10.h),
                  _buildRatingCategory("Personal hygiene"),
                  SizedBox(height: 10.h),
                  _buildRatingCategory("Smell"),
                  SizedBox(height: 10.h),
                  _buildRatingCategory("Overall appearance"),
                  SizedBox(height: 20.h),

                  // حقل النص
                  TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Write something for us!",
                      hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // زر الإرسال
                  Center(
                    child: CustomElevatedButton(
                      text: "Send",
                      color: AppColors.primaryColor,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.pop(context); // إغلاق نافذة التقييم
                        // إضافة منطق الإرسال هنا إذا لزم الأمر
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeedbackOption(String label) {
    bool isChecked = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 14.sp, color: Colors.black),
              ),
              Checkbox(
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value ?? false;
                  });
                },
                activeColor: AppColors.primaryColor,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRatingCategory(String label) {
    int selectedStars = 0;

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 14.sp, color: Colors.black),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedStars = index + 1;
                      });
                    },
                    child: Icon(
                      index < selectedStars ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          SizedBox(height: 20.h),
          CustomHeader(
            title: "Tracking The Expert",
            onBackPress: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: Center(
              child: Image.asset(
                'lib/assets/maps.png',
                width: double.infinity,
                fit: BoxFit.cover,
              ), // Replace with your map image
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(
                  'lib/assets/expert.png'), // Replace with user's image
            ),
            title: Text("May Ahmed"),
            subtitle: Text("Updated just now"),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomElevatedButton(
              text: isArrived ? "End Session" : "Arrived",
              color: isArrived ? Colors.white : AppColors.primaryColor,
              borderColor:
                  isArrived ? AppColors.primaryColor : Colors.transparent,
              textColor: isArrived ? AppColors.primaryColor : Colors.white,
              borderRadius: 8,
              onPressed: () {
                if (isArrived) {
                  showFeedbackPopup(context);
                } else {
                  setState(() {
                    isArrived = true;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
