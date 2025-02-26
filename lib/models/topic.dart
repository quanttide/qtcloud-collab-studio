/// 协作主题领域模型

class Topic {
  String id;
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;

  Topic({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });
}
