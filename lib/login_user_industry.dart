import 'package:flutter/material.dart';
import 'package:landing_page_app/main.dart';
import 'role_selection_page.dart';
import 'industry_registration_page.dart';
import 'chatbot_button.dart'; // Import the ChatbotButton widget

class LoginUserIndustry extends StatelessWidget {
  const LoginUserIndustry({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo Image
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image.asset('assets/images/loginpage.jpeg',
                      fit: BoxFit.cover),
                ),
                const SizedBox(height: 20),

                // LOGIN AS USER BUTTON (Navigates to RoleSelectionPage)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const AppWithChatbot(child: RoleSelectionPage()),
                      ),
                    );
                  },
                  child: const Text('LOGIN AS USER',
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 20),

                // LOGIN AS INDUSTRY BUTTON (Navigates to IndustryRegistrationPage)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IndustryRegistrationPage(),
                      ),
                    );
                  },
                  child: const Text('LOGIN AS INDUSTRY',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
