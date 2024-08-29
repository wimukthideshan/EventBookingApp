import 'package:eventbookingapp/firebase_init.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_models.dart';

class EventProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Event> _events = [];
  List<Event> _filteredEvents = [];
  String _searchQuery = '';
  String? _selectedLocation;
  String? _selectedCategory;
  DateTime? _selectedDate;

  List<Event> get events => _filteredEvents.isEmpty && _searchQuery.isEmpty ? _events : _filteredEvents;
  String get searchQuery => _searchQuery;

  Future<void> fetchEvents() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('events').get();
      _events = snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
      _filteredEvents = _events;
      notifyListeners();
    } catch (e) {
      print('Error fetching events: $e');
    }
  }

  void searchEvents(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void applyFilters(String? location, String? category, DateTime? date) {
    _selectedLocation = location;
    _selectedCategory = category;
    _selectedDate = date;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredEvents = _events.where((event) {
      bool matchesLocation = _selectedLocation == null || event.location == _selectedLocation;
      bool matchesCategory = _selectedCategory == null || event.category == _selectedCategory;
      bool matchesDate = _selectedDate == null ||
          (event.date.year == _selectedDate!.year &&
              event.date.month == _selectedDate!.month &&
              event.date.day == _selectedDate!.day);
      bool matchesSearch = _searchQuery.isEmpty ||
          event.name.toLowerCase().contains(_searchQuery) ||
          event.description.toLowerCase().contains(_searchQuery) ||
          event.location.toLowerCase().contains(_searchQuery) ||
          event.category.toLowerCase().contains(_searchQuery);

      return matchesLocation && matchesCategory && matchesDate && matchesSearch;
    }).toList();

    notifyListeners();
  }

  void clearFilters() {
    _selectedLocation = null;
    _selectedCategory = null;
    _selectedDate = null;
    _searchQuery = '';
    _filteredEvents = _events;
    notifyListeners();
  }

  

  List<String> get categories {
    return _events.map((e) => e.category).toSet().toList();
  }

  List<String> get locations {
    return _events.map((e) => e.location).toSet().toList();
  }
}
