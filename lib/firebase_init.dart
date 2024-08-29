import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_models.dart';

Future<void> addEventsToFirestore() async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference events = _firestore.collection('events');

  final List<Event> _allEvents = [
    Event(
      id: '1',
      name: 'Summer Music Festival',
      description: 'A weekend of great music and fun!',
      date: DateTime.parse('2024-07-15'),
      location: 'Central Park',
      price: 50.0,
      category: 'Music',
      imageUrl: 'https://media.istockphoto.com/id/1478375497/photo/friends-dancing-at-the-festival.jpg?s=612x612&w=0&k=20&c=rVwFBKe__UuQld6kJUWjV48kyw-40OHlnuyQZd4_lgQ=',
    ),
    Event(
      id: '2',
      name: 'Tech Conference 2024',
      description: 'Learn about the latest in technology.',
      date: DateTime.parse('2024-09-20'),
      location: 'Convention Center',
      price: 100.0,
      category: 'Technology',
      imageUrl: 'https://a.storyblok.com/f/188325/1920x1280/41e681c422/alexandre-pellaes-6vajp0pscx0-unsplash-1-1.jpg',
    ),
    Event(
      id: '3',
      name: 'Food and Wine Festival',
      description: 'Taste cuisines from around the world.',
      date: DateTime.parse('2024-08-05'),
      location: 'Downtown Square',
      price: 75.0,
      category: 'Food',
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTvyh_RAtqH2-bHsJKFR9x5lEGZ2zVrohsBMg&s',
    ),
    Event(
      id: '4',
      name: 'Art Exhibition',
      description: 'Featuring works from local and international artists.',
      date: DateTime.parse('2024-10-10'),
      location: 'City Art Gallery',
      price: 25.0,
      category: 'Art',
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_nSFVvQbtipxaO4YrJjfFouwCLutItd7WmQ&s',
    ),
    Event(
      id: '5',
      name: 'Marathon 2024',
      description: 'Annual city marathon for all levels.',
      date: DateTime.parse('2024-11-15'),
      location: 'City Streets',
      price: 30.0,
      category: 'Sports',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3d/Marathon_Runners.jpg/800px-Marathon_Runners.jpg',
    ),
  ];

  for (var event in _allEvents) {
    await events.doc(event.id).set(event.toFirestore());
  }

  print('All events have been added to Firestore');
}