class DialPadItem {
  final String digit;
  final String letters;

  DialPadItem({required this.digit, required this.letters});

  factory DialPadItem.fromMap(Map<String, dynamic> map) {
    return DialPadItem(
      digit: map['digit'] ?? '',
      letters: map['letters'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'digit': digit, 'letters': letters};
  }
}
