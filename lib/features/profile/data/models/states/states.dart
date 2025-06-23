import 'datum.dart';

class States {
  List<Governorate>? governorates;
  bool? success;
  int? status;

  States({this.governorates, this.success, this.status});

  factory States.fromJson(Map<String, dynamic> json) => States(
        governorates: (json['data'] as List<dynamic>?)
            ?.map((e) => Governorate.fromJson(e as Map<String, dynamic>))
            .toList(),
        success: json['success'] as bool?,
        status: json['status'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'data': governorates?.map((e) => e.toJson()).toList(),
        'success': success,
        'status': status,
      };
}
