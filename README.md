# Event Booking App

## Overview

The Event Booking App is a Flutter-based mobile application that allows users to browse, search, and book tickets for various events. It provides a user-friendly interface for discovering events, managing bookings, and maintaining a list of favorite events.

## Features

- User authentication (sign up, sign in, sign out)
- Browse upcoming events
- Search events by name, description, or location
- Filter events by category, date, and location
- View detailed event information
- Book tickets for events
- Manage bookings and view tickets
- Add events to favorites
- User profile management

## Technologies Used

- Flutter
- Dart
- Firebase (Authentication, Firestore)
- Provider (State Management)

## Setup Instructions

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/event-booking-app.git
   ```

2. Navigate to the project directory:
   ```
   cd event-booking-app
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Set up Firebase:
   - Create a new Firebase project in the Firebase Console
   - Add an Android and/or iOS app to your Firebase project
   - Download the `google-services.json` (for Android) and/or `GoogleService-Info.plist` (for iOS) and place them in the appropriate directories
   - Enable Email/Password authentication in the Firebase Console
   - Set up Cloud Firestore in the Firebase Console

5. Update Firebase configuration:
   - Replace the Firebase configuration in `lib/firebase_options.dart` with your own Firebase project's configuration

6. Run the app:
   ```
   flutter run
   ```

## Project Structure

- `lib/`
  - `constants/`: App-wide constants and theme data
  - `models/`: Data models (Event, Booking, User)
  - `providers/`: State management using Provider
  - `screens/`: UI screens
  - `widgets/`: Reusable UI components
  - `main.dart`: Entry point of the application
