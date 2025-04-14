import 'package:objectbox/objectbox.dart';

enum TaskPriority {
  low,
  medium,
  high
}

@Entity()
class Task {
  @Id()
  int id = 0;

  String title;
  bool isCompleted;

  int priorityValue;

  @Transient()
  TaskPriority get priority => TaskPriority.values[priorityValue];

  Task({
    this.id = 0,
    required this.title,
    this.isCompleted = false,
    TaskPriority priority = TaskPriority.medium,
  }) : priorityValue = priority.index;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'priority': priorityValue,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? 0,
      title: json['title'],
      isCompleted: json['isCompleted'] ?? false,
      priority: TaskPriority.values[json['priority'] ?? 1],
    );
  }

  Task copyWith({
    int? id,
    String? title,
    bool? isCompleted,
    TaskPriority? priority,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
    );
  }
}