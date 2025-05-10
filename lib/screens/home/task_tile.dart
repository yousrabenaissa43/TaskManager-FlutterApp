import 'package:provider/provider.dart';
import 'package:taskmanager/models/Task.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager/services/database.dart';

import '../../models/user.dart';

class TaskTile extends StatefulWidget {
  final Task task;

  TaskTile({required this.task});

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  late bool isDone;

  @override
  void initState() {
    super.initState();
    isDone = widget.task.isDone;
  }

  void _toggleTaskStatus() async {
    final user = Provider.of<User?>(context, listen: false);
    if (user == null || user.uid == null) return;

    setState(() {
      isDone = !isDone;
    });

    widget.task.isDone = isDone;

    final databaseService = DatabaseService(uid: user.uid!);
    await databaseService.updateTaskStatus(widget.task);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: GestureDetector(
            onTap: _toggleTaskStatus,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: isDone ? Colors.green : Colors.grey,
              child: isDone
                  ? Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
          ),
          title: Text(widget.task.title),
          subtitle: Text(widget.task.description),
          trailing: Text(
            '${widget.task.createdAt.day}/${widget.task.createdAt.month}/${widget.task.createdAt.year}',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}
