import 'package:flutter/material.dart';
import 'package:what_todo/database_helper.dart';
import 'package:what_todo/models/task.dart';
import 'package:what_todo/screens/taskpage.dart';
import 'package:what_todo/widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        color: const Color(0xFFF6F6F6),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
        ),
        margin: const EdgeInsets.only(
          bottom: 20.0,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 32.0, bottom: 32.0),
                  child:
                      const Image(image: AssetImage('assets/images/logo.png')),
                ),
                Expanded(
                    child: FutureBuilder(
                  future: _dbHelper.getTask(),
                  builder: (context, AsyncSnapshot<List<Task>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TaskPage(
                                                  task: snapshot.data![index],
                                                )))
                                    .then((value) => {setState(() {})});
                              },
                              child: TaskCardWidget(
                                title: snapshot.data![index].title,
                                desc: snapshot.data![index].description,
                              ),
                            );
                          });
                    }
                    return const CircularProgressIndicator();
                  },
                ))
              ],
            ),
            Positioned(
              bottom: 0.0,
              right: 0.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TaskPage()))
                      .then((value) => {setState(() {})});
                },
                child: Container(
                  height: 60,
                  width: 60,
                  child: const Image(
                    image: AssetImage('assets/images/add_icon.png'),
                  ),
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xFF7349FE), Color(0xFF643FDB)],
                          begin: Alignment(0.0, -1.0),
                          end: Alignment(0, 1)),
                      borderRadius: BorderRadius.circular(20.0)),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
