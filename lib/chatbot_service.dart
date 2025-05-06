import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatbotService {
  final String apiKey = "AIzaSyDRUfeIUUizeKG3RiKcSEIXyCzGi5w7h5I";

  Future<String> getResponse(String message) async {
    final response = await http.post(
      Uri.parse(
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "contents": [
          {
            "role": "user",
            "parts": [
              {"text": message}
            ]
          }
        ]
      }),
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'] ??
          "No response from AI.";
    } else {
      return "Error: ${response.body}";
    }
  }
}
