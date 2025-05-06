import 'package:flutter/material.dart';
import 'chat_screen.dart';

class ChatbotButton extends StatelessWidget {
  const ChatbotButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: Material(
        color: const Color.fromARGB(
            0, 165, 162, 162), // Make the background of the button transparent
        shape: CircleBorder(), // Keep the circular shape
        elevation: 0, // Remove any shadow
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen()),
            );
          },
          child: Container(
            child: Image.asset(
              'assets/images/chatbot_icon.webp', // Path to your transparent image
              width: 120, // Adjust width here
              height: 120, // Adjust height here
            ),
          ),
        ),
      ),
    );
  }
}
