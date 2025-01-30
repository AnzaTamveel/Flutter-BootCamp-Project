import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference notes = FirebaseFirestore.instance.collection('notes');

  Future<void> addNote(String title, String content) async {
    await notes.add({
      'title': title,
      'content': content,
      'createdAt': Timestamp.now(),
    });
  }

  Future<void> updateNote(String noteId, String title, String content) async {
    await notes.doc(noteId).update({
      'title': title,
      'content': content,
    });
  }

  Future<void> deleteNote(String noteId) async {
    await notes.doc(noteId).delete();
  }

  Stream<QuerySnapshot> getNotesStream() {
    return notes.orderBy('createdAt', descending: true).snapshots();
  }
}