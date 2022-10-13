import 'dart:convert';

class Availability {
  Availability({
    this.id,
    this.day,
    this.month,
    this.year,
    this.times,
  });

  final int? id;
  final int? day;
  final String? month;
  final int? year;
  final List<Map<String, dynamic>>? times;

  Availability copyWith({
    int? id,
    int? day,
    String? month,
    int? year,
    List<Map<String, dynamic>>? times,
  }) =>
      Availability(
        id: id ?? this.id,
        day: day ?? this.day,
        month: month ?? this.month,
        year: year ?? this.year,
        times: times ?? this.times,
      );

  factory Availability.fromJson(String str) =>
      Availability.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Availability.fromMap(Map<String, dynamic> json) => Availability(
        id: json["id"] == null ? null : json["id"],
        day: json["day"] == null ? null : json["day"],
        month: json["month"] == null ? null : json["month"],
        year: json["year"] == null ? null : json["year"],
        times: json["times"] == null
            ? null
            : List<Map<String, dynamic>>.from(
                json["times"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "day": day == null ? null : day,
        "month": month == null ? null : month,
        "year": year == null ? null : year,
        "times": times == null
            ? null
            : List<Map<String, dynamic>>.from(times!.map((x) => x)),
      };

  static List<Availability> fromList(List list) {
    List<Availability> result =
        list.map((availability) => Availability.fromMap(availability)).toList();
    return result;
  }
}
