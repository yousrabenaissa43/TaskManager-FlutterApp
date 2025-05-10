import 'package:taskmanager/models/Task.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager/services/database.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  TaskTile({ required this.task });

  // Function to toggle the task completion status
  void _toggleTaskStatus(BuildContext context) async {
    final databaseService = DatabaseService();

    // Toggle the 'isDone' status
    task.isDone = !task.isDone;

    // Update the task status in the Firestore database
    await databaseService.updateTaskStatus(task);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: GestureDetector(
            onTap: () => _toggleTaskStatus(context),  // Toggle on tap
            child: Icon(
              task.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
              color: task.isDone ? Colors.green : Colors.grey,
              size: 30,
            ),
          ),
          title: Text(task.title),
          subtitle: Text(task.description),
          trailing: Text(
            '${task.createdAt.day}/${task.createdAt.month}/${task.createdAt.year}',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}
