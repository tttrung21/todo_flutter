class TodoModel {
  int? id;
  String title;
  String? notes;
  String category;
  String dueDate;
  String? dueTime;
  bool isCompleted;
  String userId;
  TodoModel({
    this.id,
    required this.title,
    this.notes,
    required this.category,
    required this.dueDate,
    this.dueTime,
    this.isCompleted = false,
    required this.userId
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'notes': notes,
      'category': category,
      'due_date': dueDate,
      'due_time': dueTime,
      'is_completed': isCompleted,
      'user_id' : userId
    };
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      title: json['title'],
      notes: json['notes'],
      category: json['category'],
      dueDate: json['due_date'],
      dueTime: json['due_time'],
      isCompleted: json['is_completed'],
      userId: json['user_id']
    );
  }
  static List<TodoModel> fromJsonToList(List<dynamic> list) {
    return list.map((c) => TodoModel.fromJson(c)).toList();
  }
  TodoModel copyWith({
    int? id,
    String? title,
    String? notes,
    String? category,
    String? dueDate,
    String? dueTime,
    bool? isCompleted,
    String? userId,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      isCompleted: isCompleted ?? this.isCompleted,
      userId: userId ?? this.userId,
    );
  }
}

enum Category{
  CategoryTask,CategoryEvent,CategoryGoal
}