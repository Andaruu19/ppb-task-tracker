import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:task_tracker/models/task.dart';
import 'objectbox.g.dart';

class ObjectBox {
  late final Store _store;
  
  late final Box<Task> taskBox;

  ObjectBox._create(this._store) {
    taskBox = Box<Task>(_store);
  }

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: p.join(docsDir.path, "task-db"));
    return ObjectBox._create(store);
  }

  List<Task> getAllTasks() {
    return taskBox.getAll();
  }

  int addTask(Task task) {
    return taskBox.put(task);
  }

  List<int> addTasks(List<Task> tasks) {
    return taskBox.putMany(tasks);
  }

  bool deleteTask(int id) {
    return taskBox.remove(id);
  }

  int updateTask(Task task) {
    return taskBox.put(task);
  }
}