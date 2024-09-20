/// 待办领域模型

import 'package:uuid/uuid.dart';

class Action {
  final String id; // 使用 String 类型的 uuid
  final String title;
  final String description;

    // 修改构造函数以自动生成 uuid
  Action({String? id, required this.title, required this.description})
      : id = id ?? const Uuid().v4(); // 如果未提供 uuid，则生成一个新的 uuid


  Map<String, dynamic> toMap() {
    return {
      'id': id, // 将 uuid 添加到 Map 中
      'title': title,
      'description': description,
    };
  }
}

