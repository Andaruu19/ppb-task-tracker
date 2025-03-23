import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final Function(bool?) onToggleComplete;

  const TaskTile({
    required this.task,
    required this.onDelete,
    required this.onEdit,
    required this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted 
            ? TextDecoration.lineThrough 
            : TextDecoration.none,
        ),
      ),
      leading: _getPriorityIndicator(task.priority),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: onEdit,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
      tileColor: _getPriorityColor(task.priority),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high: return Colors.red[100]!;
      case TaskPriority.medium: return Colors.yellow[100]!;
      case TaskPriority.low: return Colors.green[100]!;
    }
  }

  Widget _getPriorityIndicator(TaskPriority priority) {
    final Color color;
    switch (priority) {
      case TaskPriority.low:
        color = Colors.green;
        break;
      case TaskPriority.medium:
        color = Colors.orange;
        break;
      case TaskPriority.high:
        color = Colors.red;
        break;
    }
    
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}