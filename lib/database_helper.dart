import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/task.dart';
import 'models/todo.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      // Set path to the database
      // `path` package is best practice to ensure the path is correctly
      join(await getDatabasesPath(), 'todo_db.db'),

      // When the database is first created, create a table to store todo.
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.

        // Create table Tasks
        await db.execute(
            'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)');
        // Create table Todo
        await db.execute(
            'CREATE TABLE todo(id INTEGER PRIMARY KEY, taskId INTEGER, title TEXT, isDone INTEGER)');
      },

      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  Future<int> insertTask(Task task) async {
    int taskId = 0;
    Database _db = await database();

    await _db
        .insert(
            // Table name
            'tasks',

            // Data intert to db
            task.toMap(),

            // Action when conflict
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) => {taskId = value});

    return taskId;
  }

  Future<List<Task>> getTask() async {
    Database _db = await database();
    // Query the table for all The Task.
    List<Map<String, dynamic>> _taskMap = await _db.query('tasks');

    // Convert the List<Map<String, dynamic> into a List<Task>.
    return _taskMap.isNotEmpty
        ? List.generate(
            _taskMap.length,
            (index) => Task(
                id: _taskMap[index]['id'],
                title: _taskMap[index]['title'],
                description: _taskMap[index]['description']))
        : List.empty();
  }

  // Demo
  Future<void> updateTaskTitle(int id, String title) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET title = '$title' WHERE id = $id");
  }

  Future<void> updateTaskDescription(int id, String description) async {
    Database _db = await database();
    await _db.rawUpdate(
        "UPDATE tasks SET description = '$description' WHERE id = $id");
  }

  Future<void> insertTodo(Todo todo) async {
    Database _db = await database();

    await _db.insert(
        // Table name
        'todo',

        // Data intert to db
        todo.toMap(),

        // Action when conflict
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Todo>> getTodo(int taskId) async {
    Database _db = await database();
    // Query the table for all The Task.
    List<Map<String, dynamic>> _todoMap =
        await _db.rawQuery('SELECT * FROM todo WHERE taskId = $taskId');

    // Convert the List<Map<String, dynamic> into a List<Task>.
    return _todoMap.isNotEmpty
        ? List.generate(
            _todoMap.length,
            (index) => Todo(
                id: _todoMap[index]['id'],
                title: _todoMap[index]['title'],
                taskId: _todoMap[index]['taskId'],
                isDone: _todoMap[index]['isDone']))
        : List.empty();
  }

  Future<void> updateTodoDone(int? id, int? isDone) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE todo SET isDone = $isDone WHERE id = $id");
  }

  Future<void> deleteTask(int? id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM tasks WHERE id = $id");
    await _db.rawDelete("DELETE FROM todo WHERE taskId = $id");
  }
}
