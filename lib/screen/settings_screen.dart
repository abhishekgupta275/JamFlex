import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '..theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>{
  bool _darkMode = false;
  bool _bluetoothAutoConnect = false;
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Switch between light and dark themes'),
            value: _darkMode,
            onChanged: (value) {
              setState(() {
                _darkMode = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Bluetooth Auto-Connect'),
            subtitle: const Text('Automatically connect to nearby peers'),
            value: _bluetoothAutoConnect,
            onChanged: (bool value) {
              setState(() {
                _bluetoothAutoConnect = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Notifications'),
            subtitle: const Text('Get notified about new messages and peers')
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          const Divider();
          ListTile(
            leading: const Icon(Icons_info_outline),
            title: const Text('About: JamFlex'),
            subtitle: const Text('Version 1.0.0')
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'JamFlex',
                applicationVersion: '1.0.0',

              );
            },
          ),
        ],
      ),
    );  
  }
}