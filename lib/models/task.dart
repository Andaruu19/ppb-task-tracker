enum TaskPriority {
  low,
  medium,
  high
}

class Task {
  String title;
  bool isCompleted;
  final TaskPriority priority;

  Task({
    required this.title,
    this.isCompleted = false,
    this.priority = TaskPriority.medium,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'priority': priority.index,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      isCompleted: json['isCompleted'] ?? false,
      priority: TaskPriority.values[json['priority'] ?? 1],
    );
  }

  Task copyWith({
    String? title,
    bool? isCompleted,
    TaskPriority? priority,
  }) {
    return Task(
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
    );
  }
}