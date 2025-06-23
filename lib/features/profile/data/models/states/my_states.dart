class MyStates {
  String? state;
  String? mainCity;
  List<dynamic>? subCities;

  MyStates({this.state, this.mainCity, this.subCities});

  factory MyStates.fromJson(Map<String, dynamic> json) => MyStates(
        state: json['state'] as String?,
        mainCity: json['main_city'] as String?,
        subCities: json['sub_cities'] as List<dynamic>?,
      );

  Map<String, dynamic> toJson() => {
        'state': state,
        'main_city': mainCity,
        'sub_cities': subCities,
      };
}
