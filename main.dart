
import 'package:exploresphere/screen/welcome_screen.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true
        // Add any other theme configurations you want here
      ),
      home: WelcomeScreen(), // Set LoginPage as the home route
    );
  }
}
