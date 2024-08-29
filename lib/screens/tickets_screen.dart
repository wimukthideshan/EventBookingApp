import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../models/booking_model.dart';
import '../models/event_models.dart';
import '../poviders/booking_provider.dart';
import '../poviders/event_provider.dart';
import '../poviders/user_provider.dart';
import 'package:intl/intl.dart';

class TicketsScreen extends StatefulWidget {
  @override
  _TicketsScreenState createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    if (userProvider.currentUser != null) {
      await bookingProvider.fetchBookings(userProvider.currentUser!.id);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Tickets', style: AppConstants.headlineStyle.copyWith(color: Colors.white)),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Consumer<BookingProvider>(
              builder: (context, bookingProvider, child) {
                if (bookingProvider.bookings.isEmpty) {
                  return Center(
                    child: Text('No tickets booked yet.', style: AppConstants.bodyStyle),
                  );
                }
                return ListView.builder(
                  itemCount: bookingProvider.bookings.length,
                  itemBuilder: (context, index) {
                    return TicketItem(booking: bookingProvider.bookings[index]);
                  },
                );
              },
            ),
    );
  }
}

class TicketItem extends StatelessWidget {
  final Booking booking;

  TicketItem({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, eventProvider, child) {
        final event = eventProvider.events.firstWhere(
          (e) => e.id == booking.eventId,
          orElse: () => Event(
            id: '',
            name: 'Unknown Event',
            description: '',
            date: DateTime.now(),
            location: '',
            price: 0,
            category: '',
            imageUrl: '',
          ),
        );

        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.name, style: AppConstants.subtitleStyle),
                SizedBox(height: 8),
                Text(DateFormat('EEEE, MMMM d, y').format(event.date), style: AppConstants.bodyStyle),
                SizedBox(height: 8),
                Text('${event.location}', style: AppConstants.bodyStyle),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Quantity: ${booking.quantity}', style: AppConstants.bodyStyle),
                    Text('Total: ${AppConstants.currencySymbol}${booking.totalPrice.toStringAsFixed(2)}',
                        style: AppConstants.bodyStyle.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}