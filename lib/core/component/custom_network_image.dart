import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/constants/app_colors.dart';

class CustomNetworkImage extends StatefulWidget {
  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  State<CustomNetworkImage> createState() => _CustomNetworkImageState();
}

class _CustomNetworkImageState extends State<CustomNetworkImage> {
  late String imageKey;

  @override
  void initState() {
    super.initState();
    imageKey = DateTime.now().millisecondsSinceEpoch.toString();
  }

  void reloadImage() {
    setState(() {
      imageKey = DateTime.now().millisecondsSinceEpoch.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Image.network(
        widget.imageUrl,
        key: ValueKey(imageKey),
        height: 200.h,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 200.h,
            decoration: BoxDecoration(
              color: AppColors.lightGrey.withOpacity(.5),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  reloadImage();
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.replay_outlined,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
