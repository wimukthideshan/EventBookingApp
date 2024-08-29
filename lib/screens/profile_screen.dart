import 'package:eventbookingapp/poviders/auth_provider.dart';
import 'package:eventbookingapp/poviders/user_provider.dart';
import 'package:eventbookingapp/screens/sign_in_screen.dart';
import 'package:eventbookingapp/widgets/auth_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.isLoading) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryColor),
              ),
            ),
          );
        }

        final user = userProvider.currentUser;

        if (user == null) {
          return Scaffold(
            body: Center(child: Text('User not found.')),
          );
        }

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: user.profilePictureUrl != null
                        ? NetworkImage(user.profilePictureUrl!)
                        : null,
                    child: user.profilePictureUrl == null
                        ? Icon(Icons.person, size: 50, color: Colors.grey[800])
                        : null,
                  ),
                  SizedBox(height: 16),
                  Text(user.name, style: AppConstants.headlineStyle),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatItem('My tickets', user.ticketCount.toString()),
                    ],
                  ),
                  SizedBox(height: 24),
                  _buildProfileItem(
                      'Customize your event recommendations based on your interests.',
                      Icons.add,
                      'Add'),
                  _buildProfileItem(
                      'Primary city', Icons.location_on, user.primaryCity),
                  _buildProfileItem('Online events', Icons.computer, ''),
                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomButton(
                      text: 'Sign Out',
                      onPressed: () async {
                        final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                        try {
                          await authProvider.signOut();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => SignInScreen()),
                            (Route<dynamic> route) => false,
                          );
                        } catch (error) {
                          print('Sign out failed: $error');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Sign out failed. Please try again.')),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: AppConstants.headlineStyle),
        Text(label, style: AppConstants.bodyStyle),
      ],
    );
  }

  Widget _buildProfileItem(String title, IconData icon, String? trailing) {
    return ListTile(
      leading: Icon(icon, color: AppConstants.primaryColor),
      title: Text(title, style: AppConstants.bodyStyle),
      trailing: trailing != null && trailing.isNotEmpty
          ? trailing == 'Add'
              ? ElevatedButton(
                  onPressed: () {},
                  child: Text(trailing),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppConstants.primaryColor,
                    side: BorderSide(color: AppConstants.primaryColor),
                  ),
                )
              : Text(trailing, style: AppConstants.bodyStyle)
          : null,
      onTap: () {},
    );
  }
}