import 'city.dart';

class Governorate {
  int? id;
  int? countryId;
  String? name;
  List<City>? cities;

  Governorate({this.id, this.countryId, this.name, this.cities});

  factory Governorate.fromJson(Map<String, dynamic> json) => Governorate(
        id: json['id'] as int?,
        countryId: json['country_id'] as int?,
        name: json['name'] as String?,
        cities: (json['cities'] as List<dynamic>?)
            ?.map((e) => City.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'country_id': countryId,
        'name': name,
        'cities': cities?.map((e) => e.toJson()).toList(),
      };
}
