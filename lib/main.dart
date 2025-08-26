import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
 // For encoding/decoding list to JSON


void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}
  
        
  class _MainAppState extends State<MainApp> {
  List<String> tasklist = [];
  TextEditingController textcontol = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTasks(); // Load tasks when app starts
  }

  // Save tasks to local storage
  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('tasks', tasklist);
  }

  // Load tasks from local storage
  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      tasklist = prefs.getStringList('tasks') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("ToDo List",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          backgroundColor: Colors.blue,
        ),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      controller: textcontol,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Enter the task"),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    onPressed: () {
                      setState(() {
                        if (textcontol.text.trim().isNotEmpty) {
                          tasklist.add(textcontol.text.trim());
                          saveTasks(); // Save after adding
                          textcontol.clear();
                        }
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.blue,
                    child: Text("Add"),
                  ),
                )
              ],
            ),
            Flexible(
              child: ListView.builder(
                itemCount: tasklist.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 19),
                          child: Text(
                            tasklist[index],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            tasklist.removeAt(index);
                            saveTasks(); // Save after delete
                          });
                        },
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      )
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}


