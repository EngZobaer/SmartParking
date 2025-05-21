import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'new.dart';
import 'parking.dart';
import 'student_info.dart';

typedef NavBarCallback = void Function(int index);

const Color customTealColor = Color(0xFF009688); // Custom teal color

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
      selectedItemColor: customTealColor,  // Use custom teal color for selected item
      unselectedItemColor: Colors.grey,   // Default color for unselected items
      backgroundColor: customTealColor,   // Background color for the navbar
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewDataForm()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ParkingForm()),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const StudentInfo()),
            );
            break;
          case 4:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
            break;
          default:
            onTap(index);
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Add User',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.park),
          label: 'Add Parking',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book),
          label: 'View User',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.view_list),
          label: 'View Parking',
        ),
      ],
    );
  }
}
