import 'package:eventbookingapp/models/booking_model.dart';
import 'package:eventbookingapp/poviders/booking_provider.dart';
import 'package:eventbookingapp/poviders/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/event_models.dart';
import 'booking_confirmation_screen.dart';

class TicketSelectionScreen extends StatefulWidget {
  final Event event;

  TicketSelectionScreen({required this.event});

  @override
  _TicketSelectionScreenState createState() => _TicketSelectionScreenState();
}

class _TicketSelectionScreenState extends State<TicketSelectionScreen> {
  int _ticketCount = 1;

  void _incrementTicket() {
    setState(() {
      _ticketCount++;
    });
  }

  void _decrementTicket() {
    if (_ticketCount > 1) {
      setState(() {
        _ticketCount--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;

    // Null check for currentUser
    if (currentUser == null) {
      return Scaffold(
        body: Center(
          child: Text('User not found. Please log in.'),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Hero(
                        tag: 'event-image-${widget.event.id}',
                        child: Container(
                          height: 250,
                          width: double.infinity,
                          child: Image.network(
                            widget.event.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.event.name,
                                style: AppConstants.headlineStyle.copyWith(color: Colors.white),
                              ),
                              SizedBox(height: 8),
                              Text(
                                DateFormat('EEEE, MMMM d, y').format(widget.event.date),
                                style: AppConstants.subtitleStyle.copyWith(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40,
                        left: 16,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppConstants.defaultBorderRadius,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tickets', style: AppConstants.subtitleStyle),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove_circle_outline),
                                  onPressed: _decrementTicket,
                                  color: AppConstants.primaryColor,
                                ),
                                SizedBox(width: 8),
                                Text('$_ticketCount', style: AppConstants.headlineStyle),
                                SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(Icons.add_circle_outline),
                                  onPressed: _incrementTicket,
                                  color: AppConstants.primaryColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppConstants.defaultBorderRadius,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total', style: AppConstants.subtitleStyle),
                            Text(
                              '${AppConstants.currencySymbol}${(widget.event.price * _ticketCount).toStringAsFixed(2)}',
                              style: AppConstants.headlineStyle.copyWith(color: AppConstants.secondaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              child: Text(
                'Proceed to Checkout',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              onPressed: () {
                final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
                final newBooking = Booking(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  eventId: widget.event.id,
                  userId: currentUser.id,
                  quantity: _ticketCount,
                  totalPrice: widget.event.price * _ticketCount,
                  bookingDate: DateTime.now(),
                );
                bookingProvider.addBooking(newBooking);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingConfirmationScreen(booking: newBooking),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: AppConstants.defaultBorderRadius,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
