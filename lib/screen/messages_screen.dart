import 'package:flutter/material.dart';
import '../services/mesh_service.dart';

class MessagesScreen extends StatelessWidget {
  final MeshService meshService;

  const MessagesScreen({super.key, required this.meshService});

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