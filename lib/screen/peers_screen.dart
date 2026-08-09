import 'package:flutter/material.dart';
import '../services/mesh_service.dart';

class PeersScreen extends StatefulWidget {
  final MeshService meshService;

  const PeersScreen({super.key, required this.meshService});

  @override
  State<PeersScreen> createState() => _PeersScreenState();
}

class _PeersScreenState extends State<PeersScreen> with SingleTickerProviderStateMixin{
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState(){
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showDeviceDetails(BuildContext context, String id, String name) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blue.shade100,
                    child: const Icon(Icons.phone_android, color: Colors.blue),        
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Node ID: $id', style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              _buildDetailRow(Icons.wifi_tethering, 'Transport Protocol', 'Wi-Fi Direct / BLE Mesh '),
              _buildDetailRow(Icons.network_ping, 'Signal Strength', 'Strong (-58dBm)'),
              _buildDetailRow(Icons.battery_5_bar, 'Peer Battery Level', '84%'),
              _buildDetailRow(Icons.route, 'Hop Distance', 'Direct Connection (1 Hop)'),
              const SizedBox(height:20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.chat, color: Colors.white),
                  label: const Text('START DIRECT CHAT', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: Colors.grey)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final livePeers = widget.meshService.peers;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peer Directory'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const[
            Tab(text: 'Discovered Peers'),
            Tab(text: 'Saved Nodes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          
          Column(
            children: [
          _buildSearchBar(),
          Expanded(
            child: livePeers.isEmpty
            ? _buildEmptyState('No active mesh devices found nearby')
            : _buildPeerList(livePeers),
          ),
        ],
      ),
    

      Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _buildEmptyState('No saved node in your directory yet'),
            ),
          ],
        ),
      ], 
    ),
  );
}

Widget _buildSearchBar() {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: TextField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {
          _searchQuery = value.toLowerCase();
        });
      },
      decoration: InputDecoration(
        hintText: 'search by device name or ID...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchQuery.isNotEmpty
        ? IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            setState(() {
              _searchController.clear();
              _searchQuery = '';
            });
          },
        )
        : null,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}

Widget _buildPeerList(Map<String, String>peers) {
  final filteredKeys = peers.keys.where((id) {
    final name = peers[id]?.toLowerCase() ?? '';
    return name.contains(_searchQuery) || id.toLowerCase().contains(_searchQuery);
  }).toList();

  if (filteredKeys.isEmpty) {
    return _buildEmptyState('No matching peers found');
  }

  return ListView.separated(
    padding: const EdgeInsets.all(12),
    itemCount: filteredKeys.length,
    separatorBuilder: (context, index) => const SizedBox(height: 8),
    itemBuilder: (context, index) {
      final id = filteredKeys[index];
      final name = peers[id] ?? 'Unknown Device';
      
      return Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          onTap: () => _showDeviceDetails(context, id, name),
          leading: CircleAvatar(
            backgroundColor: Colors.blue.shade50,
            child: const Icon(Icons.phonelink_ring, color: Colors.blue),
          ),
          title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Row(
            children: [
              const Icon(Icons.bluetooth, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text('ID: $id', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          trailing: const Icon(Icons.info_outline, color: Colors.grey),
        ),
      );  
    },    
  );
}

Widget _buildEmptyState(String message) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.devices, size: 64, color: Colors.grey.shade300),
        const SizedBox(height: 12),
        Text(message, style: const TextStyle(color: Colors.grey, fontSize:14)),
       ],
      ),
    );
  }
}