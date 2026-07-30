import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'screen/home_screen.dart';
import 'screen/messages_screen.dart';
import 'screen/peers_screen.dart'; 
import 'screen/sos_screen.dart';
import 'services/mesh_service.dart';
import 'screen/settings_screen.dart';

void main() {
  runApp(const JamFlexApp());
}

class JamFlexApp extends StatelessWidget {
  const JamFlexApp ({super.key}); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JamFlex',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const RootNavigation(),
    );
  }
}

class RootNavigation extends StatefulWidget {
  const RootNavigation({super.key});

  @override
  State<RootNavigation> createState() => _RootNavigationState();
}

class _RootNavigationState extends State<RootNavigation> {
  int _selectedIndex = 0;
  final MeshService _meshService = MeshService();
  bool _isStarted = false;

  @override
  void initState() {
    super.initState();
    _startMesh();
  }

  Future<void> _startMesh() async {
    await _meshService.start('User_${DateTime.now().millisecondsSinceEpoch % 1000}');
    setState(() {
      _isStarted = true;
    });
  }

  @override
  void dispose() {
    _meshService.stop();
    super.dispose();
  }

  List<Widget> get _widgetOptions => <Widget>[
    const HomeScreen(),
    PeersScreen(meshService: _meshService),
    MessagesScreen(meshService: _meshService),
    SosScreen(meshService: _meshService),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isStarted){
      return const Scaffold(
        body: Center (child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Peers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'SOS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

