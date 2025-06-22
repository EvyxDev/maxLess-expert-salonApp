import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';
import 'package:maxless/core/locale/app_loacl.dart';

class SelectSlotTimeBottomSheet extends StatefulWidget {
  const SelectSlotTimeBottomSheet({super.key, required this.initTime});
  final String initTime;
  @override
  State<SelectSlotTimeBottomSheet> createState() =>
      _SelectSlotTimeBottomSheetState();
}

class _SelectSlotTimeBottomSheetState extends State<SelectSlotTimeBottomSheet> {
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    List<String> parts = widget.initTime.split(":");
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    selectedDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      hour,
      minute,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'select_time'.tr(context).toUpperCase(),
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedDate = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedDate.hour - 1,
                        selectedDate.minute,
                      );
                    });
                  },
                  icon: const RotatedBox(
                    quarterTurns: 1,
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 24,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  selectedDate.hour.toString().padLeft(2, '0'),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedDate = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedDate.hour + 1,
                        selectedDate.minute,
                      );
                    });
                  },
                  icon: const RotatedBox(
                    quarterTurns: 3,
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 24.w,
            ),
            Text(
              ':',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: 24.w,
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedDate = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedDate.hour,
                        selectedDate.minute - 1,
                      );
                    });
                  },
                  icon: const RotatedBox(
                    quarterTurns: 1,
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 24,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  selectedDate.minute.toString().padLeft(2, '0'),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedDate = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedDate.hour,
                        selectedDate.minute + 1,
                      );
                    });
                  },
                  icon: const RotatedBox(
                    quarterTurns: 3,
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 24,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        SizedBox(
          height: 16.h,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomElevatedButton(
            text: "save".tr(context),
            onPressed: () {
              Navigator.pop(context,
                  "${selectedDate.hour.toString().padLeft(2, '0')}:${selectedDate.minute.toString().padLeft(2, '0')}");
            },
          ),
        )
      ],
    );
  }
}
