import 'slot.dart';

class AvailabilityByDateModel {
  String? date;
  bool? isAvailable;
  String? type;
  List<Slot>? slots;

  AvailabilityByDateModel({
    this.date,
    this.isAvailable,
    this.type,
    this.slots,
  });

  factory AvailabilityByDateModel.fromJson(Map<String, dynamic> json) {
    List<Slot>? slots;
    if ((json['slots'] as List<dynamic>?) == null ||
        (json['slots'] as List<dynamic>?)!.isEmpty) {
      slots = [
        Slot.fromJson({'start': '09:00', 'end': '21:00'})
      ];
    } else {
      slots = (json['slots'] as List<dynamic>?)!
          .map((e) => Slot.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return AvailabilityByDateModel(
      date: json['date'] as String?,
      isAvailable: json['is_available'] as bool?,
      type: json['type'] as String?,
      slots: slots,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'is_available': isAvailable,
        'type': type,
        'slots': slots?.map((e) => e.toJson()).toList(),
      };
}
