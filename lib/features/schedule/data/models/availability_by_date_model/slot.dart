class Slot {
  String? start;
  String? end;

  Slot({this.start, this.end});

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
        start: json['start'] as String?,
        end: json['end'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'start': start,
        'end': end,
      };
}
