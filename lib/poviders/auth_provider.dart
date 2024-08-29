import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _firebaseUser;
  UserModel? _user;
  bool _isLoading = false;
  String _error = '';

  User? get firebaseUser => _firebaseUser;
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String get error => _error;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _handleAuthStateChange(user);
    });
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String value) {
    _error = value;
    notifyListeners();
  }

  Future<void> _handleAuthStateChange(User? user) async {
    _firebaseUser = user;
    if (user != null) {
      await _fetchUserData(user.uid);
      await _setLoggedIn(true);
    } else {
      _user = null;
      await _setLoggedIn(false);
    }
    notifyListeners();
  }

  Future<void> _fetchUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _user = UserModel.fromFirestore(doc);
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print('Error signing in: $e');
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'profilePictureUrl': null,
          'ticketCount': 0,
        });
        await _fetchUserData(user.uid);
      }
      return true;
    } catch (e) {
      print('Error signing up: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _setLoggedIn(false);
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future<void> _setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', value);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> tryAutoLogin() async {
    if (await isLoggedIn()) {
      _firebaseUser = _auth.currentUser;
      if (_firebaseUser != null) {
        await _fetchUserData(_firebaseUser!.uid);
        notifyListeners();
      }
    }
  }
}