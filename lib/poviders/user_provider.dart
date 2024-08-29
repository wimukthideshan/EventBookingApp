import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'auth_provider.dart';

class UserProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthProvider _authProvider;
  UserModel? _currentUser;
  bool _isLoading = false;

  UserProvider(this._authProvider) {
    _authProvider.addListener(_updateUserFromAuth);
    _updateUserFromAuth();
  }

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  Future<void> _updateUserFromAuth() async {
    final user = _authProvider.user;
    if (user != null) {
      _isLoading = true;
      notifyListeners();
      await _fetchUserData(user.id);
      _isLoading = false;
      notifyListeners();
    } else {
      _currentUser = null;
      notifyListeners();
    }
  }

  Future<void> _fetchUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _currentUser = UserModel.fromFirestore(doc);
        await _updateTicketCount(uid);
      } else {
        _currentUser = null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      _currentUser = null;
    }
  }

  Future<void> _updateTicketCount(String uid) async {
    try {
      QuerySnapshot bookings = await _firestore
          .collection('bookings')
          .where('userId', isEqualTo: uid)
          .get();
      
      int totalTickets = bookings.docs.fold(0, (sum, doc) => sum + (doc['quantity'] as int? ?? 0));
      
      if (_currentUser != null && _currentUser!.ticketCount != totalTickets) {
        _currentUser = _currentUser!.copyWith(ticketCount: totalTickets);
        await _firestore.collection('users').doc(uid).update({'ticketCount': totalTickets});
        notifyListeners();
      }
    } catch (e) {
      print('Error updating ticket count: $e');
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toFirestore());
      _currentUser = user;
      notifyListeners();
    } catch (e) {
      print('Error updating user data: $e');
    }
  }
}