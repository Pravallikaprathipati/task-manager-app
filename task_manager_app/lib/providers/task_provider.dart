import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  String _search = '';
  TaskStatus? _filter;

  List<Task> get tasks {
    return _tasks.where((t) {
      final matchSearch = t.title.toLowerCase().contains(_search.toLowerCase());
      final matchFilter = _filter == null ? true : t.status == _filter;
      return matchSearch && matchFilter;
    }).toList();
  }

  List<Task> get allTasks => _tasks;

  void setSearch(String val) {
    _search = val;
    notifyListeners();
  }

  void setFilter(TaskStatus? val) {
    _filter = val;
    notifyListeners();
  }

  Future<void> addTask(Task t) async {
    await Future.delayed(Duration(seconds: 2));
    _tasks.add(t);
    notifyListeners();
  }

  Future<void> updateTask(Task t) async {
    await Future.delayed(Duration(seconds: 2));
    int i = _tasks.indexWhere((e) => e.id == t.id);
    _tasks[i] = t;
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  bool isBlocked(Task t) {
    if (t.blockedBy == null) return false;
    final b = _tasks.firstWhere((e) => e.id == t.blockedBy, orElse: () => t);
    return b.status != TaskStatus.done;
  }
}
