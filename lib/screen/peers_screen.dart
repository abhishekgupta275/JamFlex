import 'package:flutter/material.dart';

class PeersScreen extends StatelessWidget {
  const PeersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JamFlex Peers'),
      ),
      body: const Center(
        child: Text('Peers Screen!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}