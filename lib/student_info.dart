import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';  // Import Firestore
import 'navbar.dart'; // Import the CustomNavBar

class StudentInfo extends StatefulWidget {
  const StudentInfo({super.key});

  @override
  State<StudentInfo> createState() => _StudentInfoState();
}

class _StudentInfoState extends State<StudentInfo> {
  int _currentIndex = 0;  // To track selected tab in bottom nav bar

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
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('students_info').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong!'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No students found.'));
            }

            final students = snapshot.data!.docs.map((doc) {
              return {
                'id': doc['studentId'] ?? 'N/A',
                'name': doc['name'] ?? 'No Name',
                'mobile': doc['mobile'] ?? 'No Mobile',
                'department': doc['department'] ?? 'N/A',
              };
            }).toList();

            return ListView(
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
                      Expanded(child: Text('ID', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      Expanded(flex: 3, child: Text('Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      Expanded(flex: 2, child: Text('Mobile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      Expanded(flex: 2, child: Text('Dept.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Dynamic Student Data List
                ...students.map(
                      (student) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Material(
                      color: Colors.teal.shade100,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          // Handle tap on student row (navigate to detailed view, etc.)
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(flex: 2, child: Text(student['id'], style: const TextStyle(color: Colors.black))),
                              Expanded(flex: 3, child: Text(student['name'], style: const TextStyle(color: Colors.black))),
                              Expanded(flex: 2, child: Text(student['mobile'], style: const TextStyle(color: Colors.black))),
                              Expanded(flex: 2, child: Text(student['department'], style: const TextStyle(color: Colors.black))),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ).toList(),
              ],
            );
          },
        ),
      ),
      // Add the CustomNavBar at the bottom
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;  // Update the index when a tab is clicked
          });
        },
      ),
    );
  }
}
