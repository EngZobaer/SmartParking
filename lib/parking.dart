import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';  // Import Firestore
import 'navbar.dart'; // Import the CustomNavBar

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

  // Method to fetch student details based on student ID from Firestore
  void _fetchStudentDetails() async {
    final studentId = _studentIdController.text;

    if (studentId.isEmpty) {
      return; // If the student ID is empty, don't query Firestore
    }

    try {
      // Query Firestore to get the student details by studentId field
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('students_info')
          .where('studentId', isEqualTo: studentId) // Query for studentId field
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If the student exists, get the first document and populate the text fields
        var studentSnapshot = querySnapshot.docs.first;

        _nameController.text = studentSnapshot['name'] ?? 'No Name';
        _mobileNumberController.text = studentSnapshot['mobile'] ?? 'No Mobile';
      } else {
        // If no student found, clear the fields
        _nameController.clear();
        _mobileNumberController.clear();
      }
    } catch (e) {
      // If there's an error, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching student data: $e')),
      );
    }
  }void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      // Collect form data
      String studentId = _studentIdController.text;
      String name = _nameController.text;
      String mobile = _mobileNumberController.text;
      String vehicleType = _selectedVehicleType!;

      // Log data to the console for debugging
      print("Student ID: $studentId");
      print("Name: $name");
      print("Mobile: $mobile");
      print("Vehicle Type: $vehicleType");

      // Generate the unique token
      String token = await _generateUniqueToken();
      print("Generated Token: $token");

      try {
        // Add the parking details to Firestore under 'parking_info' collection
        await FirebaseFirestore.instance.collection('parking_info').add({
          'studentId': studentId,
          'name': name,
          'mobile': mobile,
          'vehicleType': vehicleType,
          'token': token,  // Add the generated unique token
          'timestamp': FieldValue.serverTimestamp(), // Automatically add timestamp
          'parked': 'parked', // Add the 'parked' field (set to 'parked' initially)
        });

        // Show the success dialog
        _showSuccessDialog(studentId, name, token);

        // Reset the form after successful submission
        _formKey.currentState!.reset();
        setState(() {
          _selectedVehicleType = null;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Parking details submitted successfully!')),
        );
      } catch (e) {
        // Print the error for debugging
        print('Error adding parking details: $e');

        // Show error message if data submission fails
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add parking details')),
        );
      }
    }
  }


  // Method to generate a unique token number starting from 4001
  Future<String> _generateUniqueToken() async {
    // Fetch the last token from the Firestore collection
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('parking_info')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    int token = 4001;  // Default starting token

    if (snapshot.docs.isNotEmpty) {
      var lastDoc = snapshot.docs.first;
      token = int.tryParse(lastDoc['token']) ?? 4001;  // Get the last token or default to 4001
      token++;  // Increment the token number
    }

    return token.toString();  // Return the token as a string
  }

  // Method to show a success dialog with parking details
  void _showSuccessDialog(String studentId, String name, String token) {
    final currentTime = DateTime.now();

    // Manually get the day of the week
    String dayOfWeek;
    switch (currentTime.weekday) {
      case 1:
        dayOfWeek = 'Monday';
        break;
      case 2:
        dayOfWeek = 'Tuesday';
        break;
      case 3:
        dayOfWeek = 'Wednesday';
        break;
      case 4:
        dayOfWeek = 'Thursday';
        break;
      case 5:
        dayOfWeek = 'Friday';
        break;
      case 6:
        dayOfWeek = 'Saturday';
        break;
      case 7:
        dayOfWeek = 'Sunday';
        break;
      default:
        dayOfWeek = 'Unknown';
    }

    // Format time to be in hours and minutes (e.g., 2:30 PM)
    String formattedTime = "$dayOfWeek, ${currentTime.hour}:${currentTime.minute.toString().padLeft(2, '0')} PM";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Parking Submitted'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("ID: $studentId"),
            Text("Name: $name"),
            Text("Unique Token: $token"),
            Text("Submission Time: $formattedTime"),  // Display the formatted date and time
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();  // Close the dialog
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
                items: ['Motorcycle', 'Car', 'Skuti', 'Bicycle']
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
