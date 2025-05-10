import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/models/Task.dart';
import 'package:taskmanager/services/database.dart';
import 'package:taskmanager/models/user.dart' as MyUser;

class TaskForm extends StatefulWidget {
  final Task? task;

  TaskForm({this.task});

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;

  @override
  void initState() {
    super.initState();
    _title = widget.task?.title ?? '';
    _description = widget.task?.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser.User?>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFFFCCEA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
        title: Row(
          children: [
            Icon(Icons.edit, color: Colors.black),
            SizedBox(width: 8),
            Text(
              widget.task == null ? 'Add New Task' : 'Edit Task',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Center(
        child: Card(
          elevation: 4,
          margin: EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          color: Color(0xFFBFECFF),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: _title,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (val) => val == null || val.isEmpty ? 'Enter a task title' : null,
                    onChanged: (val) => setState(() => _title = val),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    initialValue: _description,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    maxLines: 3,
                    validator: (val) => val == null || val.isEmpty ? 'Enter a task description' : null,
                    onChanged: (val) => setState(() => _description = val),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton.icon(
                    icon: Icon(Icons.save, color: Colors.white),
                    label: Text(widget.task == null ? 'Add Task' : 'Update Task'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Color(0xFFCDC1FF),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate() && user != null) {
                        Task task = widget.task ?? Task(title: _title, description: _description);
                        task.title = _title;
                        task.description = _description;

                        final dbService = DatabaseService(uid: user.uid!);
                        widget.task == null
                            ? await dbService.addTask(task)
                            : await dbService.updateTask(task);

                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
