import 'package:taskmanager/models/Task.dart';
import 'package:taskmanager/screens/home/task_list.dart';
import 'package:taskmanager/screens/home/settings_form.dart';
import 'package:taskmanager/services/auth.dart';
import 'package:taskmanager/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:taskmanager/screens/home/task_form.dart';

import '../../models/user.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  void _showSettingsPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: SettingsForm(),
        );
      },
    );
  }

  void _showAddTaskPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // to make the form take full height if needed
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: TaskForm(), // This is a form you need to build to add a Task
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context); // Get current user

    if (user == null) {
      // If user is not logged in, you might want to show a login screen or redirect
      return Center(child: CircularProgressIndicator());
    }

    return StreamProvider<List<Task>>.value(
      value: DatabaseService(uid: user.uid).tasks, // Pass user's uid to DatabaseService
      initialData: [],
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text('Task Manager'),
          backgroundColor: Color(0xFFF0A7BC),
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.person, color: Colors.black),
              label: Text('Logout', style: TextStyle(color: Colors.black)),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
            TextButton.icon(
              icon: Icon(Icons.settings, color: Colors.black),
              label: Text('Settings', style: TextStyle(color: Colors.black)),
              onPressed: () => _showSettingsPanel(context),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/task_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: TaskList(), // Display tasks here
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddTaskPanel(context),
          backgroundColor: Color(0xFFCDC1FF),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
