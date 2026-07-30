import 'dart:convert';
import 'dart:typed_data';
import 'package:nearby_connections/nearby_connections.dart';

class BluetoothService {
  static const String _serviceId = 'com.jamflex.mesh';
  final Nearby _nearby = Nearby();


final Map<String, String> connectedEndpoints = {};

Function(String endpointId, String name)? onPeerFound;
Function(String endpointId)? onPeerLost;
Function(String endpointId, String name)? onPeerConnected;
Function(String endpointId)? onPeerDisconnected;
Function(String endpointId, String message)? onMessageReceived;

Future <void> startAdvertising(String userName) async{
  await _nearby.startAdvertising(
    userName, 
    Strategy.P2P_CLUSTER,
    onConnectionInitiated: _onConnectionInitiated,
    onConnectionResult: (id, status){
      if (status == Status.CONNECTED){
        onPeerConnected?.call(id, connectedEndpoints[id] ?? id);
      }
    },
    onDisconnected: (id) {
      connectedEndpoints.remove(id);
      onPeerDisconnected?.call(id);
    },
    serviceId: _serviceId,
  );
}

Future<void> startDiscovery(String userName) async{
  await _nearby.startDiscovery(
    userName,
    Strategy.P2P_CLUSTER,

    onEndpointFound: (id, name, serviceId) {
      onPeerFound?.call(id, name);
    },
    
    onEndpointLost: (String? id) {
      if (id != null){
      onPeerLost?.call(id);
    }
  },
    serviceId: _serviceId,
  );
}

Future<void> connectToPeer(String endpointId, String userName) async {
  await _nearby.requestConnection(
    userName,
    endpointId,
    onConnectionInitiated: _onConnectionInitiated,
    onConnectionResult: (id, status) {
      if (status == Status.CONNECTED) {
        onPeerConnected?.call(id, connectedEndpoints[id] ?? id);
      }
    },
    onDisconnected: (id){
       connectedEndpoints.remove(id);
       onPeerDisconnected?.call(id);
    },
  );
}

void _onConnectionInitiated(String id, ConnectionInfo info){
  connectedEndpoints[id] = info.endpointName;
  _nearby.acceptConnection(
    id,
    onPayLoadRecieved: (endpointId, payload) {
      if (payload.type == PayloadType.BYTES) {
        final message = utf8.decode(payload.bytes as Uint8List);
        onMessageReceived?.call(endpointId, message);
      }
    },
  );
}

Future<void> sendMessage(String endpointId, String message) async {
  await _nearby.sendBytesPayload(
    endpointId,
    Uint8List.fromList(utf8.encode(message)),
  );
}

Future<void> stopAll() async{
  await _nearby.stopAdvertising();
  await _nearby.stopDiscovery();
  await _nearby.stopAllEndpoints();
}
}