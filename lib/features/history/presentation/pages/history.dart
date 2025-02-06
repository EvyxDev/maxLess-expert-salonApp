import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/component/custom-header.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/requests/presentation/cubit/requests_cubit.dart';

import '../widgets/history_list_view.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RequestsCubit()..init(),
      child: BlocBuilder<RequestsCubit, RequestsState>(
        builder: (context, state) {
          final cubit = context.read<RequestsCubit>();
          return Scaffold(
            backgroundColor: AppColors.white,
            body: Column(
              children: [
                SizedBox(height: 20.h),

                //! Header
                CustomHeader(
                  title: "history_title".tr(context),
                  onBackPress: () {
                    Navigator.pop(context);
                  },
                ),
                //! Body
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Column(
                      children: [
                        //! Tabs
                        Container(
                          alignment: Alignment.center,
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor, // خلفية التابات
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: TabBar(
                            controller: _tabController,
                            labelColor: AppColors.primaryColor,
                            unselectedLabelColor: Colors.white,
                            indicator: BoxDecoration(
                              color: Colors.white, // لون التاب المحدد
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            indicatorSize: TabBarIndicatorSize
                                .tab, // جعل المؤشر يأخذ عرض التاب
                            labelStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            dividerColor: Colors.transparent,
                            dividerHeight: 0,

                            padding: EdgeInsets.symmetric(
                                horizontal: 7.w, vertical: 7.h),
                            tabs: [
                              Tab(
                                child: Text(
                                  "completed".tr(context),
                                  style: TextStyle(
                                    fontFamily:
                                        context.read<GlobalCubit>().language ==
                                                "ar"
                                            ? 'Beiruti'
                                            : "Jost",
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    // color: Colors.black,
                                  ),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  "canceled".tr(context),
                                  style: TextStyle(
                                    fontFamily:
                                        context.read<GlobalCubit>().language ==
                                                "ar"
                                            ? 'Beiruti'
                                            : "Jost",
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    // color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        //! Tab content
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              HistoryListView(
                                items: cubit.completedRequests,
                                completed: true,
                              ),
                              HistoryListView(
                                items: cubit.cancelledRequests,
                                completed: false,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget _buildHistoryList({required bool completed}) {
  //   return ListView.builder(
  //     // padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
  //     itemCount: 5,
  //     itemBuilder: (context, index) {
  //       return HistoryCard(completed: completed);
  //     },
  //   );
  // }
}
