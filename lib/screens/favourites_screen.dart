import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../widgets/event_list_item.dart';
import '../poviders/favourites_provider.dart';
import '../poviders/auth_provider.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
      if (authProvider.user != null) {
        favoritesProvider.fetchFavorites(authProvider.user!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites', style: AppConstants.headlineStyle.copyWith(color: Colors.white)),
      ),
      body: Consumer2<FavoritesProvider, AuthProvider>(
        builder: (context, favoritesProvider, authProvider, child) {
          if (authProvider.user == null) {
            return Center(
              child: Text('Please sign in to view your favorites', style: AppConstants.bodyStyle),
            );
          }

          if (favoritesProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryColor),
              ),
            );
          }

          final favorites = favoritesProvider.getFavorites(authProvider.user!.id);

          if (favorites.isEmpty) {
            return Center(
              child: Text('No favorite events yet', style: AppConstants.bodyStyle),
            );
          }

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final event = favorites[index];
              return EventCard(event: event);
            },
          );
        },
      ),
    );
  }
}