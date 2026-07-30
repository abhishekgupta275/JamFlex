import 'dart:convert';
import 'dart:math';
import 'bluetooth_service.dart';
import 'storage_service.dart';

class MeshService {
  final BluetoothService _bluetooth = BluetoothService();
  final StorageService _storage = StorageService();

  final Set<String> _seenMessageIds = {};
  final Map<String, String> peers ={};

  Function(Map<String, dynamic> message)? onMessageReceived;
  Function(String endpointId, String name)? onPeerUpdated;
  Function(String endpointId)? onPeerRemoved;

  Future<void> start(String userName) async {
    _bluetooth.onPeerFound = (id,name) {
      peers[id] = name;
      onPeerUpdated?.call(id, name);
    };
    _bluetooth.onPeerLost = (id) {
      peers.remove(id);
      onPeerRemoved?.call(id);
    };

    _bluetooth.onPeerConnected = (id, name) {
      peers[id] = name;
      onPeerUpdated?.call(id, name);
    };

     _bluetooth.onPeerDisconnected = (id) {
      peers.remove(id);
      onPeerRemoved?.call(id);
    };
    _bluetooth.onMessageReceived = _handleIncoming;

    await _bluetooth.startAdvertising(userName);
    await _bluetooth.startDiscovery(userName);
  }

  void _handleIncoming(String fromEndpointId, String raw) {
    final data = jsonDecode(raw) as Map<String, dynamic>;
    final id = data['id'] as String;

    if (_seenMessageIds.contains(id)) return;
    _seenMessageIds.add(id);

    onMessageReceived?.call(data);
    _storage.saveMessages([data]);

    final ttl = (data['ttl'] as int?) ?? 0;
    if (ttl >0) {
      final relayed = Map<String, dynamic>.from(data);
      relayed['ttl'] = ttl - 1;
      _relay(relayed, exclude: fromEndpointId);
    }
  }

  void _relay(Map<String, dynamic> message, {required String exclude}) {
    final encoded = jsonEncode(message);
    for (final endpointId in peers.keys) {
      if (endpointId != exclude){
        _bluetooth.sendMessage(endpointId, encoded);
      }
    }
  }

  Future<void> sendMessage({
    required String senderName,
    required String content,
    String type ='chat', 
    int ttl = 5,
  }) async {
    final message = {
      'id': _generateId(),
      'senderName': content,
      'type': type,
      'ttl': ttl, 
      'timestamp': DateTime.now().toIso8601String(),
    };
    _seenMessageIds.add(message['id'] as String);
    _relay(message, exclude: '');
  }

  String _generateId(){
    final rand = Random();
    return '${DateTime.now().millisecondsSinceEpoch}-${rand.nextInt(999999)}';
  }

  Future<void> stop() async {
    await _bluetooth.stopAll();
  }
}