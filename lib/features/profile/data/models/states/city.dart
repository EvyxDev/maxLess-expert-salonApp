class City {
  int? id;
  String? name;

  City({this.id, this.name});

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json['id'] as int?,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
