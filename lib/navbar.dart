import 'package:flutter/material.dart';

import 'dashboard.dart';
import 'parking.dart';  // Import ParkingForm

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
      onTap: (index) {
        if (index == 0) {
          // Navigate to Dashboard when Home is tapped
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardPage()),
          );
        } else if (index == 2) {
          // Navigate to Add Parking (ParkingForm) when View is tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ParkingForm()), // Navigate to Add Parking form
          );
        } else {
          // Otherwise, handle the other button taps
          onTap(index);
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'User',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Parking',
        ),
      ],
    );
  }
}
