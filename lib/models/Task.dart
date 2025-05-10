class Task {
  String id;           // Firestore document ID (optional)
  String title;
  String description;
  bool isDone;
  DateTime createdAt;

  Task({
    this.id = '',
    required this.title,
    required this.description,
    this.isDone = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

}