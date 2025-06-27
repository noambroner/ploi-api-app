import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PloiApiService {
  static const String baseUrl = 'https://ploi.io/api';
  static const String version = '1.0';
  
  String? _apiToken;
  
  // Singleton pattern
  static final PloiApiService _instance = PloiApiService._internal();
  factory PloiApiService() => _instance;
  PloiApiService._internal();
  
  // Initialize and load saved API token
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _apiToken = prefs.getString('ploi_api_token');
  }
  
  // Save API token
  Future<void> setApiToken(String token) async {
    _apiToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ploi_api_token', token);
  }
  
  // Get API token
  String? get apiToken => _apiToken;
  
  // Check if API token is configured
  bool get isConfigured => _apiToken != null && _apiToken!.isNotEmpty;
  
  // Build headers for API requests
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $_apiToken',
  };
  
  // Generic GET request
  Future<Map<String, dynamic>> _get(String endpoint) async {
    if (!isConfigured) {
      throw Exception('API Token לא מוגדר. אנא הגדר את ה-Token בהגדרות.');
    }
    
    final uri = Uri.parse('$baseUrl/$endpoint');
    
    try {
      final response = await http.get(uri, headers: _headers);
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('API Token לא תקף. אנא בדוק את ה-Token בהגדרות.');
      } else {
        final errorData = json.decode(response.body);
        throw Exception('API Error ${response.statusCode}: ${errorData['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      rethrow;
    }
  }
  
  // Generic POST request
  Future<Map<String, dynamic>> _post(String endpoint, Map<String, dynamic> data) async {
    if (!isConfigured) {
      throw Exception('API Token לא מוגדר. אנא הגדר את ה-Token בהגדרות.');
    }
    
    final uri = Uri.parse('$baseUrl/$endpoint');
    
    try {
      final response = await http.post(
        uri,
        headers: _headers,
        body: json.encode(data),
      );
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('API Token לא תקף. אנא בדוק את ה-Token בהגדרות.');
      } else {
        final errorData = json.decode(response.body);
        throw Exception('API Error ${response.statusCode}: ${errorData['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      rethrow;
    }
  }
  
  // Test API connection
  Future<Map<String, dynamic>> testConnection() async {
    return await _get('user');
  }
  
  // Get all servers
  Future<List<Map<String, dynamic>>> getServers() async {
    final response = await _get('servers');
    return List<Map<String, dynamic>>.from(response['data'] ?? []);
  }
  
  // Get server details
  Future<Map<String, dynamic>> getServer(int serverId) async {
    return await _get('servers/$serverId');
  }
  
  // Get sites for a server
  Future<List<Map<String, dynamic>>> getSites(int serverId) async {
    final response = await _get('servers/$serverId/sites');
    return List<Map<String, dynamic>>.from(response['data'] ?? []);
  }
  
  // Get site details
  Future<Map<String, dynamic>> getSite(int serverId, int siteId) async {
    return await _get('servers/$serverId/sites/$siteId');
  }
  
  // Get SSL certificates for a site
  Future<List<Map<String, dynamic>>> getSSLCertificates(int serverId, int siteId) async {
    final response = await _get('servers/$serverId/sites/$siteId/certificates');
    return List<Map<String, dynamic>>.from(response['data'] ?? []);
  }
  
  // Install SSL certificate
  Future<Map<String, dynamic>> installSSLCertificate({
    required int serverId,
    required int siteId,
    required String type, // 'letsencrypt' or 'custom'
    required List<String> domains,
    String? certificate,
    String? privateKey,
    String? chain,
  }) async {
    final data = <String, dynamic>{
      'type': type,
      'domains': domains,
    };
    
    if (type == 'custom') {
      if (certificate != null) data['certificate'] = certificate;
      if (privateKey != null) data['private_key'] = privateKey;
      if (chain != null) data['chain'] = chain;
    }
    
    return await _post('servers/$serverId/sites/$siteId/certificates', data);
  }
  
  // Get cronjobs for a site
  Future<List<Map<String, dynamic>>> getCronjobs(int serverId, int siteId) async {
    final response = await _get('servers/$serverId/sites/$siteId/cronjobs');
    return List<Map<String, dynamic>>.from(response['data'] ?? []);
  }
  
  // Create cronjob
  Future<Map<String, dynamic>> createCronjob({
    required int serverId,
    required int siteId,
    required String command,
    required String frequency,
    String? user,
  }) async {
    final data = {
      'command': command,
      'frequency': frequency,
      'user': user ?? 'ploi',
    };
    
    return await _post('servers/$serverId/sites/$siteId/cronjobs', data);
  }
  
  // Delete cronjob
  Future<void> deleteCronjob(int serverId, int siteId, int cronjobId) async {
    final uri = Uri.parse('$baseUrl/servers/$serverId/sites/$siteId/cronjobs/$cronjobId');
    
    try {
      final response = await http.delete(uri, headers: _headers);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return;
      } else {
        final errorData = json.decode(response.body);
        throw Exception('API Error ${response.statusCode}: ${errorData['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      rethrow;
    }
  }
  
  // Deploy site from Git
  Future<Map<String, dynamic>> deploySite(int serverId, int siteId) async {
    return await _post('servers/$serverId/sites/$siteId/deploy', {});
  }
  
  // Get deployment history
  Future<List<Map<String, dynamic>>> getDeployments(int serverId, int siteId) async {
    final response = await _get('servers/$serverId/sites/$siteId/deployments');
    return List<Map<String, dynamic>>.from(response['data'] ?? []);
  }
} 