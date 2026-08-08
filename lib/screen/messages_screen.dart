import 'package:flutter/material.dart';
import '../services/mesh_service.dart';

class MessagesScreen extends StatefulWidget{
  final MeshService meshService;

  const MessagesScreen({super.key, required this.meshService});


  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
 }

 class _MessagesScreenState extends State<MessagesScreen> {

  int _selectedCategory = 0;
  final List<Map<String, dynamic>> _contacts = [
    {
      'name': 'Alex (Galaxy S21)',
      'id': 'peer_001',
      'deviceDetails': 'BT Mesh. Signal: Strong (-55dBm)',
      'isKnown': true,
      'lastMessage': 'Hey, are you on the mesh network?', 
    },
  ];
 
 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('JamFlex Messages'),
      centerTitle: true,
    ),
    body: Column(
      children: [
        const SizedBox(height: 12),

        _buildToggleButtons(),
        const SizedBox(height: 12),
        const Divider(height: 1),

        Expanded(
          child: _buildContactList(),
        ),
      ],
    ),
  );
}

Widget _buildToggleButtons() { 
  return ToggleButtons(
    isSelected: [_selectedCategory == 0, _selectedCategory == 1],
    onPressed: (index) {
      setState(() {
        _selectedCategory = index;
      });
    },
    borderRadius: BorderRadius.circular(20),
    selectedColor: Colors.white,
    fillColor: _selectedCategory == 0 ? _selectedCategory == 1 ? Colors.blue : Colors.orange,
    constraints: const BoxConstraints(minWidth: 140, minHeight: 40),\
    children: const [
      Row(
        children: [
          Icon(Icons.lock_outline, size: 18),
          SizedBox(width: 6),
          Text('Private', style: TextStyle(fontWeight: fontWeight.bold)),
        ],
      ),
      Row(
        children: [
          Icon(Icons.public, size: 18),
          SizedBox(width: 6),
          Text('Private', style: TextStyle(fontWeight: FontWeight.bold)),

        ],
      ),
    ],
  );
}

Widget _buildCoontactList() {
  
  final filteredContacts = _contacts.where((contact) {
    if (_selectedCategory == 0) {
      return contact['isKnown'] == true;
    } else {
      return contact['isKnown'] == false;
    }
  });.toList();

if(filteredContacts.isEmpty) {
  return Center(
    child: Text(
       _selectedCategory == 0 
       ? 'No known contacts found.'
       : 'No unknown contacts found.'
    )
  );
}

return ListView.separated(
  padding: const EdgeInsets.symmetric(vertical: 8),
  itemCount: filteredContacts.length,
  seperatorBuilder: (context, index) => const Divider(height: 1),
  itemBuilder: (context, index) {

    final contact = filteredContacts[index];
    
)
