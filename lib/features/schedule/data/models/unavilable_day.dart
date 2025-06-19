class UnavilableDay {
  String? exceptionDate;
  String? dayName;

  UnavilableDay({this.exceptionDate, this.dayName});

  factory UnavilableDay.fromJson(Map<String, dynamic> json) => UnavilableDay(
        exceptionDate: json['exception_date'] as String?,
        dayName: json['day_name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'exception_date': exceptionDate,
        'day_name': dayName,
      };
}
