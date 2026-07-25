import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JamFlex Messages'),
      ),
      body: Center(
        child: Text('Messages Screen!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}