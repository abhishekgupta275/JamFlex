import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  final VoidCallback onDone;

  const OnboardingScreen({super.key, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding')),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, 
        children: [ 
          const Text('Welcome to JamFlex!', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onDone,
            child: const Text('Get Started'),
          ),
        ]
        ),
      ),
    );
  }
}