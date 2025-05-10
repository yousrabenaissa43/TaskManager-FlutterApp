import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/models/Task.dart';
import 'package:taskmanager/services/database.dart';
import 'package:taskmanager/models/user.dart' as MyUser;

class TaskForm extends StatefulWidget {
  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser.User?>(context);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min, // Keeps modal height dynamic
        children: <Widget>[
          Text(
            'Add New Task',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            decoration: InputDecoration(labelText: 'Title'),
            validator: (val) => val == null || val.isEmpty ? 'Enter a task title' : null,
            onChanged: (val) => setState(() => _title = val),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Description'),
            maxLines: 3,
            validator: (val) => val == null || val.isEmpty ? 'Enter a task description' : null,
            onChanged: (val) => setState(() => _description = val),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            child: Text('Add Task'),
            onPressed: () async {
              if (_formKey.currentState!.validate() && user != null) {
                Task task = Task(title: _title, description: _description);
                await DatabaseService(uid: user.uid!).addTask(task);
                Navigator.pop(context); // Close the modal
              }
            },
          ),
        ],
      ),
    );
  }
}
