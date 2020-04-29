class RuleData {
  final int id;
  final String title;
  final String content;

  RuleData({
    this.id,
    this.title,
    this.content,
  });

  factory RuleData.fromJson(Map<String, dynamic> parsedJson) {
    return RuleData(
      id: parsedJson['id'],
      title: parsedJson['title'],
      content: parsedJson['content'],
    );
  }
}
