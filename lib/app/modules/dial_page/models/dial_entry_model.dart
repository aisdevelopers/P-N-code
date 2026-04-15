import 'package:hive/hive.dart';

part 'dial_entry_model.g.dart';

@HiveType(typeId: 3)
class DialEntry {
  @HiveField(0)
  final String number;
  @HiveField(1)
  final DateTime dateTime;

  DialEntry({
    required this.number,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() => {
        "number": number,
        "dateTime": dateTime.toIso8601String(),
      };

  factory DialEntry.fromJson(Map<String, dynamic> json) {
    return DialEntry(
      number: json["number"],
      dateTime: DateTime.parse(json["dateTime"]),
    );
  }
}
