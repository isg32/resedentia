// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class EditStudentScreen extends StatefulWidget {
//   final int? studentIndex; // The index of the student to edit, null for adding new student
//   final Map<String, String>? studentData; // Initial student data if editing
//
//   const EditStudentScreen({this.studentIndex, this.studentData, Key? key})
//       : super(key: key);
//
//   @override
//   _EditStudentScreenState createState() => _EditStudentScreenState();
// }
//
// class _EditStudentScreenState extends State<EditStudentScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _enrollmentController = TextEditingController();
//   final TextEditingController _classController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.studentData != null) {
//       // Populate the fields with existing student data when editing
//       _nameController.text = widget.studentData!['name']!;
//       _enrollmentController.text = widget.studentData!['enrollment']!;
//       _classController.text = widget.studentData!['class']!;
//     }
//   }
//
//   _saveStudentEntry() async {
//     String name = _nameController.text;
//     String enrollment = _enrollmentController.text;
//     String studentClass = _classController.text;
//
//     if (name.isNotEmpty && enrollment.isNotEmpty && studentClass.isNotEmpty) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       List<String> newEntry = ['$name', '$enrollment', '$studentClass'];
//
//       if (widget.studentIndex != null) {
//         // Update existing student entry if provided an index
//         List<String>? entries = prefs.getStringList('studentEntries');
//         if (entries != null) {
//           entries[widget.studentIndex!] = newEntry.join(';');
//           prefs.setStringList('studentEntries', entries);
//         }
//       } else {
//         // Add a new student entry if no index provided
//         prefs.setStringList('studentEntries', [
//           ...prefs.getStringList('studentEntries') ?? [],
//           newEntry.join(';'),
//         ]);
//       }
//       Navigator.pop(context); // Go back to the previous screen
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.studentIndex != null
//             ? "Edit Student Information"
//             : "Add Student Information"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: <Widget>[
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(labelText: 'Student Name'),
//             ),
//             TextField(
//               controller: _enrollmentController,
//               decoration: InputDecoration(labelText: 'Enrollment Number'),
//             ),
//             TextField(
//               controller: _classController,
//               decoration: InputDecoration(labelText: 'Class'),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 _saveStudentEntry();
//               },
//               child: Text(widget.studentIndex != null ? "Save" : "Add"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class EditStudentScreen extends StatefulWidget {
  final Map<String, String> initialData;
  final Function(Map<String, String> editedData) onSave;

  EditStudentScreen({required this.initialData, required this.onSave});

  @override
  _EditStudentScreenState createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  late TextEditingController _nameController;
  late TextEditingController _enrollmentController;
  late TextEditingController _classController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialData['name']);
    _enrollmentController = TextEditingController(text: widget.initialData['enrollment']);
    _classController = TextEditingController(text: widget.initialData['class']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text("Edit Student Information", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.grey[300],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 30, right: 14, left: 14),
        child: Column(
          children: <Widget>[
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
            SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                primary: Colors.black
              ),
              onPressed: () {
                Map<String, String> editedData = {
                  'name': _nameController.text,
                  'enrollment': _enrollmentController.text,
                  'class': _classController.text,
                };
                widget.onSave(editedData);
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
