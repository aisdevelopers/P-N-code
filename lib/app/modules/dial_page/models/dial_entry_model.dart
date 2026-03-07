class DialEntry {
  final String number;
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
