import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_shimmer.dart';

class CustomCachedImage extends StatelessWidget {
  const CustomCachedImage({
    super.key,
    required this.imageUrl,
    this.h,
    this.w,
    this.borderRadius,
    this.fit,
    this.errorWidget,
  });

  final String? imageUrl;
  final double? h, w, borderRadius;
  final BoxFit? fit;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: h ?? 100.r,
      width: w ?? 100.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
        child: CachedNetworkImage(
          imageUrl: imageUrl ?? "",
          placeholder: (context, url) => CustomShimmer(
            h: h,
            w: w,
          ),
          errorWidget: (context, url, error) =>
              errorWidget ?? const Icon(Icons.error),
          fit: fit ?? BoxFit.cover,
        ),
      ),
    );
  }
}
