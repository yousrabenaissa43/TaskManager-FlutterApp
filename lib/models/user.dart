import 'Task.dart';

class User {
  final String? uid;
  User({ this.uid });
}

class UserData {
  final String? uid;
  final String? name;
  final String? email;
  final int? taskCount;
  final List<Task> tasks;

  UserData({
    this.uid,
    this.email,
    this.taskCount,
    this.name,
    this.tasks = const [],
  });


}
