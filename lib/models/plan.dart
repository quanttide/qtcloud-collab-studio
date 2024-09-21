/// 计划领域模型
import "package:uuid/uuid.dart";


class Plan {
  final String id; // 计划的唯一标识
  final String title; // 计划标题
  final String description; // 计划描述

  // 修改构造函数以自动生成 uuid
  Plan({String? id, required this.title, required this.description})
      : id = id ?? const Uuid().v4(); // 如果未提供 uuid，则生成一个新的 uuid


  // 从 Map 创建 Plan 对象
  factory Plan.fromMap(Map<String, dynamic> map) {
    return Plan(
      id: map['id'],
      title: map['title'],
      description: map['description'],
    );
  }

  // 将 Plan 对象转换为 Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
}

