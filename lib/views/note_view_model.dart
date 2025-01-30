import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NoteViewModel with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  Stream<QuerySnapshot> getNotesStream() {
    return _firestoreService.getNotesStream();
  }

  Future<void> addNote(String title, String content) async {
    await _firestoreService.addNote(title, content);
    notifyListeners();
  }

  Future<void> updateNote(String noteId, String title, String content) async {
    await _firestoreService.updateNote(noteId, title, content);
    notifyListeners();
  }

  Future<void> deleteNote(String noteId) async {
    await _firestoreService.deleteNote(noteId);
    notifyListeners();
  }
}