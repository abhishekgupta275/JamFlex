import "dart:convert";
import "package:shared_preferences/shared_preferences.dart";

class StorageService{
  static const String _messageskey = 'jamdlex_messages';
  static const String _peersKey = 'jamflex_peers';

  Future<void> saveMessages (List<Map<String, dynamic>> messages) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_messagesKey, jsonEncode(messages));
  }

  Future<List<Map<String, dynamic>>> loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_messagesKey);
    if (raw == null) return [];
    final decode = jsonDecode(raw) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<void> savePeers(List<Map<String, dynamic>> peers) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_peersKey, jsonEncode(peers));

  }

  Future<List<Map<String, dynamic>>> loadPeers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_peersKey);
    if (raw == null) return[];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>();
  }
  Future<void> clearAll() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_messagesKey);
    await prefs.remove(_peersKey);
  }
}
