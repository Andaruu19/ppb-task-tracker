import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Task> tasks = [];
  final TextEditingController _controller = TextEditingController();
  TaskPriority _selectedPriority = TaskPriority.medium;
  int? _editingIndex;
  bool _isEditing = false;

  void _addTask() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        if (_isEditing && _editingIndex != null) {
          // Update existing task
          tasks[_editingIndex!] = Task(
            title: _controller.text,
            priority: _selectedPriority,
            isCompleted: tasks[_editingIndex!].isCompleted,
          );
          _isEditing = false;
          _editingIndex = null;
        } else {
          // Add new task
          tasks.add(Task(
            title: _controller.text,
            priority: _selectedPriority,
          ));
        }
        _controller.clear();
        // Reset priority back to medium after adding/editing task
        _selectedPriority = TaskPriority.medium;
      });
    }
  }

  void _editTask(int index) {
    setState(() {
      _isEditing = true;
      _editingIndex = index;
      _controller.text = tasks[index].title;
      _selectedPriority = tasks[index].priority;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _editingIndex = null;
      _controller.clear();
      _selectedPriority = TaskPriority.medium;
    });
  }

  void _toggleComplete(int index, bool? value) {
    setState(() {
      tasks[index].isCompleted = value ?? false;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
      if (_isEditing && _editingIndex == index) {
        _cancelEditing();
      } else if (_isEditing && _editingIndex! > index) {
        // Adjust editing index if we deleted a task before the one we're editing
        _editingIndex = _editingIndex! - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Tracker')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: _isEditing ? 'Edit Task' : 'New Task',
                    border: OutlineInputBorder(),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_isEditing)
                          IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: _cancelEditing,
                          ),
                        IconButton(
                          icon: Icon(_isEditing ? Icons.check : Icons.add),
                          onPressed: _addTask,
                        ),
                      ],
                    ),
                  ),
                  onSubmitted: (_) => _addTask(),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Priority: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    _buildPriorityOption(TaskPriority.low, 'Low', Colors.green),
                    _buildPriorityOption(TaskPriority.medium, 'Medium', Colors.orange),
                    _buildPriorityOption(TaskPriority.high, 'High', Colors.red),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return TaskTile(
                  task: tasks[index],
                  onDelete: () => _deleteTask(index),
                  onEdit: () => _editTask(index),
                  onToggleComplete: (value) => _toggleComplete(index, value),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityOption(TaskPriority priority, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(label),
        selected: _selectedPriority == priority,
        selectedColor: color.withOpacity(0.7),
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _selectedPriority = priority;
            });
          }
        },
      ),
    );
  }
}

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TaskPriority _selectedPriority = TaskPriority.medium;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Task')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Enter task',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Priority', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPriorityOption(TaskPriority.low, 'Low', Colors.green),
                _buildPriorityOption(TaskPriority.medium, 'Medium', Colors.orange),
                _buildPriorityOption(TaskPriority.high, 'High', Colors.red),
              ],
            ),
            ElevatedButton(
              onPressed: _submitTask,
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityOption(TaskPriority priority, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: _selectedPriority == priority,
        selectedColor: color.withOpacity(0.7),
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _selectedPriority = priority;
            });
          }
        },
      ),
    );
  }

  void _submitTask() {
    final newTask = Task(
      title: 'New Task',
      priority: _selectedPriority,
    );
    // Save task and pop screen
  }
}