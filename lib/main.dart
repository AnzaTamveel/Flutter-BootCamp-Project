import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'views/login_screen.dart';
import 'views/home_screen.dart';
import 'view_models/auth_view_model.dart';
import 'view_models/note_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => NoteViewModel()),
      ],
      child: MaterialApp(
        title: 'Note Taking App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<AuthViewModel>(
          builder: (context, authVM, _) {
            return authVM.isAuthenticated
                ? HomeScreen()
                : LoginScreen();
          },
        ),
      ),
    );
  }
}
