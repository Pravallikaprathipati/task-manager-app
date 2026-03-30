import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'dart:math';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;

  AddEditTaskScreen({this.task});

  @override
  _AddEditTaskScreenState createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final title = TextEditingController();
  final desc = TextEditingController();
  DateTime? date;
  TaskStatus status = TaskStatus.todo;
  String? blockedBy;
  bool loading = false;

  @override
  void initState() {
    if (widget.task != null) {
      title.text = widget.task!.title;
      desc.text = widget.task!.description;
      date = widget.task!.dueDate;
      status = widget.task!.status;
      blockedBy = widget.task!.blockedBy;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Add/Edit Task")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: title,
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),

            TextField(
              controller: desc,
              decoration: InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (d != null) setState(() => date = d);
              },
              child: Text(date == null ? "Pick Date" : date.toString()),
            ),

            DropdownButton<TaskStatus>(
              value: status,
              items: TaskStatus.values
                  .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
                  .toList(),
              onChanged: (v) => setState(() => status = v!),
            ),

            DropdownButton<String?>(
              hint: Text("Blocked By"),
              value: blockedBy,
              items: [
                DropdownMenuItem(value: null, child: Text("None")),
                ...p.allTasks.map(
                  (e) => DropdownMenuItem(value: e.id, child: Text(e.title)),
                ),
              ],
              onChanged: (v) => setState(() => blockedBy = v),
            ),

            SizedBox(height: 20),

            loading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      setState(() => loading = true);

                      final task = Task(
                        id:
                            widget.task?.id ??
                            Random().nextInt(100000).toString(),
                        title: title.text,
                        description: desc.text,
                        dueDate: date ?? DateTime.now(),
                        status: status,
                        blockedBy: blockedBy,
                      );

                      if (widget.task == null) {
                        await p.addTask(task);
                      } else {
                        await p.updateTask(task);
                      }

                      setState(() => loading = false);
                      Navigator.pop(context);
                    },
                    child: Text("Save Task"),
                  ),
          ],
        ),
      ),
    );
  }
}
