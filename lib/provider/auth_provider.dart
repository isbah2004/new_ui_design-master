import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ui_design/screens/homescreen/home_screen.dart';
import 'package:ui_design/utils/utils.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _loading = false;

  bool get loading => _loading;
  User? get user => _user;

  // This function returns a stream that emits the current user state.
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> signInWithEmail(
      String email, String password, BuildContext context) async {
    try {
      setLoading(true);
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      });
    } catch (e) {
      // Handle error (e.g., show a toast message)
      Utils.toastMessage(message: 'Error: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> signUpWithEmail(
      String email, String password, BuildContext context) async {
    try {
      setLoading(true);
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password).then((value) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      });
    } catch (e) {
      Utils.toastMessage(message: 'Error: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      // Handle error (e.g., show a toast message)
      Utils.toastMessage(message: 'Logout failed. Please try again.');
    }
  }

  // Validator for email
  String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'Please enter your email';
    }
    // Using a basic email regex pattern
    final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Validator for password
// Validator for password
String? validatePassword(String password) {
  if (password.isEmpty) return 'Enter your password';
  if (password.length < 6) return 'At least 6 characters';
  if (!RegExp(r'[A-Z]').hasMatch(password)) return 'Add an uppercase letter';
  if (!RegExp(r'[a-z]').hasMatch(password)) return 'Add a lowercase letter';
  if (!RegExp(r'[0-9]').hasMatch(password)) return 'Add a number';
  if (!RegExp(r'`~!@#$%^&*()-_=+[{\|;:<>?,./"}]').hasMatch(password)) return 'Add a special character';
  return null;
}


  // Forgot password function
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Utils.toastMessage(message: 'Password reset email sent.');
    } catch (e) {
      Utils.toastMessage(message: 'Failed to send password reset email.');
    }
  }
}
