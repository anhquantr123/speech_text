class History {
  final String input;
  final String result;

  History(this.input, this.result);

  History.fromJson(Map<String, dynamic> json)
      : input = json['input'],
        result = json['result'];

  Map<String, dynamic> toJson() => {
        'input': input,
        'result': result,
      };
}
