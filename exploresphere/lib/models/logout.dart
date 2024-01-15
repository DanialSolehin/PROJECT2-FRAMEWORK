import 'package:exploresphere/screen/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> logout(BuildContext context) async {
  try {
    await clearUserData();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  } catch (e) {
    // Handle logout errors
    print('Error during logout: $e');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error logging out. Please try again.'),
      ),
    );
  }
}

Future<void> clearUserData() async {
  final url =
      Uri.parse('https://your-firebase-project.firebaseio.com/userData.json');

  try {
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      print('User data cleared successfully');
    } else {
      print('Failed to clear user data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error clearing user data: $e');
    throw e;
  }
}
