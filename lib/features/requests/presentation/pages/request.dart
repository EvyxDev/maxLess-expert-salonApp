import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maxless/core/component/custom-header.dart';
import 'package:maxless/core/constants/app_colors.dart';
import 'package:maxless/core/cubit/global_cubit.dart';
import 'package:maxless/core/locale/app_loacl.dart';
import 'package:maxless/features/requests/presentation/cubit/requests_cubit.dart';
import 'package:maxless/features/requests/presentation/widgets/requests_list_view.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen>
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
                  title: "requests_title".tr(context),
                  onBackPress: () {
                    Navigator.pop(context);
                  },
                ),
                //! Tab Bar
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
                                  "new".tr(context),
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
                                  "accepted".tr(context),
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
                              //! New Requests
                              RequestsListView(
                                items: cubit.pendingRequests,
                                completed: true,
                              ),
                              //! Accepted Requests
                              RequestsListView(
                                items: cubit.acceptedRequests,
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
}
