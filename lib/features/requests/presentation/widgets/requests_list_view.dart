import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maxless/core/component/custom_loading_indicator.dart';
import 'package:maxless/features/home/data/models/booking_item_model.dart';
import 'package:maxless/features/requests/presentation/cubit/requests_cubit.dart';
import 'package:maxless/features/requests/presentation/widgets/requests_card.dart';

class RequestsListView extends StatelessWidget {
  const RequestsListView(
      {super.key, required this.items, required this.completed});

  final List<BookingItemModel> items;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestsCubit, RequestsState>(
      builder: (context, state) {
        return state is GetRequestsLoadingState
            ? const CustomLoadingIndicator()
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return RequestCard(
                    completed: completed,
                    model: items[index],
                  );
                },
              );
      },
    );
  }
}
