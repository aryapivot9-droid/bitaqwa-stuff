import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<String> images = const [
    'assets/image1',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: ListView(
        padding: const EdgeInsets.only(
          top: 40,
          bottom: 30,
        ),

        children: [

          const Center(
            child: Text(
              'INT document',
              style: TextStyle(
                fontSize: 10,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 30),

          for (String image in images)
            Padding(
              padding: const EdgeInsets.only(
                left: 45,
                right: 45,
                bottom: 15,
              ),
              child: Image.asset(
                image,
                fit: BoxFit.contain,
              ),
            ),
        ],
      ),
    );
  }
}