import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui'; // For BackdropFilter
import 'package:firebase_auth/firebase_auth.dart';
import 'add_note_screen.dart'; // Make sure you have this screen to add a note
import 'edit_note_screen.dart'; // Make sure you have this screen to add a note

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController _searchController = TextEditingController();
  String selectedCategory = 'All'; // Default category filter
  List<String> categories = ['All', 'Work', 'Personal', 'Study']; // Example categories

  // Fetching notes from Firestore
  Stream<QuerySnapshot> _getNotesStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case when the user is not authenticated
      return Stream.empty(); // Return an empty stream if the user is not logged in
    }

    Query notesQuery = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes'); // Get notes for the current user

    // Apply search filters
    if (_searchController.text.isNotEmpty) {
      notesQuery = notesQuery
          .where('title', isGreaterThanOrEqualTo: _searchController.text)
          .where('title', isLessThan: _searchController.text + 'z');
    }

    // Apply category filter
    if (selectedCategory != 'All') {
      notesQuery = notesQuery.where('category', isEqualTo: selectedCategory);
    }

    return notesQuery.snapshots();
  }

  // Function to delete a note
  Future<void> _deleteNote(String noteId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case when the user is not authenticated
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("You must be logged in to delete a note."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('notes')
          .doc(noteId)
          .delete();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Note deleted successfully! ✅"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete note. Please try again. ❌"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.indigo.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Main Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Heading with bold text and glowing effect
                Text(
                  'My Notes',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.cyanAccent.withOpacity(0.8),
                        blurRadius: 10,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Search and Category Filters
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Search by title
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: 'Search by Title',
                          labelStyle: TextStyle(color: Colors.cyanAccent),
                          prefixIcon: Icon(Icons.search, color: Colors.cyanAccent),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyanAccent),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyanAccent),
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    SizedBox(width: 20),
                    // Category dropdown
                    DropdownButton<String>(
                      value: selectedCategory,
                      onChanged: (String? newCategory) {
                        setState(() {
                          selectedCategory = newCategory!;
                        });
                      },
                      items: categories.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      dropdownColor: Colors.black.withOpacity(0.7),
                      style: TextStyle(color: Colors.cyanAccent),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // List of notes with filter applied
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.cyanAccent.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: StreamBuilder<QuerySnapshot>(
                          stream: _getNotesStream(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return Center(child: Text('No notes available.'));
                            }

                            var notes = snapshot.data!.docs;

                            return ListView.builder(
                              itemCount: notes.length,
                              itemBuilder: (context, index) {
                                var note = notes[index];
                                return Card(
                                  color: Colors.black.withOpacity(0.4),
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          note['title'], // Assuming the note has a 'title' field
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          note['content'], // Assuming the note has a 'content' field
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Category: ${note['category']}',
                                          style: TextStyle(
                                            color: Colors.cyanAccent,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            // Edit button
                                            ElevatedButton(
                                              onPressed: () {
                                                // Pass note data to edit screen
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => EditNoteScreen(
                                                      noteId: note.id,
                                                      title: note['title'],
                                                      content: note['content'],
                                                      category: note['category'],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Text('Edit'),
                                            ),
                                            SizedBox(width: 10), // Add spacing between buttons
                                            // Delete button
                                            ElevatedButton(
                                              onPressed: () {
                                                // Show a confirmation dialog before deleting
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                    title: Text("Delete Note"),
                                                    content: Text(
                                                        "Are you sure you want to delete this note?"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(context); // Close the dialog
                                                        },
                                                        child: Text("Cancel"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          Navigator.pop(context); // Close the dialog
                                                          await _deleteNote(note.id); // Delete the note
                                                        },
                                                        child: Text(
                                                          "Delete",
                                                          style: TextStyle(color: Colors.red),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.redAccent,
                                              ),
                                              child: Text('Delete'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                // Add Button with hover effect
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.cyanAccent, Colors.blueAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyanAccent.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddNoteScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent, // Corrected here
                        elevation: 0,
                      ),
                      child: Text(
                        'Add a New Note',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}