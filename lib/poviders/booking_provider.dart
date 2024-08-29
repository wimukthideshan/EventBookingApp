import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/booking_model.dart';

class BookingProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Booking> _bookings = [];

  List<Booking> get bookings => _bookings;

  Future<void> fetchBookings(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .get();
      _bookings = snapshot.docs.map((doc) => Booking.fromFirestore(doc)).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching bookings: $e');
    }
  }

  Future<void> addBooking(Booking booking) async {
    try {
      DocumentReference docRef = await _firestore.collection('bookings').add(booking.toFirestore());
      _bookings.add(booking.copyWith(id: docRef.id));
      notifyListeners();
    } catch (e) {
      print('Error adding booking: $e');
    }
  }
}