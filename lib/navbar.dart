import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'new.dart';
import 'parking.dart';
import 'student_info.dart';  // Import ParkingForm

typedef NavBarCallback = void Function(int index);

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final NavBarCallback onTap;

  const CustomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.teal[100],  // Set background color to teal[100]
      onTap: (index) {
        switch (index) {
          case 0:
          // Navigate to Dashboard
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
            break;
          case 1:
          // Navigate to Add User screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewDataForm()),
            );
            break;
          case 2:
          // Navigate to Add Parking screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ParkingForm()),
            );
            break;
          case 3:
          // Navigate to View User screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const StudentInfo()),
            );
            break;
          case 4:
          // Navigate to View Parking screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
            break;
          default:
            onTap(index);
        }
      },
      items:  [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',  // Label under the icon
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Add User',  // Label under the icon
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.park),
          label: 'Add Parking',  // Label under the icon
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book),
          label: 'View User',  // Label under the icon
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.view_list),
          label: 'View Parking',  // Label under the icon
        ),
      ],
    );
  }
}
