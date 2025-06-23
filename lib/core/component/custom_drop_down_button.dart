import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/widgets/text_style.dart';


class CustomDropDownButton extends StatelessWidget {
  const CustomDropDownButton({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.labelStyle,
    this.validator,
    required this.value,
    this.enabled =
        true, // Add the enabled property with a default value of true
  });

  final String label;
  final TextStyle? labelStyle;
  final List<DropdownMenuItem<dynamic>>? items;
  final Function(dynamic)? onChanged;
  final String? Function(Object?)? validator;
  final dynamic value;
  final bool enabled; // Add the enabled property

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<dynamic>(
      hint: Text(label, style: CustomTextStyle.font400sized14Black),
      value: value,
      borderRadius: BorderRadius.circular(8),
      items: items,
      onChanged:
          enabled
              ? onChanged
              : null, // Disable the dropdown if enabled is false
      dropdownColor: AppColors.white,
      focusColor: const Color(0xff121212),
      validator: validator,
      decoration: InputDecoration(
        fillColor: AppColors.white,
        filled: true,
        border: getBorderStyle(context),
        enabledBorder: getBorderStyle(context),
        focusedBorder: getBorderStyle(context),
        errorBorder: getBorderStyle(context),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      ),
      isExpanded: true,
    );
  }
}

OutlineInputBorder getBorderStyle(context) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: AppColors.lightGrey, width: 1.w),
  );
}
