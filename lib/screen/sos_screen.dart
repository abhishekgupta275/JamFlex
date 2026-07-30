import 'package:flutter/material.dart';
import '../services/mesh_service.dart';

class SosScreen extends StatelessWidget {
  final MeshService meshService;

  const SosScreen({super.key, required this.meshService});

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