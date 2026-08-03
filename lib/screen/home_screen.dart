import 'package:flutter/material.dart';
class HomeScreen extends StatelessWidget {
   const HomeScreen({super.key});

   void _triggerEmergency(BuildContext context){
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Initiating Emergency Call'),
        content: const Text(
          'Broadcasting emergency call to nearby devices via Bluetooth and  WiFi Direct.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:: const Text('Cancel', stlye: TextStyle(color: Colors.grey)),
            
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: (){
                Navigation.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Broadcasting emergency signal to nearby peers!'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text('CONFIRM CALL', style: TextStyle(color: Colors.white)),
            ),
          ],
      ),
    );
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JamFlex Home'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBadge(Icons.bluetooth, 'Bluetooth Mesh', Colors.blue),
                const SizedBox(width: 12),
                _buildBadge(Icons.wifi_thethering, 'Wi-fi Direct', Colors.lightGreenAccent),
              ],
            ),
            const SizedBox(height: 40),

            GestureDetector(
              onTap: () => _triggerEmergencyCall(context),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.4),
                      blurRadius: 25,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.phone_in_talk,
                      size: 64,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Emergency Call',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ) ,
            ),
          ]
        )
      )
        
}