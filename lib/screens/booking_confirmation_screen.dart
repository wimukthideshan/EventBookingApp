import 'package:eventbookingapp/poviders/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking_model.dart';
import '../models/event_models.dart';
import '../constants.dart';
import 'package:provider/provider.dart';

class BookingConfirmationPopup extends StatelessWidget {
  final Booking booking;
  final Event event;

  BookingConfirmationPopup({required this.booking, required this.event});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppConstants.defaultBorderRadius,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topRight,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name', style: AppConstants.subtitleStyle),
                Text(event.name, style: AppConstants.headlineStyle),
                SizedBox(height: 16),
                Text('Ticket / seat', style: AppConstants.subtitleStyle),
                Text('General Admission', style: AppConstants.bodyStyle),
                SizedBox(height: 16),
                Text('Event', style: AppConstants.subtitleStyle),
                Text(event.name, style: AppConstants.bodyStyle),
                SizedBox(height: 16),
                Text('Date', style: AppConstants.subtitleStyle),
                Text(DateFormat('EEE, MMM d • HH:mm').format(event.date), style: AppConstants.bodyStyle),
                // SizedBox(height: 8),
                // InkWell(
                //   child: Text(
                //     'Add to calendar',
                //     style: TextStyle(
                //       color: AppConstants.primaryColor,
                //       decoration: TextDecoration.underline,
                //     ),
                //   ),
                //   onTap: () {
                //   },
                // ),
                SizedBox(height: 16),
                Text('Order number', style: AppConstants.subtitleStyle),
                Text(booking.id, style: AppConstants.bodyStyle),
              ],
            ),
          ),
          Positioned(
            right: -10,
            top: -10,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: CircleAvatar(
                radius: 14,
                backgroundColor: Colors.white,
                child: Icon(Icons.close, color: Colors.black, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BookingConfirmationScreen extends StatelessWidget {
  final Booking booking;

  BookingConfirmationScreen({required this.booking});

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final event = eventProvider.events.firstWhere((e) => e.id == booking.eventId);


    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BookingConfirmationPopup(booking: booking, event: event);
        },
      ).then((_) {

        Navigator.of(context).pop();
      });
    });


    return Container();
  }
}