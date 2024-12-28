/// 备忘领域模型

class Memo {
  final int? id;
  final String title;
  final String content;
  final DateTime lastModified;

  Memo({
    this.id,
    required this.title,
    required this.content,
    required this.lastModified,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'lastModified': lastModified.toIso8601String(),
    };
  }
}
