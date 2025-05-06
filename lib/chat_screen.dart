import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:google_fonts/google_fonts.dart';
import 'chatbot_service.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<types.Message> _messages = [];
  final ChatbotService _chatbotService = ChatbotService();

  types.TextMessage? _analyzingMessage;
  Timer? _typingTimer;
  int _dotCount = 1;

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    final botMessage = types.TextMessage(
      author: types.User(id: 'bot'),
      id: UniqueKey().toString(),
      text: "Hi! 👋 I'm WasteBot. How can I assist you today?\n\n"
          "🔹 Ask about recycling.\n"
          "🔹 Get waste disposal tips.\n"
          "🔹 Learn eco-friendly habits.",
    );

    setState(() {
      _messages.insert(0, botMessage);
    });
  }

  void _startTypingAnimation() {
    _analyzingMessage = types.TextMessage(
      author: types.User(id: 'bot'),
      id: UniqueKey().toString(),
      text: "Analyzing.",
    );

    setState(() {
      _messages.insert(0, _analyzingMessage!);
    });

    _typingTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_analyzingMessage != null) {
        _dotCount = (_dotCount % 3) + 1;
        String dots = '.' * _dotCount;

        final updatedMessage = types.TextMessage(
          author: _analyzingMessage!.author,
          id: _analyzingMessage!.id,
          text: "Analyzing$dots",
        );

        setState(() {
          final index =
              _messages.indexWhere((msg) => msg.id == _analyzingMessage!.id);
          if (index != -1) {
            _messages[index] = updatedMessage;
          }
        });
      }
    });
  }

  void _stopTypingAnimation() {
    _typingTimer?.cancel();
    _typingTimer = null;

    setState(() {
      _messages.removeWhere((msg) => msg.id == _analyzingMessage?.id);
    });

    _analyzingMessage = null;
    _dotCount = 1;
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = types.TextMessage(
      author: types.User(id: 'user'),
      id: UniqueKey().toString(),
      text: text,
    );

    setState(() {
      _messages.insert(0, userMessage);
    });

    _startTypingAnimation();

    final response = await _chatbotService.getResponse(text);

    _stopTypingAnimation();

    final botReply = types.TextMessage(
      author: types.User(id: 'bot'),
      id: UniqueKey().toString(),
      text: response,
    );

    setState(() {
      _messages.insert(0, botReply);
    });
  }

  Widget _quickActionButton(String text) {
    return ElevatedButton(
      onPressed: () => _sendMessage(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[700],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          '♻ WasteBot - Eco Helper',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
            child: Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: [
                _quickActionButton("♻ How to recycle plastic?"),
                _quickActionButton("🗑 Where to dispose batteries?"),
                _quickActionButton("🌱 Eco-friendly tips"),
              ],
            ),
          ),
          Divider(thickness: 2),
          Expanded(
            child: Chat(
              messages: _messages, // 👈 DO NOT reverse the list
              onSendPressed: (partialText) {
                _sendMessage(partialText.text);
              },
              user: types.User(id: 'user'),
              theme: DefaultChatTheme(
                inputBackgroundColor: Colors.white,
                inputTextColor: Colors.black,
                backgroundColor: Colors.grey[200]!,
                primaryColor: Colors.green[700]!,
                userAvatarNameColors: [Colors.blue],
                userNameTextStyle:
                    GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
