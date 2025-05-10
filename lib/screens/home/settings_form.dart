import 'package:taskmanager/models/user.dart';
import 'package:taskmanager/services/database.dart';
import 'package:taskmanager/shared/constants.dart';
import 'package:taskmanager/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();

  // form values
  String _currentName = '';
  String _currentEmail = '';
  int _currentTaskCount = 0;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data!;

          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  'Update your settings.',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 20.0),
                // Name Field
                TextFormField(
                  initialValue: userData.name ?? '',  // Default to empty string if null
                  decoration: textInputDecoration,
                  validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
                  onChanged: (val) => setState(() => _currentName = val),
                ),
                SizedBox(height: 10.0),
                // Email Field
                TextFormField(
                  initialValue: userData.email ?? '',  // Default to empty string if null
                  decoration: textInputDecoration,
                  validator: (val) => val!.isEmpty ? 'Please enter an email' : null,
                  onChanged: (val) => setState(() => _currentEmail = val),
                ),
                SizedBox(height: 10.0),
                // Task Count (Optional)
                TextFormField(
                  initialValue: userData.taskCount?.toString() ?? '0',  // Default to '0' if null
                  decoration: textInputDecoration,
                  keyboardType: TextInputType.number,
                  validator: (val) => val!.isEmpty ? 'Please enter task count' : null,
                  onChanged: (val) => setState(() => _currentTaskCount = int.parse(val)),
                ),
                SizedBox(height: 20.0),
                // Use ElevatedButton instead of RaisedButton
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[400], // Set background color
                  ),
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await DatabaseService(uid: user.uid).updateUserData(
                        _currentName.isEmpty ? userData.name ?? '' : _currentName,
                        _currentEmail.isEmpty ? userData.email ?? '' : _currentEmail,
                        _currentTaskCount,
                      );
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
