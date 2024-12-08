import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  BottomNavigation({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onTap,
      backgroundColor: Color(0xFF152325),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      type: BottomNavigationBarType.fixed, // Keeps all items visible
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favourites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Account',
        ),
      ],
    );
  }
}
