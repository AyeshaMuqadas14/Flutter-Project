import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotesService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create a note
  Future<void> createNote(String title, String content) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _db.collection('notes').add({
      'title': title,
      'content': content,
      'userId': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Get all notes
  Stream<List<Map<String, dynamic>>> getNotes() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.empty();

    return _db
        .collection('notes')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // Update a note
  Future<void> updateNote(String noteId, String title, String content) async {
    await _db.collection('notes').doc(noteId).update({
      'title': title,
      'content': content,
    });
  }

  // Delete a note
  Future<void> deleteNote(String noteId) async {
    await _db.collection('notes').doc(noteId).delete();
  }
}
