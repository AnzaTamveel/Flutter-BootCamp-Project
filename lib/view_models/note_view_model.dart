import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoteViewModel with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Note> _notes = [];

  List<Note> get notes => _notes;

  Future<void> fetchNotes(String userId) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .orderBy('createdAt', descending: true)
        .get();

    _notes = querySnapshot.docs
        .map((doc) =>
            Note.fromMap(doc.data() as Map<String, dynamic>)..noteId = doc.id)
        .toList();

    notifyListeners();  // Notify listeners to update UI
  }

  Future<void> addNote(String title, String content, String category) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User is not authenticated!");
      return; // Prevent further execution
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .add({
      'userId': user.uid,
      'title': title,
      'content': content,
      'category': category,
      'createdAt': Timestamp.now(),
    }).then((_) {
      print("Note added successfully!");
    }).catchError((error) {
      print("Failed to add note: $error");
    });
    notifyListeners();  // Notify listeners after adding note
  }

  Future<void> updateNote(Note note) async {
    await _firestore.collection('users').doc(note.userId).collection('notes').doc(note.noteId).update(note.toMap());
    notifyListeners();
  }

  Future<void> deleteNote(String noteId) async {
    final user = FirebaseAuth.instance.currentUser;
    await _firestore.collection('users').doc(user!.uid).collection('notes').doc(noteId).delete();
    _notes.removeWhere((note) => note.noteId == noteId);
    notifyListeners();
  }
}
