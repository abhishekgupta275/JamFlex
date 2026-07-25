import 'package:flutter/material.dart';

class SosScreen extends StatelessWidget {
  const SosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JamFlex SOS'),
      ),
      body: Center(
        child: Text('SOS Screen!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}