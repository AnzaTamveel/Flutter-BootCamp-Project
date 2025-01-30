import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditNoteScreen extends StatefulWidget {
  final String noteId;
  final String title;
  final String content;
  final String category;

  EditNoteScreen({
    required this.noteId,
    required this.title,
    required this.content,
    required this.category,
  });

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedCategory = 'General'; // Default category
  List<String> categories = ['General', 'Work', 'Personal', 'Ideas']; // List of categories

  @override
  void initState() {
    super.initState();
    // Pre-fill the fields with the existing note data
    _titleController.text = widget.title;
    _contentController.text = widget.content;
    _selectedCategory = widget.category;
  }

  Future<void> _updateNote() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case when the user is not authenticated
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("You must be logged in to update a note."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Validate inputs
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Title and Content cannot be empty! ❌"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    try {
      // Update the note in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('notes')
          .doc(widget.noteId)
          .update({
        'title': _titleController.text,
        'content': _contentController.text,
        'category': _selectedCategory,
        'updatedAt': Timestamp.now(), // Update the timestamp
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Note updated successfully! ✅"),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back to the previous screen
      Navigator.pop(context);
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update note. Please try again. ❌"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Edit Note',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.indigo.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.indigo.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Field
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter a title',
                    labelStyle: TextStyle(color: Colors.white70),
                    hintStyle: TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.indigo.shade800),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.cyanAccent),
                    ),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.3),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 16),

                // Content Field
                TextField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    labelText: 'Content',
                    hintText: 'Write your note content',
                    labelStyle: TextStyle(color: Colors.white70),
                    hintStyle: TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.indigo.shade800),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.cyanAccent),
                    ),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.3),
                  ),
                  maxLines: 5,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 16),

                // Category Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.indigo.shade800),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.cyanAccent),
                    ),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.3),
                  ),
                  dropdownColor: Colors.indigo.shade900,
                  style: TextStyle(color: Colors.white),
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (newCategory) {
                    setState(() {
                      _selectedCategory = newCategory!;
                    });
                  },
                ),
                SizedBox(height: 24),

                // Update Button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      shadowColor: Colors.cyanAccent.withOpacity(0.5),
                    ),
                    onPressed: _updateNote,
                    child: Text(
                      'Update Note',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}