import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';  // Import Firestore
import 'navbar.dart'; // Import the CustomNavBar

class NewDataForm extends StatefulWidget {
  const NewDataForm({super.key});

  @override
  State<NewDataForm> createState() => _NewDataFormState();
}

class _NewDataFormState extends State<NewDataForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _presentAddressController = TextEditingController();

  String? _selectedDepartment;
  String? _selectedBloodGroup;

  final List<String> _departments = [
    'Computer Science',
    'Electrical Engineering',
    'Mechanical Engineering',
    'Civil Engineering',
    'Business Administration',
  ];

  final List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  int _currentIndex = 1; // Default to "User" screen

  // Firebase instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to add data to Firestore
  Future<void> _onAddPressed() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDepartment == null || _selectedBloodGroup == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select department and blood group')),
        );
        return;
      }

      // Collect form data
      String name = _nameController.text;
      String studentId = _studentIdController.text;
      String mobile = _mobileNumberController.text;
      String address = _presentAddressController.text;
      String department = _selectedDepartment!;
      String bloodGroup = _selectedBloodGroup!;

      try {
        // Check if the studentId already exists in Firestore
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('students_info')
            .where('studentId', isEqualTo: studentId)
            .get();

        if (snapshot.docs.isNotEmpty) {
          // If the studentId already exists, show an error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Student ID already exists!')),
          );
          return; // Stop further submission
        }

        // Add the serial field along with other data
        await FirebaseFirestore.instance.collection('students_info').add({
          'studentId': studentId,
          'name': name,
          'mobile': mobile,  // Make sure this field is included
          'department': department,
          'bloodGroup': bloodGroup,  // Adding blood group too
          'address': address,
        });

        // Reset the form after successful submission
        _formKey.currentState!.reset();
        setState(() {
          _selectedDepartment = null;
          _selectedBloodGroup = null;
        });

        // Show the custom dialog for success
        _showSuccessDialog();
      } catch (e) {
        // Show error message if data submission fails
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add data')),
        );
      }
    }
  }

  // Function to show a success dialog in the center of the screen
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Make dialog not dismissable by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.teal, // Teal background
          title: const Text(
            'Success',
            style: TextStyle(
              color: Colors.white, // White text for title
            ),
          ),
          content: const Text(
            'Data added successfully!',
            style: TextStyle(
              color: Colors.white, // White text for message
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // Handle bottom nav bar tap
  void _onNavBarTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Screens for bottom navigation
    Widget _getCurrentScreen() {
      switch (_currentIndex) {
        case 0:
          return const Center(child: Text('Home Screen')); // Replace with Home screen
        case 1:
          return _buildForm(); // "User" screen, i.e., NewDataForm
        case 2:
          return const Center(child: Text('View Screen')); // Replace with "View" screen
        default:
          return const Center(child: Text('Unknown Screen'));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Student',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _getCurrentScreen(), // Show current screen based on nav index
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTapped,
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'User Name',
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.words, // Automatically capitalize each word
            validator: (value) =>
            value == null || value.isEmpty ? 'Please enter user name' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _studentIdController,
            decoration: const InputDecoration(
              labelText: 'Student ID',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
            value == null || value.isEmpty ? 'Please enter student ID' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _mobileNumberController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Mobile Number',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
            value == null || value.isEmpty ? 'Please enter mobile number' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _presentAddressController,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Present Address',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
            value == null || value.isEmpty ? 'Please enter present address' : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedDepartment,
            decoration: const InputDecoration(
              labelText: 'Department',
              border: OutlineInputBorder(),
            ),
            items: _departments
                .map((dept) => DropdownMenuItem(value: dept, child: Text(dept)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedDepartment = value;
              });
            },
            validator: (value) =>
            value == null ? 'Please select a department' : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedBloodGroup,
            decoration: const InputDecoration(
              labelText: 'Blood Group',
              border: OutlineInputBorder(),
            ),
            items: _bloodGroups
                .map((bg) => DropdownMenuItem(value: bg, child: Text(bg)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedBloodGroup = value;
              });
            },
            validator: (value) =>
            value == null ? 'Please select blood group' : null,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _onAddPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Add',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
