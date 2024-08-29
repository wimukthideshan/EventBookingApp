import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profilePictureUrl;
  final String primaryCity;
  int ticketCount;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profilePictureUrl,
    required this.primaryCity,
    this.ticketCount = 0,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      profilePictureUrl: data['profilePictureUrl'],
      primaryCity: data['primaryCity'] ?? '',
      ticketCount: data['ticketCount'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'profilePictureUrl': profilePictureUrl,
      'primaryCity': primaryCity,
      'ticketCount': ticketCount,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profilePictureUrl,
    String? primaryCity,
    int? ticketCount,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      primaryCity: primaryCity ?? this.primaryCity,
      ticketCount: ticketCount ?? this.ticketCount,
    );
  }
}