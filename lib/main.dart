import 'package:eventbookingapp/firebase_init.dart';
import 'package:eventbookingapp/poviders/auth_provider.dart';
import 'package:eventbookingapp/poviders/booking_provider.dart';
import 'package:eventbookingapp/poviders/bottom_navigation_provider.dart';
import 'package:eventbookingapp/poviders/event_provider.dart';
import 'package:eventbookingapp/poviders/favourites_provider.dart';
import 'package:eventbookingapp/poviders/user_provider.dart';
import 'package:eventbookingapp/screens/main_screen.dart';
import 'package:eventbookingapp/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await addEventsToFirestore();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, UserProvider>(
          create: (context) => UserProvider(context.read<AuthProvider>()),
          update: (context, authProvider, userProvider) =>
              UserProvider(authProvider),
        ),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => BottomNavigationProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appName,
        theme: ThemeData(
          primaryColor: AppConstants.primaryColor,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: AppConstants.primaryColor,
            secondary: AppConstants.secondaryColor,
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppConstants.primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.secondaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: AppConstants.defaultBorderRadius,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          textTheme: TextTheme(
            titleLarge: AppConstants.headlineStyle,
            titleMedium: AppConstants.subtitleStyle,
            bodyMedium: AppConstants.bodyStyle,
          ),
        ),
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return FutureBuilder(
      future: authProvider.tryAutoLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else {
          return Consumer<AuthProvider>(
            builder: (context, auth, _) {
              if (auth.user != null) {
                return MainScreen();
              } else {
                return SignInScreen();
              }
            },
          );
        }
      },
    );
  }
}