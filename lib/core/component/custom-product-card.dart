import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/component/quantity-counter.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/navigation.dart';
import 'package:maxless/core/constants/widgets/custom_button.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final double price;
  final VoidCallback onAddToCart;
  final VoidCallback onFavoriteToggle;
  final bool isFavorited;
  final bool isInCartView; // Determines the layout of the card
  final bool isInWishlistView; // Determines the layout of the card

  const ProductCard({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.onAddToCart,
    required this.onFavoriteToggle,
    this.isFavorited = false,
    this.isInCartView = false, // Default is grid view
    this.isInWishlistView = false, // Default is grid view
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isInCartView) {
      // Layout for Cart View
      return _buildCart(context);
    } else if (isInWishlistView) {
      // Layout for Wishlist View
      return _buildWishlist(context, isWishlist: true);
    } else {
      // Default Layout for Grid View
      return GestureDetector(
        onTap: () {
          // navigateTo(context, ProductDetailsPage());
        },
        child: Padding(
          padding: EdgeInsets.only(top: 30.h),
          child: Container(
            width: 160.w,
            height: 200.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              image: DecorationImage(
                image: AssetImage('./lib/assets/icons/shape.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Background with Image
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 80.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400, // Light font
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w400, // Light font
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$price EGP',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w400, // Light font
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0.h,
                  right: 0.w,
                  child: GestureDetector(
                    onTap: onAddToCart,
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color:
                            Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(15.r),
                          bottomLeft: Radius.circular(1.r),
                          topLeft: Radius.circular(10.r),
                          topRight: Radius.circular(1.r),
                        ),
                      ),
                      child: SvgPicture.asset(
                        './lib/assets/icons/cart.svg',
                        color: AppColors.primaryColor,
                        height: 20.h,
                        width: 20.w,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: -25.h,
                  left: 20.w,
                  right: 20.w,
                  child: Image.asset(
                    imageUrl,
                    height: 100.h,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  top: 55.h,
                  right: 10.w,
                  child: GestureDetector(
                    onTap: onFavoriteToggle,
                    child: Icon(
                      isFavorited
                          ? CupertinoIcons.heart_circle
                          : CupertinoIcons.heart,
                      color: isFavorited
                          ? AppColors.primaryColor
                          : AppColors.primaryColor,
                      size: 20.sp, // Responsive size
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

// Method for Cart and Wishlist Layout
  Widget _buildWishlist(BuildContext context, {required bool isWishlist}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            width: 90.w,
            height: 120.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              image: DecorationImage(
                image: AssetImage('./lib/assets/icons/shape.png'),
                fit: BoxFit.contain,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    imageUrl,
                    height: 90.h,
                    width: 50.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 15.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomElevatedButton(
                      text: "View",
                      color: AppColors.white,
                      width: 90.w,
                      borderRadius: 100,
                      textColor: AppColors.black,
                      borderColor: AppColors.primaryColor,
                      onPressed: () {
                        // navigateTo(context, ProductDetailsPage());
                      },
                    ),
                    SizedBox(width: 8.h),
                    Text(
                      "$price EGP",
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: onFavoriteToggle,
                child: Icon(
                  CupertinoIcons.heart_fill,
                  color: isFavorited ? AppColors.primaryColor : Colors.grey,
                  size: 24.sp,
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCart(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            width: 90.w,
            height: 120.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              image: DecorationImage(
                image: AssetImage('./lib/assets/icons/shape.png'),
                fit: BoxFit.contain,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    imageUrl,
                    height: 90.h,
                    width: 50.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                // Quantity Counter
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    QuantityCounter(
                      initialQuantity: 1,
                      onQuantityChanged: (newQuantity) {
                        print("Quantity updated to $newQuantity");
                      },
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "$price EGP",
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
