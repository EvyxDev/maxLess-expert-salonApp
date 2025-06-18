import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maxless/features/schedule/presentation/cubit/schedule_cubit.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/schedule_body.dart';

class ScheduleView extends StatelessWidget {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScheduleCubit()..daysScrollListener(),
      child: const Scaffold(
        backgroundColor: AppColors.white,
        body: ScheduleBody(),
      ),
    );
  }
}
