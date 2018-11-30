class Duration {
  String text;
  int value;

  Duration(
      this.text,
      this.value
      );

  toJson() {
    return {
      "text": this.text,
      "value": this.value
    };
  }

  factory Duration.fromMap(Map<dynamic, dynamic> data) {
    return Duration(
      data['text'],
      data['value']
    );
  }
}