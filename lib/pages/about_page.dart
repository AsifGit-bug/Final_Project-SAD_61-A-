import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Us')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "Welcome to the Book Management App!\n\n"
          "This app is built using Flutter and Supabase. "
          "It helps you manage your book collection efficiently "
          "with CRUD operations and beautiful views.\n\n"
          "Developed by Asif Bin A.Rahman.",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
