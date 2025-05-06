import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter_web/google_maps_flutter_web.dart';
import 'start_page.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'role_selection_page.dart';
import 'firebase_options.dart';
import 'locations.dart' as locations;
import 'chatbot_button.dart'; // ✅ Import the chatbot button

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const Trash2TreasureApp());
}

class Trash2TreasureApp extends StatelessWidget {
  const Trash2TreasureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const AppWithChatbot(child: LandingPage()),
        '/start': (context) => const AppWithChatbot(child: StartPage()),
        '/login': (context) => const AppWithChatbot(child: LoginPage()),
        '/register': (context) => const AppWithChatbot(child: RegisterPage()),
        '/roleSelection': (context) =>
            const AppWithChatbot(child: RoleSelectionPage()),
      },
    );
  }
}

class AppWithChatbot extends StatelessWidget {
  final Widget child;
  const AppWithChatbot({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          child, // Your page (RoleSelectionPage)
          const ChatbotButton(), // Chatbot button floating above
        ],
      ),
    );
  }
}

// Landing Page remains here
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
            width: 150,
            child: Image.asset('assets/images/landing.jpeg', fit: BoxFit.cover),
          ),
          const SizedBox(height: 20),
          const Text(
            'Trash2Treasure',
            style: TextStyle(
              color: Colors.green,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/start');
            },
            child: const Text(
              'Get Started',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: const Text(
              'Already have an account? Sign In',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
