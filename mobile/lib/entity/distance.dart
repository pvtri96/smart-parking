class Distance {
  String text;
  int value;

  Distance(
      this.text,
      this.value
      );

  toJson() {
    return {
      "text": this.text,
      "value": this.value
    };
  }

  factory Distance.fromMap(Map<dynamic, dynamic> data) {
    return Distance(
      data['text'],
      data['value']
    );
  }
}