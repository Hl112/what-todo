// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:what_todo/database_helper.dart';
import 'package:what_todo/models/task.dart';
import 'package:what_todo/models/todo.dart';
import 'package:what_todo/widget.dart';

// ignore: must_be_immutable
class TaskPage extends StatefulWidget {
  final Task? task;

  const TaskPage({Key? key, this.task}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  int _taskId = 0;
  String _taskTitle = '';
  String _taskDescription = '';

  FocusNode? _titleFocus;
  FocusNode? _descriptionFocus;
  FocusNode? _todoFocus;

  bool _contentVisible = false;

  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    print('ID : ${widget.task?.id}');

    if (widget.task != null) {
      _taskId = widget.task!.id!;
      _taskTitle = widget.task!.title!;
      if (widget.task!.description != null) {
        _taskDescription = widget.task!.description!;
      } else {
        _taskDescription = '';
      }
      _contentVisible = true;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _titleFocus?.dispose();
    _descriptionFocus?.dispose();
    _todoFocus?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // ignore: avoid_unnecessary_containers
        child: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0, bottom: 6.0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Image(
                                image: AssetImage(
                                    'assets/images/back_arrow_icon.png')),
                          ),
                        ),
                        Expanded(
                            // Task TextField
                            child: TextField(
                          focusNode: _titleFocus,
                          onSubmitted: (value) async {
                            print('Field $value');

                            // Check if the field is not empty
                            if (value != '') {
                              // Chekc if task is null
                              // Create new Task
                              if (widget.task == null) {
                                // New Task from input
                                Task _newTask = Task(title: value);
                                // Insert Task to database
                                _taskId = await _dbHelper.insertTask(_newTask);
                                setState(() {
                                  _contentVisible = true;
                                  _taskTitle = value;
                                });
                                print('Creating new task ID: $_taskId');
                              } else {
                                // Update the existing Tasks
                                print('New Task has been created');
                                _dbHelper.updateTaskTitle(_taskId, value);
                                print('Task Title Updated');
                              }
                              _descriptionFocus?.requestFocus();
                            }
                          },
                          controller: TextEditingController()
                            ..text = _taskTitle,
                          decoration: const InputDecoration(
                              hintText: 'Enter Task title...',
                              border: InputBorder.none),
                          style: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF211551)),
                        ))
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: TextField(
                        focusNode: _descriptionFocus,
                        onSubmitted: (value) {
                          if (value != '') {
                            if (_taskId != 0) {
                              _dbHelper.updateTaskDescription(_taskId, value);
                              _taskDescription = value;
                            }
                          }

                          _todoFocus?.requestFocus();
                        },
                        controller: TextEditingController()
                          ..text = _taskDescription,
                        decoration: const InputDecoration(
                            hintText: 'Enter Description for task...',
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 24.0)),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Expanded(
                        child: FutureBuilder(
                            future: _dbHelper.getTodo(_taskId),
                            builder:
                                (context, AsyncSnapshot<List<Todo>> snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                    itemCount: snapshot.data?.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () async {
                                          print(
                                              'Todo Done: ${snapshot.data![index].isDone}');

                                          if (snapshot.data![index].isDone ==
                                              0) {
                                            await _dbHelper.updateTodoDone(
                                                snapshot.data![index].id, 1);
                                          } else {
                                            await _dbHelper.updateTodoDone(
                                                snapshot.data![index].id, 0);
                                          }
                                          setState(() {});
                                        },
                                        child: TodoWidget(
                                            text: snapshot.data![index].title,
                                            isDone:
                                                snapshot.data![index].isDone ==
                                                        1
                                                    ? true
                                                    : false),
                                      );
                                    });
                              }
                              return const CircularProgressIndicator();
                            })),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            children: [
                              Container(
                                width: 20.0,
                                height: 20.0,
                                margin: const EdgeInsets.only(right: 12.0),
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(6.0),
                                    border: Border.all(
                                        color: const Color(0xFF86829D),
                                        width: 1.5)),
                                child: const Image(
                                  image: AssetImage(
                                      'assets/images/check_icon.png'),
                                ),
                              ),
                              Expanded(
                                  // Todo
                                  child: TextField(
                                focusNode: _todoFocus,
                                onSubmitted: (value) async {
                                  print('Field $value');

                                  // Check if the field is not empty
                                  if (value != '') {
                                    // Chekc if task is null
                                    // Create new Todo
                                    if (_taskId != 0) {
                                      // Get database
                                      DatabaseHelper _dbHelper =
                                          DatabaseHelper();
                                      // New Task from input
                                      Todo _newTodo = Todo(
                                          title: value,
                                          isDone: 0,
                                          taskId: _taskId);
                                      // Insert Task to database
                                      await _dbHelper.insertTodo(_newTodo);
                                      setState(() {});
                                      print('New Todo has been created');
                                      _todoFocus?.requestFocus();
                                    } else {
                                      // Update the existing Tasks
                                      print('New Task is not exist');
                                    }
                                  }
                                },
                                controller: TextEditingController()..text = '',
                                decoration: const InputDecoration(
                                    hintText: 'Enter Todo item...',
                                    border: InputBorder.none),
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: _contentVisible,
                child: Positioned(
                  bottom: 24.0,
                  right: 24.0,
                  child: GestureDetector(
                    onTap: () async {
                      if (_taskId != 0) {
                        await _dbHelper.deleteTask(_taskId);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      child: const Image(
                        image: AssetImage('assets/images/delete_icon.png'),
                      ),
                      decoration: BoxDecoration(
                          color: const Color(0xFFFE3577),
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
