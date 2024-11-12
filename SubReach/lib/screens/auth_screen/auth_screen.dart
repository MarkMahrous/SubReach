import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:subreach/screens/home/home_screen.dart';
import 'package:subreach/theme.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Sign in to Firebase with the Google user credential
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      // Navigate to the home screen after successful login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (error) {
      print("Error during Google sign-in: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign in with Google')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign In',
          style: TextStyle(
            color: AppColor.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColor.primary,
      ),
      body: Center(
        child: Container(
          color: AppColor.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/google.png',
                width: 150,
              ),
              const SizedBox(height: 30),
              const Text(
                'Welcome to Sub Reach',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primary),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => signInWithGoogle(context),
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColor.primary,
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                label: const Text('Sign in with Google'),
                icon: Image.asset(
                  'assets/images/google_icon.png',
                  width: 20,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: const Text(
                  'By signing in, you agree to our Terms of Service and Privacy Policy.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColor.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
