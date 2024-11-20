import 'package:uuid/uuid.dart';

class Vote {
  final String id;
  final String title;
  final String option_1;
  final String option_2;
  final String description;

  Vote({
    String? id,
    required this.title,
    required this.option_1,
    required this.option_2,
    required this.description,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'option_1': option_1,
      'option_2': option_2,
      'description': description,
    };
  }
}

