import 'package:taskmanager/models/Task.dart';
import 'package:taskmanager/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({ this.uid });

  // Reference to users collection
  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection('users');

  // Subcollection for tasks under a specific user
  CollectionReference get taskCollection =>
      userCollection.doc(uid).collection('tasks');

  // Update user data
  Future<void> updateUserData(String name, String email, int taskCount) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'email': email,
      'taskCount': taskCount,
    });
  }

  // Add a task under the user's subcollection
  Future<void> addTask(Task task) async {
    await taskCollection.add({
      'title': task.title,
      'description': task.description,
      'isDone': task.isDone,
      'createdAt': Timestamp.fromDate(task.createdAt), // Store as Firestore Timestamp
      'uid': uid,
    });
  }
  // Update task status
  Future<void> updateTaskStatus(Task task) async {
    await taskCollection.doc(task.id).update({
      'isDone': task.isDone,
    });
  }


  // Task list from snapshot
  List<Task> _taskListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Task(
        id: doc.id,
        title: doc['title'] ?? '',
        description: doc['description'] ?? '',
        isDone: doc['isDone'] ?? false,
        createdAt: (doc['createdAt'] as Timestamp).toDate(),
      );
    }).toList();
  }

  // User data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot['name'],
      email: snapshot['email'],
      taskCount: snapshot['taskCount'] ?? 0,
    );
  }

  // Get tasks stream from user's subcollection
  Stream<List<Task>> get tasks {
    return taskCollection.snapshots().map(_taskListFromSnapshot);
  }

  // Get user data stream
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
