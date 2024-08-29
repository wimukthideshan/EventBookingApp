import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_models.dart';

class FavoritesProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, List<Event>> _userFavorites = {};
  bool _isLoading = false;

  List<Event> getFavorites(String userId) => _userFavorites[userId] ?? [];
  bool get isLoading => _isLoading;

  bool isFavorite(Event event) {
    return _userFavorites.values.any((list) => list.any((e) => e.id == event.id));
  }

  Future<void> fetchFavorites(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .get();
      _userFavorites[userId] = snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching favorites: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(Event event, String userId) async {
    try {
      DocumentReference docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(event.id);

      if (isFavorite(event)) {
        await docRef.delete();
        _userFavorites[userId]?.removeWhere((e) => e.id == event.id);
      } else {
        await docRef.set(event.toFirestore());
        _userFavorites[userId] ??= [];
        _userFavorites[userId]!.add(event);
      }
      notifyListeners();
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }
}