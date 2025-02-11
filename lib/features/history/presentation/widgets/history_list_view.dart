import 'package:flutter/material.dart';
import 'package:maxless/features/history/presentation/widgets/history_card.dart';
import 'package:maxless/features/home/data/models/booking_item_model.dart';

class HistoryListView extends StatelessWidget {
  const HistoryListView(
      {super.key, required this.completed, required this.items});
  final bool completed;
  final List<BookingItemModel> items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return HistoryCard(
          completed: completed,
          model: items[index],
        );
      },
    );
  }
}
