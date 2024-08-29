// lib/constants.dart

import 'package:flutter/material.dart';

class AppConstants {
  // Brand Colors
  static const Color primaryColor = Color(0xFF8A2BE2);  // Purple
  static const Color secondaryColor = Color(0xFF5F9EA0);  // Cadet Blue

  // Text Styles
  static const TextStyle headlineStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: Colors.black54,
  );

  // Padding
  static const double defaultPadding = 16.0;

  // BorderRadius
  static final BorderRadius defaultBorderRadius = BorderRadius.circular(8.0);

  // App Name
  static const String appName = "Event Booker";

  // Date Format
  static const String dateFormat = "yyyy-MM-dd";

  // Currency Symbol
  static const String currencySymbol = "LKR ";

  // Error Messages
  static const String generalErrorMessage = "An error occurred. Please try again.";
  static const String networkErrorMessage = "Network error. Please check your internet connection.";

  // Button Text
  static const String bookNowText = "Book Now";
  static const String confirmBookingText = "Confirm Booking";

  // Screen Titles
  static const String homeScreenTitle = "Upcoming Events";
  static const String eventDetailsTitle = "Event Details";
  static const String bookingConfirmationTitle = "Booking Confirmation";

  // Filter Labels
  static const String categoryFilterLabel = "Category";
  static const String dateFilterLabel = "Select Date";
  static const String locationFilterLabel = "Search by location";
}