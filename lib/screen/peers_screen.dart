import 'package:flutter/material.dart';
import '../services/mesh_service.dart';

class PeersScreen extends StatelessWidget {
  final MeshService meshService;

  const PeersScreen({super.key, required this.meshService});

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