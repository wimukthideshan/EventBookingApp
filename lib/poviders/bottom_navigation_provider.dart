import 'package:eventbookingapp/screens/favourites_screen.dart';
import 'package:eventbookingapp/screens/profile_screen.dart';
import 'package:eventbookingapp/screens/tickets_screen.dart';
import 'package:flutter/material.dart';

import '../screens/home_screen.dart';


class BottomNavigationProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  final List<Widget> _screens = [
    HomeScreen(),
    TicketsScreen(),
    FavouriteScreen(),
    ProfileScreen(),
  ];

  Widget get currentScreen => _screens[_currentIndex];

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}