import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dashboard.dart'; // Import Dashboard
import 'new.dart'; // Import NewDataForm (Add Student page)
import 'parking.dart'; // Import ParkingForm (Add Parking page)
import 'student_info.dart'; // Import Student Info page

class CustomDrawer extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _onDrawerItemTapped(BuildContext context, int index) {
    Navigator.pop(context); // Close drawer
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
    } else if (index == 1) {
      // Directly navigate to Add Student (NewDataForm)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NewDataForm()), // Navigating directly to NewDataForm
      );
    } else if (index == 2) {
      // Navigate to Add Parking (ParkingForm)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ParkingForm()), // Navigate to ParkingForm
      );
    } else if (index == 3) {
      // Navigate to Student Report (StudentInfo)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>   StudentInfo()), // Navigating directly to StudentInfo
      );
    } else if (index == 4) {
      _logout(context); // Call logout when Logout button is tapped
    }
  }

  Future<void> _logout(BuildContext context) async {
    await _auth.signOut();  // Sign out the user
    // Navigate to login page and remove all previous routes
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(_auth.currentUser?.displayName ?? 'User'),
            accountEmail: Text(_auth.currentUser?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              // Show the image instead of the first letter of the display name
              child: Image.asset('images/login1.png'),  // Display login1.png image
            ),
            decoration: const BoxDecoration(
              color: Colors.teal,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () => _onDrawerItemTapped(context, 0),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add Student'),
            onTap: () => _onDrawerItemTapped(context, 1),
          ),
          ListTile(
            leading: const Icon(Icons.local_parking),
            title: const Text('Add Parking'),
            onTap: () => _onDrawerItemTapped(context, 2), // Navigate to Add Parking
          ),
          ListTile(
            leading: const Icon(Icons.assignment_ind),
            title: const Text('Student Report'),
            onTap: () => _onDrawerItemTapped(context, 3), // Navigate to Student Report (StudentInfo)
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => _onDrawerItemTapped(context, 4), // Logout functionality
          ),
        ],
      ),
    );
  }
}
