import 'package:flutter/material.dart';
import 'navbar.dart';  // Import the CustomNavBar

class ParkingForm extends StatefulWidget {
  const ParkingForm({super.key});

  @override
  State<ParkingForm> createState() => _ParkingFormState();
}

class _ParkingFormState extends State<ParkingForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();

  String? _selectedVehicleType;

  // Sample student list
  final List<Map<String, String>> _students = [
    {'id': '101', 'name': 'Zobaer', 'mobile': '01712345678'},
    {'id': '102', 'name': 'Sojib', 'mobile': '01787654321'},
    {'id': '103', 'name': 'MolLika', 'mobile': '01812345678'},
    {'id': '104', 'name': 'Mitu', 'mobile': '01698765432'},
  ];

  final List<String> _vehicleTypes = [
    'Motorcycle',
    'Car',
    'Skuti',
    'Bicycle',
  ];

  // Method to fetch student details based on student ID
  void _fetchStudentDetails() {
    final studentId = _studentIdController.text;
    final student = _students.firstWhere(
          (student) => student['id'] == studentId,
      orElse: () => {'id': '', 'name': '', 'mobile': ''},
    );

    if (student['id'] != '') {
      _nameController.text = student['name']!;
      _mobileNumberController.text = student['mobile']!;
    } else {
      // If student ID doesn't match, clear the name and mobile number
      _nameController.clear();
      _mobileNumberController.clear();
    }
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      // Handle form submission (e.g., save data to the database)
      print('Student ID: ${_studentIdController.text}');
      print('Name: ${_nameController.text}');
      print('Mobile Number: ${_mobileNumberController.text}');
      print('Selected Vehicle: $_selectedVehicleType');

      // Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Parking details submitted successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Parking Form',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Student ID field
              TextFormField(
                controller: _studentIdController,
                decoration: const InputDecoration(
                  labelText: 'Student ID',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _fetchStudentDetails(); // Fetch details when ID changes
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter student ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Name field (Auto-filled based on student ID)
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                enabled: false, // Disable editing for Name
              ),
              const SizedBox(height: 16),

              // Mobile Number field (Auto-filled based on student ID)
              TextFormField(
                controller: _mobileNumberController,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(),
                ),
                enabled: false, // Disable editing for Mobile Number
              ),
              const SizedBox(height: 16),

              // Vehicle Type dropdown
              DropdownButtonFormField<String>(
                value: _selectedVehicleType,
                decoration: const InputDecoration(
                  labelText: 'Select Vehicle',
                  border: OutlineInputBorder(),
                ),
                items: _vehicleTypes
                    .map((vehicle) => DropdownMenuItem(value: vehicle, child: Text(vehicle)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedVehicleType = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a vehicle type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(  // Add the CustomNavBar here
        currentIndex: 0,
        onTap: (index) {
          // Handle the navigation logic if needed for the navbar items
        },
      ),
    );
  }
}
