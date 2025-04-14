import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';
import '../objectbox.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late ObjectBox objectBox;
  List<Task> tasks = [];
  final TextEditingController _controller = TextEditingController();
  TaskPriority _selectedPriority = TaskPriority.medium;
  int? _editingTaskId;
  bool _isEditing = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initObjectBox();
  }

  Future<void> _initObjectBox() async {
    objectBox = await ObjectBox.create();
    _loadTasks();
  }

  void _loadTasks() {
    setState(() {
      tasks = objectBox.getAllTasks();
      _isLoading = false;
    });
  }

  void _addTask() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        if (_isEditing && _editingTaskId != null) {
          final taskToEdit = tasks.firstWhere((task) => task.id == _editingTaskId);
          Task updatedTask = Task(
            id: taskToEdit.id,
            title: _controller.text,
            isCompleted: taskToEdit.isCompleted,
            priority: _selectedPriority,
          );
          objectBox.updateTask(updatedTask);
          _isEditing = false;
          _editingTaskId = null;
        } else {
          Task newTask = Task(
            title: _controller.text,
            priority: _selectedPriority,
          );
          objectBox.addTask(newTask);
        }
        _controller.clear();
        _selectedPriority = TaskPriority.medium;
        _loadTasks();
      });
    }
  }

  void _editTask(int index) {
    final task = tasks[index];
    setState(() {
      _isEditing = true;
      _editingTaskId = task.id;
      _controller.text = tasks[index].title;
      _selectedPriority = tasks[index].priority;
    });
    _showEditTaskModal();
  }

  void _showEditTaskModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Edit Task',
                  border: OutlineInputBorder(),
                ),
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
              ElevatedButton(
                onPressed: () {
                  _addTask();
                  Navigator.pop(context);
                },
                child: Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _editingTaskId = null;
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
    final task = tasks[index];
    objectBox.deleteTask(task.id);
    _loadTasks();
    
    if (_isEditing && _editingTaskId == task.id) {
      _cancelEditing();
    }
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