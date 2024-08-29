import 'package:eventbookingapp/poviders/bottom_navigation_provider.dart';
import 'package:eventbookingapp/widgets/bottom_naviagtion_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavigationProvider>(
      builder: (context, bottomNavProvider, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              bottomNavProvider.currentScreen,
              Positioned(
                bottom: -12,
                left: 0,
                right: 0,
                child: MyBottomNavigationBar(),
              ),
            ],
          ),
        );
      },
    );
  }
}
