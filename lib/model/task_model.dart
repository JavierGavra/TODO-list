const String tableTask = 'task';
const String tableTaskComplete = 'task_complete';

class TaskFields {
  static final List<String> values = [id, title, level];
  static const String id = '_id';
  static const String title = 'title';
  static const String level = 'level';
}

class TaskModel {
  final int? id;
  final String title;
  final String level;

  TaskModel({
    this.id,
    required this.title,
    required this.level,
  });

  static TaskModel fromJson(Map<String, Object?> json) => TaskModel(
        id: json[TaskFields.id] as int?,
        title: json[TaskFields.title] as String,
        level: json[TaskFields.level] as String,
      );

  Map<String, Object?> toJson() => {
        TaskFields.id: id,
        TaskFields.title: title,
        TaskFields.level: level,
      };

  TaskModel copy({int? id, String? title, String? level}) => TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      level: level ?? this.level);
}
