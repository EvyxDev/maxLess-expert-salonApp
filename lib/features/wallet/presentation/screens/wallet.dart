import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/component/custom-header.dart';
import 'package:maxless/core/component/custom_modal_progress_indicator.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/constants/app_strings.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/wallet/presentation/cubit/wallet_cubit.dart';
import 'package:maxless/features/wallet/presentation/widgets/transaction_card.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WalletCubit()..getExpertWallet(context),
      child: BlocBuilder<WalletCubit, WalletState>(
        builder: (context, state) {
          final cubit = context.read<WalletCubit>();
          return Scaffold(
            backgroundColor: AppColors.white,
            body: CustomModalProgressIndicator(
              inAsyncCall: state is GetWalletLoadingState ? true : false,
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  CustomHeader(
                    title: "wallet_label".tr(context),
                    onBackPress: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: 10.h),

                  //! Balance Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Container(
                      padding: EdgeInsets.all(30.w),
                      decoration: BoxDecoration(
                        color: const Color(0xffFFE2EC),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.totalBalance.tr(context),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //! Money Amount
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "${cubit.totalBalance ?? 0.0} ",
                                      style: TextStyle(
                                        fontSize: 35.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "egp".tr(context),
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //! Details Button
                              // GestureDetector(
                              //   onTap: () {
                              //     // navigateTo(context, TransactionsPage());
                              //   },
                              //   child: Container(
                              //     padding: EdgeInsets.symmetric(
                              //         horizontal: 12.w, vertical: 8.h),
                              //     decoration: BoxDecoration(
                              //       color: Colors.white,
                              //       borderRadius: BorderRadius.circular(20.r),
                              //       boxShadow: [
                              //         BoxShadow(
                              //           color: Colors.grey.shade300,
                              //           blurRadius: 5,
                              //           offset: const Offset(0, 2),
                              //         ),
                              //       ],
                              //     ),
                              //     child: Row(
                              //       children: [
                              //         Text(
                              //           "Details",
                              //           style: TextStyle(
                              //             fontSize: 14.sp,
                              //             fontWeight: FontWeight.bold,
                              //             color: AppColors.black,
                              //           ),
                              //         ),
                              //         SizedBox(width: 5.w),
                              //         Icon(
                              //           CupertinoIcons.arrow_right,
                              //           color: AppColors.black,
                              //           size: 16.sp,
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // !Transactions Section
                  state is GetWalletLoadingState
                      ? Container()
                      : Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "transactions_title".tr(context),
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  // SizedBox(height: 10.h),
                                  Expanded(
                                    child: cubit.transactions.isNotEmpty
                                        ? ListView.separated(
                                            itemCount:
                                                cubit.transactions.length,
                                            separatorBuilder: (context, index) {
                                              return Column(
                                                children: [
                                                  SizedBox(height: 10.h),
                                                  const Divider(),
                                                  SizedBox(height: 16.h),
                                                ],
                                              );
                                            },
                                            padding: EdgeInsets.symmetric(
                                                vertical: 19.h),
                                            itemBuilder: (context, index) {
                                              return TransactionCard(
                                                title: cubit
                                                    .transactions[index].title,
                                                descreption: cubit
                                                    .transactions[index].body,
                                              );
                                            },
                                          )
                                        : Center(
                                            child: Text(
                                              AppStrings.thereIsNoTransactions
                                                  .tr(context),
                                              style: TextStyle(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
