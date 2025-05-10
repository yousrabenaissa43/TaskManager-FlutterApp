import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/models/user.dart' as MyUser; // Alias to avoid name conflict
import 'package:taskmanager/screens/authenticate/authenticate.dart';
import 'package:taskmanager/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // Correct the provider to listen for MyUser.User?
    final user = Provider.of<MyUser.User?>(context);

    // Return either the Home or Authenticate widget based on user state
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
