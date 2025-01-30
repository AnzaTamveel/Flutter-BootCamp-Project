import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/note_view_model.dart';
import '../models/note.dart';

class AddNoteScreen extends StatefulWidget {
  final Note? note;

  AddNoteScreen({this.note});

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedCategory = 'General'; // Default category
  List<String> categories = ['General', 'Work', 'Personal', 'Ideas']; // List of categories

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _selectedCategory = widget.note!.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteVM = Provider.of<NoteViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.note == null ? 'Add Note' : 'Edit Note',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.blue.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.blue.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
              children: [
                // Title Field
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      hintText: 'Enter a title',
                      labelStyle: TextStyle(color: Colors.white70),
                      hintStyle: TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.blue.shade800),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.3),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 16),

                // Content Field
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
                  child: TextField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      labelText: 'Content',
                      hintText: 'Write your note content',
                      labelStyle: TextStyle(color: Colors.white70),
                      hintStyle: TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.blue.shade800),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.3),
                    ),
                    maxLines: 5,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 16),

                // Category Dropdown
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      labelStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.blue.shade800),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.3),
                    ),
                    dropdownColor: Colors.blue.shade900,
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
                ),
                SizedBox(height: 24),

                // Add/Update Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    shadowColor: Colors.blueAccent.withOpacity(0.5),
                  ),
                  onPressed: () async {
                    // Validate inputs
                    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Title and Content cannot be empty! ❌"),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                      return; // Stop execution if validation fails
                    }

                    final noteVM = Provider.of<NoteViewModel>(context, listen: false);

                    try {
                      if (widget.note == null) {
                        await noteVM.addNote(
                          _titleController.text,
                          _contentController.text,
                          _selectedCategory,
                        );
                      } else {
                        widget.note!.title = _titleController.text;
                        widget.note!.content = _contentController.text;
                        widget.note!.category = _selectedCategory;

                        await noteVM.updateNote(widget.note!);
                      }

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(widget.note == null
                                ? "Note added successfully! ✅"
                                : "Note updated successfully! ✅"),
                            duration: Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.blueAccent,
                          ),
                        );

                        Navigator.pop(context);
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Failed to save note ❌"),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                  child: Text(
                    widget.note == null ? 'Add Note' : 'Update Note',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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