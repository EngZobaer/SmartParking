import 'package:flutter/material.dart';

class StudentInfo extends StatelessWidget {
   StudentInfo({super.key});

  // Sample student data
  final List<Map<String, String>> _students = [
    {'serial': '1', 'id': '101', 'name': 'Zobaer', 'mobile': '01712345678', 'department': 'Computer '},
    {'serial': '2', 'id': '102', 'name': 'Sojib', 'mobile': '01787654321', 'department': 'Electrical '},
    {'serial': '3', 'id': '103', 'name': 'MolLika', 'mobile': '01812345678', 'department': 'Mechanical '},
    {'serial': '4', 'id': '104', 'name': 'Mitu', 'mobile': '01698765432', 'department': 'Civil '},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Information',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Table Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.teal.shade700,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Expanded(
                    child: Text(
                      'SL',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'ID',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Name',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Mobile',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Dept.',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Student Data List
            ..._students.map(
                  (student) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Material(
                  color: Colors.teal.shade100,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      // You can add actions when a student row is tapped
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              student['serial']!,
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              student['id']!,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              student['name']!,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              student['mobile']!,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              student['department']!,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ).toList(),
          ],
        ),
      ),
    );
  }
}
