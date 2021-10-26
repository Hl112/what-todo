import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskCardWidget extends StatelessWidget {
  final String? title;
  final String? desc;
  const TaskCardWidget({Key? key, this.title, this.desc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: [
          Text(
            title ?? '{Unnamed Task}',
            style: const TextStyle(
                color: Color(0xFF211551),
                fontSize: 22.0,
                fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              desc ?? '{No Description Added}',
              style: const TextStyle(
                  fontSize: 16.0, color: Color(0xFF868290), height: 1.5),
            ),
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class TodoWidget extends StatelessWidget {
  final String? text;
  bool isDone = false;

  TodoWidget({Key? key, this.text, required this.isDone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 20.0,
            height: 20.0,
            margin: const EdgeInsets.only(right: 12.0),
            decoration: BoxDecoration(
                color: isDone ? const Color(0xFF7349FE) : Colors.transparent,
                borderRadius: BorderRadius.circular(6.0),
                border: isDone
                    ? null
                    : Border.all(color: const Color(0xFF86829D), width: 1.5)),
            child: const Image(
              image: AssetImage('assets/images/check_icon.png'),
            ),
          ),
          Text(
            text ?? '(Unnamed Todo)',
            style: TextStyle(
                color:
                    isDone ? const Color(0xFF211551) : const Color(0xFF86829D),
                fontSize: 16.0,
                fontWeight: isDone ? FontWeight.bold : FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
