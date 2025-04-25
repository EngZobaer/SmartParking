import 'package:flutter/material.dart';

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
      onTap: onTap,
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
          icon: Icon(Icons.visibility),
          label: 'View',
        ),
      ],
    );
  }
}
