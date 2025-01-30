import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String noteId;
  String title;
  String content;
  String category;
  String userId;  // Add userId here
  Timestamp createdAt;

  Note({
    required this.noteId,
    required this.title,
    required this.content,
    required this.category,
    required this.userId,  // Add this parameter
    required this.createdAt,
  });

  // Convert Firestore data to a Note instance
  factory Note.fromMap(Map<String, dynamic> data) {
    return Note(
      noteId: '',
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      category: data['category'] ?? '',
      userId: data['userId'] ?? '',  // Ensure that the userId is being fetched from Firestore
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  // Convert Note instance to a map for Firestore update
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'category': category,
      'userId': userId,  // Include userId in toMap
      'createdAt': createdAt,
    };
  }
}
