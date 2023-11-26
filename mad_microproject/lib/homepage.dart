import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edithomepage.dart';

void main() => runApp(StudentInfoApp());

class StudentInfoApp extends StatelessWidget {
  StudentInfoApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.green),
      home: StudentInfoScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StudentInfoScreen extends StatefulWidget {
  const StudentInfoScreen({super.key});

  @override
  _StudentInfoScreenState createState() => _StudentInfoScreenState();
}

class _StudentInfoScreenState extends State<StudentInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _enrollmentController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _studentEntries = [];

  @override
  void initState() {
    super.initState();
    _loadStudentEntries();
  }

  _loadStudentEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? entries = prefs.getStringList('studentEntries');

    if (entries != null) {
      setState(() {
        _studentEntries = entries.map((entry) {
          List<String> entryParts = entry.split(';');
          return {
            'name': entryParts[0],
            'enrollment': entryParts[1],
            'class': entryParts[2],
          };
        }).toList();
      });
    }
  }

  _saveStudentEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> entries = _studentEntries.map((entry) {
      return '${entry['name']};${entry['enrollment']};${entry['class']}';
    }).toList();
    await prefs.setStringList('studentEntries', entries);
  }

  _addStudentEntry() {
    String name = _nameController.text;
    String enrollment = _enrollmentController.text;
    String studentClass = _classController.text;

    if (name.isNotEmpty && enrollment.isNotEmpty && studentClass.isNotEmpty) {
      setState(() {
        _studentEntries.add({
          'name': name,
          'enrollment': enrollment,
          'class': studentClass,
        });
        _nameController.text = '';
        _enrollmentController.text = '';
        _classController.text = '';
        _saveStudentEntries();
      });
    }
  }

  _deleteStudentEntry(int index) {
    setState(() {
      _studentEntries.removeAt(index);
      _saveStudentEntries();
    });
  }

  _editStudentEntry(int index) {
    final entry = _studentEntries[index];
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditStudentScreen(
          initialData: entry,
          onSave: (editedData) {
            setState(() {
              _studentEntries[index] = editedData;
              _saveStudentEntries();
            });
          },
        ),
      ),
    );
  }

  _searchStudent(String enrollment) {
    if (enrollment.isNotEmpty) {
      final result = _studentEntries.firstWhere(
            (entry) => entry['enrollment'] == enrollment,
        orElse: () => Map<String, String>.from({}),
      );
      if (result.isNotEmpty) {
        _searchController.text = ''; // Clear the search field
        final index = _studentEntries.indexOf(result);
        _editStudentEntry(index);
      } else {
        // Handle the case where no student with the specified enrollment is found.
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Student Not Found"),
              content: Text("No student with the specified enrollment number found."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
    }
  }

  Widget _buildStudentList() {
    return ListView.builder(
      itemCount: _studentEntries.length,
      itemBuilder: (context, index) {
        final entry = _studentEntries[index];
        return ListTile(
          title: Text('Name: ${entry['name']}', style: TextStyle(fontSize: 20)),
          subtitle: Text('Enrollment: ${entry['enrollment']}, Class: ${entry['class']}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _editStudentEntry(index);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _deleteStudentEntry(index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          // Only app title without search
          title: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [SizedBox(height: 30,),Text("Student Info", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),)],)),
          backgroundColor: Colors.grey[300],

        ),
      ),
      backgroundColor: Colors.grey[300],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(labelText: 'Search by Enrollment',
                    prefixIcon: const Icon(
                      Icons.search,
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  onSubmitted: (enrollment) {
                    _searchStudent(enrollment);
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, left: 17),
            child: Text(
              "List of Students",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(color: Colors.black, height: 10,),
          ),
          SizedBox(height: 20),
          Expanded(
            child: _buildStudentList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Container(
                 // width: 300, // Set your desired width
                  height: 400,
                  // Set your desired height
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Add Student Information", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                      SizedBox(height: 25,),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: 'Student Name',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      TextField(
                        controller: _enrollmentController,
                        decoration: InputDecoration(labelText: 'Enrollment Number',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      TextField(
                        controller: _classController,
                        decoration: InputDecoration(labelText: 'Class',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      _addStudentEntry();
                      Navigator.of(context).pop();
                    },
                    child: const Text("Add"),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
