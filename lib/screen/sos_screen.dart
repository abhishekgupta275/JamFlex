import 'package:flutter/material.dart';
import '../services/mesh_service.dart';

class SosScreen extends StatefulWidget {
  final MeshService meshService;

  const SosScreen({super.key, required this.meshService});

@override
State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  bool _isSosActive = false;

  @override
  Widget build(BuildContext context){
    final activePeersCount = widget.meshService.peers.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('JamFlex Emergency SOS'), 
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [

            _buildSosToggleCard(activePeersCount),
            const SizedBox(height: 20),

            _buildLocationCard(),
            const SizedBox(height: 20),

            _buildMedicalIdCard(),
          ],
        ),
      ),
    );
  }


  Widget _buildSosToggleCard(int peerCount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isSosActive ? Colors.red.shade50 : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
        width: 2,
      ),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: _isSosActive ? Colors.red : Colors.grey.shade400,
          child: Icon(
            _isSosActive ? Icons.warning : Icons.power_settings_new,
            color: Colors.white,
            size: 30,
          ),
        ),

        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isSosActive ? 'DISTRESS BEACON ON' : 'Distress Beacon Off',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _isSosActive ? Colors.red : Colors.black87, 
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _isSosActive
                   ? 'Broadcasting to $peerCount mesh peers'
                   : 'Toggle to broadcasting emergency signal',
                   style: const TextStyle(fontSize: 12, color: Colors.grey),             
              ),
            ],
          ),
        ),
    Switch(
      value: _isSosActive,
      activeColor: Colors.red,
      onChanged: (value) {
        setState(() {
            _isSosActive = value;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _isSosActive
                  ? 'SOS Beacon Activated! Broadcasting over mesh.'
                  : 'SOS Beacon Deactivated.',
              ),
              backgroundColor:  _isSosActive ? Colors.red : Colors.grey.shade800,
              ),
            );
          },
        ),
      ],
    ),
  );
}

Widget _buildLocationCard() {
  return Card(
    elevation: 1,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.location_on, color: Colors.red),
              SizedBox(width: 8),
              Text(
                'Mesh GPS Coordinates',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Coordinates', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  SizedBox(height: 2),
                  Text('28.6139 N, 77.2090 E', style: TextStyle(fontWeight: FontWeight.bold)),   
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: const Text(
                  'GPS Locked',
                  style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold),                  
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildMedicalIdCard() {
  return Card(
    elevation: 1,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.badge, color: Colors.blue),
              const SizedBox(width: 8),
              const Text(
                'Offline Emergency Medical ID',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20, color: Colors.grey),
                onPressed: (){
                },
              ),
            ],
          ),
          const Divider(height: 16),
          _buildMedicalRow('Name', 'Alex Johnsonh'),
          _buildMedicalRow('Blood Type', '0 Positive (O+)'),
          _buildMedicalRow('Allergies', 'Penicillin'),
          _buildMedicalRow('Emergency Contact', '9682976837'),
        ],
      ),
    ),
  );
}

Widget _buildMedicalRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    ),
  );
}
}