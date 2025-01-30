import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';
import 'dart:ui'; // Import for the BackdropFilter widget

class SignupScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Heading with bold text and glowing effect
                Text(
                  'Sign Up',
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
                SizedBox(height: 50),

                // Center the container with email and password fields and make it smaller
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Container(
                        width: 350, // Set a smaller width for the container
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.cyanAccent.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            // Email input field with custom icon and floating label
                            TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(color: Colors.cyanAccent),
                                prefixIcon: Icon(Icons.email, color: Colors.cyanAccent),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.cyanAccent),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.cyanAccent),
                                ),
                              ),
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 20),
                            // Password input field with custom icon and floating label
                            TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(color: Colors.cyanAccent),
                                prefixIcon: Icon(Icons.lock, color: Colors.cyanAccent),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.cyanAccent),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.cyanAccent),
                                ),
                              ),
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),

                // Sign Up Button with hover effect
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
                      onPressed: () async {
                        final authVM = Provider.of<AuthViewModel>(context, listen: false);
                        try {
                          await authVM.signUp(
                            _emailController.text,
                            _passwordController.text,
                          );
                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Sign Up Failed: ${e.toString()}')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Login navigation link with hover effect
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Already have an account? Login',
                      style: TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
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
