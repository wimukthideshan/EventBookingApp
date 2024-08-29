import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String eventId;
  final String userId;
  final int quantity;
  final double totalPrice;
  final DateTime bookingDate;

  Booking({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.quantity,
    required this.totalPrice,
    required this.bookingDate,
  });

  Booking copyWith({
    String? id,
    String? eventId,
    String? userId,
    int? quantity,
    double? totalPrice,
    DateTime? bookingDate,
  }) {
    return Booking(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      userId: userId ?? this.userId,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      bookingDate: bookingDate ?? this.bookingDate,
    );
  }

  factory Booking.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Booking(
      id: doc.id,
      eventId: data['eventId'] ?? '',
      userId: data['userId'] ?? '',
      quantity: data['quantity'] ?? 0,
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      bookingDate: (data['bookingDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'eventId': eventId,
      'userId': userId,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'bookingDate': Timestamp.fromDate(bookingDate),
    };
  }
}