import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import 'add_edit_task_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Task Manager"), centerTitle: true),

      // ➕ Add Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddEditTaskScreen()),
          );
        },
      ),

      body: Column(
        children: [
          // 🔍 Search
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search tasks...",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: provider.setSearch,
            ),
          ),

          // 🔽 Filter
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButtonFormField<TaskStatus?>(
              hint: Text("Filter tasks"),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: [
                DropdownMenuItem(value: null, child: Text("All")),
                ...TaskStatus.values.map(
                  (s) => DropdownMenuItem(value: s, child: Text(s.name)),
                ),
              ],
              onChanged: provider.setFilter,
            ),
          ),

          SizedBox(height: 8),

          // 📋 Task List
          Expanded(
            child: provider.tasks.isEmpty
                ? Center(
                    child: Text(
                      "No tasks yet 🚀",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: provider.tasks.length,
                    itemBuilder: (_, i) {
                      final t = provider.tasks[i];
                      final blocked = provider.isBlocked(t);

                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: blocked ? Colors.grey[300] : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              t.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 5),

                            // Description
                            Text(
                              t.description,
                              style: TextStyle(color: Colors.grey[700]),
                            ),

                            SizedBox(height: 10),

                            // Status + Actions
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildStatusChip(t.status),

                                Row(
                                  children: [
                                    // ✏️ Edit
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                AddEditTaskScreen(task: t),
                                          ),
                                        );
                                      },
                                    ),

                                    // 🗑 Delete
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () =>
                                          provider.deleteTask(t.id),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // 🎨 Status Chip
  Widget _buildStatusChip(TaskStatus status) {
    Color color;

    switch (status) {
      case TaskStatus.todo:
        color = Colors.orange;
        break;
      case TaskStatus.inProgress:
        color = Colors.blue;
        break;
      case TaskStatus.done:
        color = Colors.green;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.name,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
