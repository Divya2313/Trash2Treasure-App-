import 'package:flutter/material.dart';
import './auth_service.dart'; // Import AuthService
import 'login_user_industry.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigningIn = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isSigningIn = true;
    });

    final userCredential = await AuthService().signInWithGoogle();

    setState(() {
      _isSigningIn = false;
    });

    if (userCredential != null) {
      print("✅ User Signed In: ${userCredential.user?.displayName}");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginUserIndustry()),
      );
    } else {
      print("❌ Google Sign-In Failed");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Google Sign-In Failed"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleLogin() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      // TODO: Implement actual login authentication
      print("✅ Login Successful: $email");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginUserIndustry()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter email and password"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
                SizedBox(height: 20),

                // Email Input Field
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter Email',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Password Input Field
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter Password',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Login Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _handleLogin,
                  child: Text('LOGIN', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 20),

                // Sign Up Navigation
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text('Don’t have an account? Sign Up',
                      style: TextStyle(color: Colors.black)),
                ),
                SizedBox(height: 20),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.black)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("OR"),
                    ),
                    Expanded(child: Divider(color: Colors.black)),
                  ],
                ),
                SizedBox(height: 10),

                // Google Sign-In Button
                _isSigningIn
                    ? CircularProgressIndicator()
                    : ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(color: Colors.green),
                          ),
                        ),
                        onPressed: _handleGoogleSignIn,
                        icon: Image.asset('assets/images/google_logo.png',
                            height: 24, width: 24),
                        label: Text('Continue with Google',
                            style: TextStyle(color: Colors.black)),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
