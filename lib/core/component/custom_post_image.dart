import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/constants/app_colors.dart';

import 'custom_network_image.dart';

class CustomPostImage extends StatelessWidget {
  const CustomPostImage({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
              AlertDialog(
                contentPadding: EdgeInsets.zero,
                elevation: 0,
                content: Stack(
                  children: [
                    SizedBox(
                      width: 320.w,
                      child: ClipRRect(
                        child: CustomNetworkImage(
                          imageUrl: imageUrl,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: AppColors.lightGrey.withOpacity(.3),
                        ),
                        child: const Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      child: SizedBox(
        width: double.infinity,
        child: ClipRRect(
          child: CustomNetworkImage(
            imageUrl: imageUrl,
          ),
        ),
      ),
    );
  }
}
