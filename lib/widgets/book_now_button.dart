import 'package:flutter/material.dart';
import '../models/event_models.dart';
import '../constants.dart';
import '../screens/ticket_selection_screen.dart';

class BookNowButton extends StatelessWidget {
  final Event event;

  BookNowButton({required this.event});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        child: Text(
          AppConstants.bookNowText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TicketSelectionScreen(event: event),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}