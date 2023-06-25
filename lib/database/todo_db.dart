import 'package:hive/hive.dart';

part 'todo_db.g.dart';

abstract class TodoBoxAbstract {
  openTodoBox();

  addNewItem(TodoItem todo);

  getItem(int i);

  getAllItems();

  updateItem(int key, TodoItem todo);
}

/// todoItem database
/// here we used hive which describe every database as a box
class TodoBox implements TodoBoxAbstract {
  final HiveInterface hive;

  TodoBox({required this.hive});

  static const todoDB = 'todo_db';

  /// open the database before we do CRUD operation
  @override
  Future<Box> openTodoBox() async {
    return await hive.openBox(todoDB);
  }

  /// add single [todoItem] entry to the box
  @override
  Future<int> addNewItem(TodoItem todoItem) async {
    Box box = await openTodoBox();
    return box.add(todoItem);
  }

  /// get all entries in the box
  @override
  Future<List<TodoItem>> getAllItems() async {
    Box box = await openTodoBox();
    return box.values.map((items) => items as TodoItem).toList();
  }

  /// delete a single entry by it's [key] in the box
  @override
  Future<TodoItem> getItem(int key) async {
    Box box = await openTodoBox();
    return box.get(key);
  }

  /// update a single [todoItem] by it's [key] to the box
  @override
  Future<void> updateItem(int key, TodoItem todo) async {
    Box box = await openTodoBox();
    return box.put(key, todo);
  }

  /// delete a single [todoItem] by it's [key] in the box
  Future<void> deleteItem(int key) async {
    Box box = await openTodoBox();
    return await box.delete(key);
  }

  /// delete all entries in the box
  Future<int> clearBox() async {
    Box box = await openTodoBox();
    return await box.clear();
  }
}

@HiveType(typeId: 0)
class TodoItem extends HiveObject {
  @HiveField(0)
  String title;
  @HiveField(1)
  DateTime startDate;
  @HiveField(2)
  DateTime endDate;
  @HiveField(3)
  bool isComplete;
  @HiveField(4)
  int timeLeft;

  TodoItem(this.title, this.startDate, this.endDate, this.isComplete, this.timeLeft);
}
