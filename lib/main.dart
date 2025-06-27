import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:async';

// דוגמה למבנה תרגום בסיסי
const Map<String, Map<String, String>> kTranslations = {
  'en': {
    'dashboard': 'Dashboard',
    'connection_details': 'Connection Details',
    'servers': 'Servers',
    'hello': 'Hello',
    'ploi_connection_details': 'Ploi Connection Details',
    'ploi_connection_desc': 'To connect to the Ploi API, enter the following details:',
    'api_token': 'API Token (Personal Access Key)',
    'api_url': 'API URL: https://ploi.io/api/',
    'api_token_hint': 'You can generate the API Token from your Ploi account under Settings > API Tokens.',
    'language': 'Language',
    'hebrew': 'Hebrew',
    'english': 'English',
    'connect': 'Connect',
    'connecting': 'Connecting...',
    'connection_success': 'Connection successful!',
    'connection_error': 'Connection failed. Please check your API token.',
    'connection_failed': 'Failed to connect. Please check your API token.',
    'enter_api_token': 'Enter your API token',
    'save_token': 'Save token for future use',
    'servers_list': 'Servers List',
    'loading_servers': 'Loading servers...',
    'no_servers': 'No servers found',
    'server_status': 'Status',
    'server_name': 'Server Name',
    'server_ip': 'IP Address',
    'retry': 'Retry',
    'error': 'Error',
    'create_server': 'Create Server',
    'select_provider': 'Select provider',
    'cancel': 'Cancel',
    'loading_providers': 'Loading providers...',
    'no_providers': 'No providers found',
    'server_details': 'Server Details',
    'credentials': 'Credentials',
    'name': 'Name',
    'server_os': 'Server OS',
    'ip_version': 'IP version',
    'server_type': 'Server type',
    'select_plan': 'Select plan',
    'server_region': 'Server region',
    'webserver': 'Webserver',
    'php_version': 'PHP version',
    'database': 'Database',
    'install_monitoring': 'Install Ploi Monitoring',
    'loading_options': 'Loading options...',
    'no_options': 'No options found',
    'refresh': 'Refresh',
  },
  'he': {
    'dashboard': 'דאשבורד',
    'connection_details': 'פרטי התחברות',
    'servers': 'שרתים',
    'hello': 'שלום',
    'ploi_connection_details': 'פרטי התחברות ל-Ploi',
    'ploi_connection_desc': 'כדי להתחבר ל-Ploi API יש להזין את הפרטים הבאים:',
    'api_token': 'API Token (מפתח גישה אישי)',
    'api_url': 'כתובת ה-API: https://ploi.io/api/',
    'api_token_hint': 'את ה-API Token ניתן להפיק מחשבון המשתמש שלך באתר Ploi תחת Settings > API Tokens.',
    'language': 'שפה',
    'hebrew': 'עברית',
    'english': 'אנגלית',
    'connect': 'התחבר',
    'connecting': 'מתחבר...',
    'connection_success': 'החיבור הצליח!',
    'connection_error': 'החיבור נכשל. אנא בדוק את ה-API Token שלך.',
    'connection_failed': 'ההתחברות נכשלה. אנא בדקו את ה-API Token שלכם.',
    'enter_api_token': 'הזן את ה-API Token שלך',
    'save_token': 'שמור טוקן לשימוש עתידי',
    'servers_list': 'רשימת שרתים',
    'loading_servers': 'טוען שרתים...',
    'no_servers': 'לא נמצאו שרתים',
    'server_status': 'סטטוס',
    'server_name': 'שם השרת',
    'server_ip': 'כתובת IP',
    'retry': 'נסה שוב',
    'error': 'שגיאה',
    'create_server': 'יצירת שרת',
    'select_provider': 'בחר ספק',
    'cancel': 'ביטול',
    'loading_providers': 'טוען ספקים...',
    'no_providers': 'לא נמצאו ספקים',
    'server_details': 'פרטי שרת',
    'credentials': 'אישורים',
    'name': 'שם',
    'server_os': 'מערכת הפעלה',
    'ip_version': 'גרסת IP',
    'server_type': 'סוג שרת',
    'select_plan': 'בחר חבילה',
    'server_region': 'אזור שרת',
    'webserver': 'שרת אינטרנט',
    'php_version': 'גרסת PHP',
    'database': 'מסד נתונים',
    'install_monitoring': 'התקן ניטור Ploi',
    'loading_options': 'טוען אפשרויות...',
    'no_options': 'לא נמצאו אפשרויות',
    'refresh': 'רענן',
  },
};

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String tr(String key) {
    return kTranslations[locale.languageCode]?[key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'he'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

// Ploi API Service
class PloiApiService {
  static const String baseUrl = 'https://ploi.io/api';
  
  static Future<List<Map<String, dynamic>>> getServers(String apiToken) async {
    try {
      debugPrint('📡 [PLOI API] Getting servers list...');
      debugPrint('🔗 [PLOI API] URL: $baseUrl/servers');
      
      final response = await http.get(
        Uri.parse('$baseUrl/servers'),
        headers: {
          'Authorization': 'Bearer $apiToken',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('📡 [PLOI API] Response status: ${response.statusCode}');
      debugPrint('📡 [PLOI API] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final servers = List<Map<String, dynamic>>.from(data['data'] ?? []);
        debugPrint('✅ [PLOI API] Successfully retrieved ${servers.length} servers');
        return servers;
      } else {
        debugPrint('❌ [PLOI API] Failed to load servers: ${response.statusCode}');
        throw Exception('Failed to load servers: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('💥 [PLOI API] Error connecting to Ploi API: $e');
      throw Exception('Error connecting to Ploi API: $e');
    }
  }
  
  static Future<bool> testConnection(String apiToken) async {
    try {
      debugPrint('🔍 [PLOI API] Testing connection with API token...');
      
      // Validate API token format
      if (apiToken.trim().isEmpty) {
        debugPrint('❌ [PLOI API] API token is empty');
        return false;
      }
      
      final headers = {
        'Authorization': 'Bearer ${apiToken.trim()}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'PloiApiApp/1.1.0 (Flutter)',
      };
      
      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: headers,
      );

      debugPrint('🔍 [PLOI API] Test connection response: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        debugPrint('✅ [PLOI API] Connection test successful');
        return true;
      } else if (response.statusCode == 401) {
        debugPrint('🔐 [PLOI API] Authentication failed - invalid API token');
        return false;
      } else if (response.statusCode == 302) {
        debugPrint('🔄 [PLOI API] Connection test redirected - possible authentication issue');
        return false;
      } else {
        debugPrint('❌ [PLOI API] Connection test failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('💥 [PLOI API] Connection test error: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getServerProviders(String apiToken) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/server-providers'),
        headers: {
          'Authorization': 'Bearer $apiToken',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      } else {
        throw Exception('Failed to load providers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to Ploi API: $e');
    }
  }

  static Future<Map<String, dynamic>> getProviderDetails(String apiToken, int providerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/server-providers/$providerId'),
        headers: {
          'Authorization': 'Bearer $apiToken',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'] ?? {};
      } else {
        throw Exception('Failed to load provider details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to Ploi API: $e');
    }
  }

  static Future<Map<String, dynamic>> createServer(String apiToken, Map<String, dynamic> params) async {
    try {
      debugPrint('🚀 [PLOI API] Creating server with params: $params');
      
      // Validate API token format
      if (apiToken.trim().isEmpty) {
        throw Exception('API token is empty');
      }
      
      // Prepare headers with proper authentication and content type
      final headers = {
        'Authorization': 'Bearer ${apiToken.trim()}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'PloiApiApp/1.1.0 (Flutter)',
      };
      
      debugPrint('🔗 [PLOI API] Request URL: $baseUrl/servers');
      debugPrint('🔑 [PLOI API] Headers: ${headers.keys.join(', ')}');
      
      final response = await http.post(
        Uri.parse('$baseUrl/servers'),
        headers: headers,
        body: json.encode(params),
      );
      
      debugPrint('📡 [PLOI API] Response status: ${response.statusCode}');
      debugPrint('📡 [PLOI API] Response headers: ${response.headers}');
      debugPrint('📡 [PLOI API] Response body: ${response.body}');
      
      // Check for successful responses
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('✅ [PLOI API] Server created successfully: ${data['data']?['id']}');
        return data['data'] ?? {};
      } 
      // Handle authentication errors specifically
      else if (response.statusCode == 401) {
        final errorMsg = 'Authentication failed. Please check your API token.';
        debugPrint('🔐 [PLOI API] $errorMsg');
        await _logErrorToFile(errorMsg, params);
        throw Exception(errorMsg);
      }
      // Handle 302 redirects specifically
      else if (response.statusCode == 302) {
        final location = response.headers['location'] ?? 'unknown';
        final errorMsg = 'API request was redirected to: $location. This usually indicates an authentication issue or invalid API endpoint.';
        debugPrint('🔄 [PLOI API] $errorMsg');
        await _logErrorToFile(errorMsg, params);
        throw Exception(errorMsg);
      }
      // Handle other errors
      else {
        final errorMsg = 'Failed to create server: ${response.statusCode} - ${response.body}';
        debugPrint('❌ [PLOI API] $errorMsg');
        await _logErrorToFile(errorMsg, params);
        throw Exception(errorMsg);
      }
    } catch (e) {
      final errorMsg = 'Error creating server: $e';
      debugPrint('💥 [PLOI API] $errorMsg');
      await _logErrorToFile(errorMsg, params);
      throw Exception(errorMsg);
    }
  }

  static Future<List<Map<String, dynamic>>> getSites(String apiToken, int serverId) async {
    try {
      debugPrint('📡 [PLOI API] Getting sites for server $serverId...');
      debugPrint('🔗 [PLOI API] URL: $baseUrl/servers/$serverId/sites');
      
      final response = await http.get(
        Uri.parse('$baseUrl/servers/$serverId/sites'),
        headers: {
          'Authorization': 'Bearer $apiToken',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('📡 [PLOI API] Response status: ${response.statusCode}');
      debugPrint('📡 [PLOI API] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final sites = List<Map<String, dynamic>>.from(data['data'] ?? []);
        debugPrint('✅ [PLOI API] Successfully retrieved ${sites.length} sites');
        return sites;
      } else {
        debugPrint('❌ [PLOI API] Failed to load sites: ${response.statusCode}');
        throw Exception('Failed to load sites: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('💥 [PLOI API] Error getting sites: $e');
      throw Exception('Error getting sites: $e');
    }
  }

  static Future<void> _logErrorToFile(String error, Map<String, dynamic> params, [StackTrace? stack]) async {
    await logError('$error\nPARAMS: ${params.toString()}', stack);
  }
}

void main() {
  runZonedGuarded(() async {
    FlutterError.onError = (FlutterErrorDetails details) async {
      await logError(details.exceptionAsString(), details.stack);
      FlutterError.dumpErrorToConsole(details);
    };
  runApp(const PloiApiApp());
  }, (error, stack) async {
    await logError(error.toString(), stack);
  });
}

Future<void> logError(String error, StackTrace? stack) async {
  // Only log to file on desktop (not web)
  if (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS) return;
  final now = DateTime.now().toUtc();
  final log = '''
[${now.toIso8601String()} UTC]
Type: Error
Message: $error
Stack: ${stack ?? ''}
---
''';
  final dir = Directory('dev_log');
  if (!await dir.exists()) {
    await dir.create(recursive: true);
  }
  final file = File('dev_log/bug_log.txt');
  await file.writeAsString(log, mode: FileMode.append, flush: true);
}

class PloiApiApp extends StatefulWidget {
  const PloiApiApp({super.key});

  @override
  State<PloiApiApp> createState() => _PloiApiAppState();
}

class _PloiApiAppState extends State<PloiApiApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ploi API App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('he'),
      ],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) return supportedLocales.first;
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      home: MainDashboard(onLocaleChanged: setLocale, locale: _locale),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainDashboard extends StatefulWidget {
  final void Function(Locale) onLocaleChanged;
  final Locale? locale;
  const MainDashboard({super.key, required this.onLocaleChanged, this.locale});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _selectedIndex = 0;
  bool _isConnected = false;

  void _onConnectionSuccess() {
    setState(() {
      _isConnected = true;
      _selectedIndex = 2; // Go to Servers page
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isRtl = (widget.locale?.languageCode ?? PlatformDispatcher.instance.locale.languageCode) == 'he';
    final List<Widget> pages = <Widget>[
      Center(child: Text('${loc.tr('hello')} 👋', style: const TextStyle(fontSize: 32))),
      ConnectionDetailsPage(onConnectionSuccess: _onConnectionSuccess),
      ServersPage(),
    ];
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Ploi API Dashboard v1.2.13'),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Locale>(
                  value: widget.locale ?? const Locale('he'),
                  icon: const Icon(Icons.language),
                  items: const [
                    DropdownMenuItem(
                      value: Locale('he'),
                      child: Text('עברית'),
                    ),
                    DropdownMenuItem(
                      value: Locale('en'),
                      child: Text('English'),
                    ),
                  ],
                  onChanged: (Locale? newLocale) {
                    if (newLocale != null) {
                      widget.onLocaleChanged(newLocale);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              destinations: [
                NavigationRailDestination(
                  icon: const Icon(Icons.dashboard),
                  label: Text(loc.tr('dashboard')),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.vpn_key),
                  label: Text(loc.tr('connection_details')),
                ),
                NavigationRailDestination(
                  icon: Icon(
                    Icons.dns,
                    color: _isConnected ? null : Colors.grey,
                  ),
                  label: Text(
                    loc.tr('servers'),
                    style: TextStyle(
                      color: _isConnected ? null : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            // Main content
            Expanded(child: pages[_selectedIndex]),
          ],
        ),
      ),
    );
  }
}

class ConnectionDetailsPage extends StatefulWidget {
  final VoidCallback onConnectionSuccess;
  const ConnectionDetailsPage({super.key, required this.onConnectionSuccess});

  @override
  State<ConnectionDetailsPage> createState() => _ConnectionDetailsPageState();
}

class _ConnectionDetailsPageState extends State<ConnectionDetailsPage> {
  final TextEditingController _tokenController = TextEditingController();
  bool _isConnecting = false;
  bool _saveToken = true;
  String? _connectionStatus;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _loadSavedToken();
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('ploi_api_token');
    if (savedToken != null) {
      setState(() {
        _tokenController.text = savedToken;
      });
    }
  }

  Future<void> _connectToPloi() async {
    if (_tokenController.text.trim().isEmpty) {
      setState(() {
        _connectionStatus = 'Please enter an API token';
        _isSuccess = false;
      });
      return;
    }

    setState(() {
      _isConnecting = true;
      _connectionStatus = null;
    });

    try {
      debugPrint('🔍 [CONNECTION] Testing API token: ${_tokenController.text.trim().substring(0, 10)}...');
      
      // Test actual connection to Ploi API
      final success = await PloiApiService.testConnection(_tokenController.text.trim());
      
      if (success) {
        if (_saveToken) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('ploi_api_token', _tokenController.text.trim());
        }
        
        setState(() {
          _connectionStatus = AppLocalizations.of(context).tr('connection_success');
          _isSuccess = true;
        });
        
        // Call the success callback after a short delay
        Future.delayed(const Duration(seconds: 1), () {
          widget.onConnectionSuccess();
        });
      } else {
        setState(() {
          _connectionStatus = 'Connection failed. Please check your API token and ensure it has the correct permissions.';
          _isSuccess = false;
        });
      }
    } catch (e) {
      debugPrint('💥 [CONNECTION] Error during connection test: $e');
      setState(() {
        _connectionStatus = 'Connection error: ${e.toString()}';
        _isSuccess = false;
      });
    } finally {
      setState(() {
        _isConnecting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(loc.tr('ploi_connection_details'), 
               style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Text(loc.tr('ploi_connection_desc'), 
               style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 32),
          
          // API Token Input
          Text(loc.tr('api_token'), 
               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _tokenController,
            decoration: InputDecoration(
              hintText: loc.tr('enter_api_token'),
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.vpn_key),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 16),
          
          // Save Token Checkbox
          Row(
            children: [
              Checkbox(
                value: _saveToken,
                onChanged: (value) {
                  setState(() {
                    _saveToken = value ?? true;
                  });
                },
              ),
              Text(loc.tr('save_token')),
            ],
          ),
          const SizedBox(height: 24),
          
          // Connect Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isConnecting ? null : _connectToPloi,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isConnecting
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 12),
                        Text(loc.tr('connecting')),
                      ],
                    )
                  : Text(loc.tr('connect')),
            ),
          ),
          const SizedBox(height: 24),
          
          // Connection Status
          if (_connectionStatus != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isSuccess ? Colors.green.shade50 : Colors.red.shade50,
                border: Border.all(
                  color: _isSuccess ? Colors.green : Colors.red,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    _isSuccess ? Icons.check_circle : Icons.error,
                    color: _isSuccess ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _connectionStatus!,
                      style: TextStyle(
                        color: _isSuccess ? Colors.green.shade800 : Colors.red.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
          const SizedBox(height: 32),
          
          // API URL Info
          Text(loc.tr('api_url'), 
               style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          Text(loc.tr('api_token_hint'), 
               style: const TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }
}

class ServersPage extends StatefulWidget {
  const ServersPage({super.key});

  @override
  State<ServersPage> createState() => _ServersPageState();
}

class _ServersPageState extends State<ServersPage> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _servers = [];

  @override
  void initState() {
    super.initState();
    _loadServers();
  }

  Future<void> _loadServers() async {
    debugPrint('🔄 [LOAD SERVERS] Starting to load servers...');
    
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('ploi_api_token');
      
      debugPrint('🔑 [LOAD SERVERS] API token found: ${token != null ? 'Yes' : 'No'}');
      
      if (token != null) {
        debugPrint('📡 [LOAD SERVERS] Calling Ploi API to get servers...');
        final serverData = await PloiApiService.getServers(token);
        
        debugPrint('📊 [LOAD SERVERS] Received ${serverData.length} servers from API');
        
        // Transform Ploi API data to our format
        final transformedServers = serverData.map((server) {
          final transformed = {
            'id': server['id'],
            'name': server['name'] ?? 'Unknown Server',
            'ip': server['ip_address'] ?? 'N/A',
            'status': (server['status'] == 'active' || server['status'] == 'running') ? 'active' : 'inactive',
          };
          debugPrint('   - Server: ${transformed['name']} (ID: ${transformed['id']}, Status: ${transformed['status']})');
          return transformed;
        }).toList();

        debugPrint('✅ [LOAD SERVERS] Successfully transformed ${transformedServers.length} servers');

        if (mounted) {
          setState(() {
            _servers = transformedServers;
            _isLoading = false;
          });
        }
      } else {
        debugPrint('❌ [LOAD SERVERS] No API token found');
        // No token found - shouldn't happen but handle gracefully
        if (mounted) {
          setState(() {
            _servers = [];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('💥 [LOAD SERVERS] Error loading servers: $e');
      // If API fails, show error but keep UI functional
      if (mounted) {
        setState(() {
          _servers = [];
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load servers: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isRtl ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: Text(loc.tr('create_server')),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  await logError('🎯 [CREATE SERVER BUTTON] Button clicked!', null);
                  if (context.mounted) {
                    showCreateServerDialog(context);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            loc.tr('servers_list'),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: isRtl ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              IconButton(
                icon: _isLoading
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.refresh),
                tooltip: loc.tr('refresh'),
                onPressed: _isLoading ? null : _loadServers,
              ),
            ],
          ),
          
          if (_isLoading)
            Center(
              child: Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(loc.tr('loading_servers')),
                ],
              ),
            )
          else if (_servers.isEmpty)
            Center(
              child: Text(
                loc.tr('no_servers'),
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _servers.length,
                itemBuilder: (context, index) {
                  final server = _servers[index];
                  final isActive = server['status'] == 'active';
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      leading: Icon(
                        Icons.dns,
                        color: isActive ? Colors.green : Colors.red,
                        size: 32,
                      ),
                      title: Text(
                        server['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('${loc.tr('server_ip')}: ${server['ip']}'),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text('${loc.tr('server_status')}: '),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: isActive ? Colors.green : Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  isActive ? 'Active' : 'Inactive',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServerManagementPage(
                              server: server,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

Future<void> showCreateServerDialog(BuildContext context) async {
  await logError('🚪 [SHOW DIALOG] Opening create server dialog...', null);
  if (!context.mounted) return;
  
  final isRtl = Directionality.of(context) == TextDirection.rtl;
  await showDialog(
    context: context,
    barrierDismissible: false,
    useSafeArea: true,
    builder: (context) {
      final maxHeight = MediaQuery.of(context).size.height * 0.8;
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight, minWidth: 350),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Directionality(
                textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                child: CreateServerDialog(),
              ),
            ),
          ),
        ),
      );
    },
  );
}

class CreateServerDialog extends StatefulWidget {
  const CreateServerDialog({super.key});
  @override
  State<CreateServerDialog> createState() => _CreateServerDialogState();
}

class _CreateServerDialogState extends State<CreateServerDialog> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _providers = [];
  String? _error;
  Map<String, dynamic>? _providerDetails;
  bool _isLoadingOptions = false;
  String? _optionsError;

  @override
  void initState() {
    super.initState();
    logError('🚀 [CREATE SERVER DIALOG] Dialog opened, fetching providers...', null);
    _fetchProviders();
  }

  Future<void> _fetchProviders() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('ploi_api_token');
      if (token == null) {
        setState(() {
          _error = 'No API token found';
          _isLoading = false;
        });
        return;
      }
      final providers = await PloiApiService.getServerProviders(token);
      setState(() {
        _providers = providers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onProviderTap(Map<String, dynamic> provider) async {
    await logError('🔍 [PROVIDER] Selected provider data: $provider', null);
    
    // Extract the provider details directly from the provider data
    final providerInfo = provider['provider'] ?? {};
    final plans = List<Map<String, dynamic>>.from(providerInfo['plans'] ?? []);
    final regions = List<Map<String, dynamic>>.from(providerInfo['regions'] ?? []);
    
    await logError('📋 [PROVIDER] Found ${plans.length} plans and ${regions.length} regions in provider data', null);
    
    // Create provider details with the data we already have
    final providerDetails = {
      'id': provider['id'],
      'name': provider['name'],
      'label': provider['label'],
      'plans': plans,
      'regions': regions,
    };
    
    await logError('✅ [PROVIDER] Using provider details: ${providerDetails.keys}', null);
    
    setState(() {
      _providerDetails = providerDetails;
      _isLoadingOptions = false;
      _optionsError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(loc.tr('create_server'), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(loc.tr('cancel')),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(loc.tr('select_provider'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              if (_isLoading)
                Center(child: Row(children: [const CircularProgressIndicator(), const SizedBox(width: 12), Text(loc.tr('loading_providers'))]))
              else if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red))
              else if (_providers.isEmpty)
                Text(loc.tr('no_providers'), style: const TextStyle(color: Colors.grey))
              else
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: _providers.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.5,
                  ),
                  itemBuilder: (context, index) {
                    final provider = _providers[index];
                    return Opacity(
                      opacity: 1.0,
                      child: GestureDetector(
                        onTap: () async {
                          await logError('🔗 [PROVIDER TAP] Provider tapped: ${provider['name']} (ID: ${provider['id']})', null);
                          if (mounted) {
                            _onProviderTap(provider);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.blue.shade50,
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.cloud, size: 36, color: Colors.blue),
                                const SizedBox(height: 8),
                                Text(provider['name'] ?? 'Unknown',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              if (_isLoadingOptions)
                Row(children: [const CircularProgressIndicator(), const SizedBox(width: 12), Text(loc.tr('loading_options'))]),
              if (_optionsError != null)
                Text(_optionsError!, style: const TextStyle(color: Colors.red)),
              if (_providerDetails != null)
                _ServerOptionsForm(providerDetails: _providerDetails!),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServerOptionsForm extends StatefulWidget {
  final Map<String, dynamic> providerDetails;
  const _ServerOptionsForm({required this.providerDetails});

  @override
  State<_ServerOptionsForm> createState() => _ServerOptionsFormState();
}

class _ServerOptionsFormState extends State<_ServerOptionsForm> {
  String? _selectedPlan;
  String? _selectedRegion;
  String? _selectedOs = 'ubuntu-24-04-lts';
  String? _selectedIpVersion = 'ipv4';
  String? _selectedServerType = 'server';
  String? _selectedWebserver = 'nginx';
  String? _selectedPhpVersion = '8.4';
  String? _selectedDatabase = 'mysql';
  bool _installMonitoring = false;
  final TextEditingController _nameController = TextEditingController();
  
  List<Map<String, dynamic>> _plans = [];
  List<Map<String, dynamic>> _regions = [];
  bool _isLoadingPlans = true;
  bool _isLoadingRegions = true;

  @override
  void initState() {
    super.initState();
    logError('🚀 [INIT STATE] _ServerOptionsFormState initState called', null);
    _loadPlansAndRegions();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadPlansAndRegions() async {
    await logError('🔄 [LOAD PLANS/REGIONS] Starting to load plans and regions...', null);
    await logError('🔍 [LOAD PLANS/REGIONS] Provider details: ${widget.providerDetails}', null);
    
    // Extract plans and regions from provider details
    final plansList = List<Map<String, dynamic>>.from(widget.providerDetails['plans'] ?? []);
    final regionsList = List<Map<String, dynamic>>.from(widget.providerDetails['regions'] ?? []);
    
    await logError('✅ [LOAD PLANS/REGIONS] Found ${plansList.length} plans and ${regionsList.length} regions', null);
    
    setState(() {
      _plans = plansList;
      _regions = regionsList;
      _isLoadingPlans = false;
      _isLoadingRegions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    logError('🎨 [BUILD] _ServerOptionsFormState build - Plans: ${_plans.length}, Regions: ${_regions.length}, LoadingPlans: $_isLoadingPlans, LoadingRegions: $_isLoadingRegions', null);
    final loc = AppLocalizations.of(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final osOptions = [
      {'id': 'ubuntu-24-04-lts', 'name': 'Ubuntu 24.04 LTS'},
      {'id': 'ubuntu-22-04-lts', 'name': 'Ubuntu 22.04 LTS'},
    ];
    final ipVersions = [
      {'id': 'ipv4', 'name': 'IPv4 (default)'},
      {'id': 'ipv6', 'name': 'IPv6'},
    ];
    final serverTypes = [
      {'id': 'server', 'name': 'Server'},
      {'id': 'load-balancer', 'name': 'Load Balancer'},
      {'id': 'database-server', 'name': 'Database Server'},
      {'id': 'redis-server', 'name': 'Redis Server'},
    ];
    final webservers = [
      {'id': 'nginx', 'name': 'NGINX'},
      {'id': 'nginx-docker', 'name': 'NGINX Docker'},
    ];
    final phpVersions = [
      '7.0','7.1','7.2','7.3','7.4','8.0','8.1','8.2','8.3','8.4',
      'none',
    ];
    final databases = [
      {'id': 'none', 'name': 'None (do not install a database)'},
      {'id': 'mysql', 'name': 'MySQL 8'},
      {'id': 'mariadb', 'name': 'MariaDB'},
      {'id': 'postgresql', 'name': 'PostgreSQL'},
      {'id': 'postgresql13', 'name': 'PostgreSQL 13'},
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              loc.tr('server_details'), 
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: isRtl ? TextAlign.right : TextAlign.left,
            ),
            const SizedBox(height: 24),
            
            // Credentials (label only)
            Align(
              alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.tr('credentials'), 
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: isRtl ? TextAlign.right : TextAlign.left,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.providerDetails['name'] ?? '', 
                    style: const TextStyle(fontSize: 16),
                    textAlign: isRtl ? TextAlign.right : TextAlign.left,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Name
            Align(
              alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.tr('name'), 
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: isRtl ? TextAlign.right : TextAlign.left,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'e.g. harmonious-leaf',
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    textAlign: isRtl ? TextAlign.right : TextAlign.left,
                    textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Server OS
            _buildDropdownField(
              label: loc.tr('server_os'),
              value: _selectedOs,
              items: osOptions.map((os) => DropdownMenuItem(
                value: os['id'],
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    os['name']!,
                    textAlign: TextAlign.left,
                  ),
                ),
              )).toList(),
              onChanged: (value) => setState(() => _selectedOs = value),
              isRtl: isRtl,
            ),
            const SizedBox(height: 20),
            
            // IP version
            _buildDropdownField(
              label: loc.tr('ip_version'),
              value: _selectedIpVersion,
              items: ipVersions.map((ip) => DropdownMenuItem(
                value: ip['id'],
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    ip['name']!,
                    textAlign: TextAlign.left,
                  ),
                ),
              )).toList(),
              onChanged: (value) => setState(() => _selectedIpVersion = value),
              isRtl: isRtl,
            ),
            const SizedBox(height: 20),
            
            // Server type
            _buildDropdownField(
              label: loc.tr('server_type'),
              value: _selectedServerType,
              items: serverTypes.map((type) => DropdownMenuItem(
                value: type['id'],
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    type['name']!,
                    textAlign: TextAlign.left,
                  ),
                ),
              )).toList(),
              onChanged: (value) => setState(() => _selectedServerType = value),
              isRtl: isRtl,
            ),
            const SizedBox(height: 20),
            
            // Plan
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.tr('select_plan'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 8),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: DropdownButtonFormField<String>(
                      value: _selectedPlan,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: _isLoadingPlans 
                        ? [DropdownMenuItem(value: null, child: Text('Loading plans...'))]
                        : _plans.map<DropdownMenuItem<String>>((plan) =>
                            DropdownMenuItem(
                              value: plan['id'],
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        plan['id'] ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.left,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (plan['description'] != null) ...[
                                        const SizedBox(height: 4),
                                    Text(
                                      _removePlanIdFromDescription(plan['description'], plan['id']),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        height: 1.2,
                                      ),
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ).toList(),
                      selectedItemBuilder: (context) => _plans.map<Widget>((plan) =>
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            plan['id'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ).toList(),
                      onChanged: (value) async {
                        await logError('📋 [PLAN DROPDOWN] Plan selected: $value', null);
                        setState(() => _selectedPlan = value);
                      },
                      isExpanded: true,
                      alignment: AlignmentDirectional.centerStart,
                      icon: const Icon(Icons.arrow_drop_down),
                      dropdownColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Region
            _buildDropdownField(
              label: loc.tr('server_region'),
              value: _selectedRegion,
              items: _isLoadingRegions 
                ? [DropdownMenuItem(value: null, child: Text('Loading regions...'))]
                : _regions.map<DropdownMenuItem<String>>((region) => DropdownMenuItem(
                    value: region['id'],
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        region['name'] ?? region['id'],
                        textAlign: TextAlign.left,
                      ),
                    ),
                  )).toList(),
              onChanged: (value) => _isLoadingRegions ? null : (() async {
                await logError('🌍 [REGION DROPDOWN] Region selected: $value', null);
                setState(() => _selectedRegion = value);
              })(),
              isRtl: isRtl,
            ),
            const SizedBox(height: 20),
            
            // Webserver
            _buildDropdownField(
              label: loc.tr('webserver'),
              value: _selectedWebserver,
              items: webservers.map((ws) => DropdownMenuItem(
                value: ws['id'],
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    ws['name']!,
                    textAlign: TextAlign.left,
                  ),
                ),
              )).toList(),
              onChanged: (value) => setState(() => _selectedWebserver = value),
              isRtl: isRtl,
            ),
            const SizedBox(height: 20),
            
            // PHP version
            _buildDropdownField(
              label: loc.tr('php_version'),
              value: _selectedPhpVersion,
              items: phpVersions.map((ver) => DropdownMenuItem(
                value: ver,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    ver == 'none' ? 'Do not install PHP' : 'PHP $ver',
                    textAlign: TextAlign.left,
                  ),
                ),
              )).toList(),
              onChanged: (value) => setState(() => _selectedPhpVersion = value),
              isRtl: isRtl,
            ),
            const SizedBox(height: 20),
            
            // Database
            _buildDropdownField(
              label: loc.tr('database'),
              value: _selectedDatabase,
              items: databases.map((db) => DropdownMenuItem(
                value: db['id'],
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    db['name']!,
                    textAlign: TextAlign.left,
                  ),
                ),
              )).toList(),
              onChanged: (value) => setState(() => _selectedDatabase = value),
              isRtl: isRtl,
            ),
            const SizedBox(height: 20),
            
            // Install Ploi Monitoring
            Row(
              mainAxisAlignment: isRtl ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (!isRtl) ...[
                  Checkbox(
                    value: _installMonitoring,
                    onChanged: (val) => setState(() => _installMonitoring = val ?? false),
                  ),
                  const SizedBox(width: 8),
                  Text(loc.tr('install_monitoring')),
                ] else ...[
                  Text(loc.tr('install_monitoring')),
                  const SizedBox(width: 8),
                  Checkbox(
                    value: _installMonitoring,
                    onChanged: (val) => setState(() => _installMonitoring = val ?? false),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 32),
            // כפתור יצירת שרת
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  debugPrint('🚀 [CREATE SERVER FINAL] Create server button clicked');
                  _showCreateServerConfirmation();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: Text('יצירת השרת'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
    required bool isRtl,
  }) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label, 
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item.value,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: item.child,
                ),
              );
            }).toList(),
            onChanged: onChanged,
            isExpanded: true,
            alignment: AlignmentDirectional.centerStart,
            icon: const Icon(Icons.arrow_drop_down),
            dropdownColor: Colors.white,
          ),
        ],
      ),
    );
  }

  String _removePlanIdFromDescription(String? description, String? id) {
    if (description == null || id == null) return description ?? '';
    // Remove the id if it appears at the start or in brackets
    return description.replaceAll('[$id] ', '').replaceAll('[$id]', '').replaceAll('$id ', '').replaceAll(id, '').trim();
  }

  void _showCreateServerConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('האם בטוח להקים את השרת?'),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // סגור את פופאפ האישור
                await _createServer();
              },
              child: const Text('כן'),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop(); // סגור את פופאפ האישור בלבד
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red, width: 2),
              ),
              child: const Text('לא', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _createServer() async {
    debugPrint('🔄 [CREATE SERVER] Starting server creation process...');
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('ploi_api_token');
      
      if (token == null) {
        debugPrint('❌ [CREATE SERVER] No API token found');
        if (mounted) {
          _showError('No API token found. Please connect to Ploi first.');
        }
        return;
      }

      debugPrint('🔑 [CREATE SERVER] API token found, preparing parameters...');
      
      // Validate required fields
      if (_nameController.text.trim().isEmpty) {
        debugPrint('❌ [CREATE SERVER] Server name is empty');
        if (mounted) {
          _showError('Server name is required');
        }
        return;
      }

      if (_selectedPlan == null) {
        debugPrint('❌ [CREATE SERVER] No plan selected');
        if (mounted) {
          _showError('Please select a server plan');
        }
        return;
      }

      if (_selectedRegion == null) {
        debugPrint('❌ [CREATE SERVER] No region selected');
        if (mounted) {
          _showError('Please select a server region');
        }
        return;
      }

      debugPrint('📋 [CREATE SERVER] Validating form data...');
      final name = _nameController.text.trim();
      debugPrint('   - Name: $name');
      debugPrint('   - OS: $_selectedOs');
      debugPrint('   - Plan: $_selectedPlan');
      debugPrint('   - Region: $_selectedRegion');
      final providerName = widget.providerDetails['name'];
      debugPrint('   - Provider: $providerName');

      // Prepare parameters according to Ploi API documentation
      final params = {
        'name': name,
        'credential': widget.providerDetails['id'] ?? widget.providerDetails['provider_id'],
        'region': _selectedRegion,
        'plan': _selectedPlan,
        'os': _selectedOs,
        'type': _selectedServerType,
        'ip_version': _selectedIpVersion,
        'webserver_type': _selectedWebserver,
        'php_version': _selectedPhpVersion == 'none' ? null : _selectedPhpVersion,
        'database_type': _selectedDatabase == 'none' ? null : _selectedDatabase,
        'install_monitoring': _installMonitoring,
      };

      debugPrint('🚀 [CREATE SERVER] Calling Ploi API with params: $params');

      // Show loading indicator
      if (mounted) {
        _showLoading('Creating server...');
      }

      // Call the API
      final result = await PloiApiService.createServer(token, params);
      
      debugPrint('✅ [CREATE SERVER] Server created successfully: $result');

      // Hide loading and show success
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Close loading dialog
        _showSuccess('Server created successfully!');

        // Close the create server dialog
        Navigator.of(context, rootNavigator: true).pop();
      }

    } catch (e) {
      debugPrint('💥 [CREATE SERVER] Error creating server: $e');
      
      // Hide loading if showing
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      
      if (mounted) {
        _showError('Failed to create server: $e');
      }
    }
  }

  void _showLoading(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text(message),
          ],
        ),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
  }
}

class ServerManagementPage extends StatefulWidget {
  final Map<String, dynamic> server;

  const ServerManagementPage({
    super.key,
    required this.server,
  });

  @override
  State<ServerManagementPage> createState() => _ServerManagementPageState();
}

class _ServerManagementPageState extends State<ServerManagementPage> {
  bool isLoadingSites = false;
  List<Map<String, dynamic>> sites = [];
  String? sitesError;

  @override
  void initState() {
    super.initState();
    _loadSites();
  }

  Future<void> _loadSites() async {
    setState(() {
      isLoadingSites = true;
      sitesError = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('ploi_api_token');
      
      if (token != null) {
        final serverId = widget.server['id'];
        final sitesData = await PloiApiService.getSites(token, serverId);
        
        setState(() {
          sites = sitesData;
          isLoadingSites = false;
        });
      }
    } catch (e) {
      setState(() {
        sitesError = e.toString();
        isLoadingSites = false;
      });
    }
  }

  String _getSiteDomain(Map<String, dynamic> site) {
    return site['root_domain'] ?? site['domain'] ?? 'Unknown Domain';
  }

  String _getSiteRepository(Map<String, dynamic> site) {
    final repo = site['repository'] ?? site['git_repository'];
    if (repo == null || repo.toString().isEmpty) {
      return 'No Repository';
    }
    return repo.toString();
  }

  String _formatSiteSize(Map<String, dynamic> site) {
    final size = site['size'] ?? site['disk_usage'];
    if (size == null) return 'Size unknown';
    return size.toString();
  }

  @override
  Widget build(BuildContext context) {
    final serverName = widget.server['name'] ?? 'Unknown Server';
    
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('ניהול שרת - $serverName'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: const Color(0xFF2C3E50),
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Server info header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1ABC9C),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            serverName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'IP: ${widget.server['ip'] ?? 'N/A'}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${sites.length} אתרים',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Sites section
              Row(
                children: [
                  Text(
                    'אתרים',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _loadSites,
                    tooltip: 'רענן',
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Sites list
              Expanded(
                child: _buildSitesList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSitesList() {
    if (isLoadingSites) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    if (sitesError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'שגיאה',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              sitesError!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadSites,
              child: const Text('נסה שוב'),
            ),
          ],
        ),
      );
    }
    
    if (sites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.language_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'לא נמצאו אתרים',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: sites.length,
      itemBuilder: (context, index) {
        final site = sites[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildSiteCard(
            site,
            _getSiteDomain(site),
            _getSiteRepository(site),
            _formatSiteSize(site),
          ),
        );
      },
    );
  }
  
  Widget _buildSiteCard(Map<String, dynamic> site, String domain, String repository, String size) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SiteManagementPage(
                site: site,
                serverData: widget.server,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      domain,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      repository,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      size,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('ערוך')),
                  const PopupMenuItem(value: 'delete', child: Text('מחק')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Site Management Page
class SiteManagementPage extends StatefulWidget {
  final Map<String, dynamic> site;
  final Map<String, dynamic> serverData;

  const SiteManagementPage({
    super.key,
    required this.site,
    required this.serverData,
  });

  @override
  State<SiteManagementPage> createState() => _SiteManagementPageState();
}

class _SiteManagementPageState extends State<SiteManagementPage> {
  String selectedSection = 'general';
  
  String _getSiteDomain(Map<String, dynamic> site) {
    return site['root_domain'] ?? site['domain'] ?? 'Unknown Site';
  }
  
  String _getSiteRepository(Map<String, dynamic> site) {
    final repo = site['repository'] ?? site['git_repository'];
    if (repo == null || repo.toString().isEmpty) {
      return 'No Repository';
    }
    return repo.toString();
  }
  
  String _getSiteSize(Map<String, dynamic> site) {
    final size = site['size'] ?? site['disk_usage'];
    if (size == null) return 'Size unknown';
    return size.toString();
  }
  
  @override
  Widget build(BuildContext context) {
    final siteDomain = _getSiteDomain(widget.site);
    
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('ניהול אתר - $siteDomain'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: const Color(0xFF2C3E50),
          foregroundColor: Colors.white,
        ),
        body: Row(
          children: [
            // Sidebar Navigation
            Container(
              width: 250,
              color: const Color(0xFFF8F9FA),
              child: Column(
                children: [
                  // Site Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    color: const Color(0xFF1ABC9C),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            siteDomain,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Navigation Menu
                  Expanded(
                    child: ListView(
                      children: [
                        _buildSidebarItem('general', 'כללי', Icons.dashboard),
                        _buildSidebarItem('ssl', 'SSL', Icons.security),
                        _buildSidebarItem('cronjobs', 'Cronjobs', Icons.schedule),
                        _buildSidebarItem('notifications', 'התראות', Icons.notifications),
                        _buildSidebarItem('monitor', 'ניטור', Icons.monitor),
                        _buildSidebarItem('redirects', 'הפניות', Icons.open_in_new),
                        _buildSidebarItem('manage', 'ניהול', Icons.settings),
                        _buildSidebarItem('logs', 'לוגים', Icons.list_alt),
                        _buildSidebarItem('settings', 'הגדרות', Icons.tune),
                        _buildSidebarItem('view', 'תצוגה', Icons.visibility),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Main Content Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: _buildMainContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSidebarItem(String key, String title, IconData icon) {
    final isSelected = selectedSection == key;
    
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? const Color(0xFF1ABC9C) : Colors.grey[600],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? const Color(0xFF1ABC9C) : Colors.grey[800],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: const Color(0xFF1ABC9C).withValues(alpha: 0.1),
      onTap: () {
        setState(() {
          selectedSection = key;
        });
      },
    );
  }
  
  Widget _buildMainContent() {
    switch (selectedSection) {
      case 'general':
        return _buildGeneralSection();
      case 'ssl':
        return _buildSSLSection();
      case 'cronjobs':
        return _buildCronjobsSection();
      case 'notifications':
        return _buildNotificationsSection();
      case 'monitor':
        return _buildMonitorSection();
      case 'redirects':
        return _buildRedirectsSection();
      case 'manage':
        return _buildManageSection();
      case 'logs':
        return _buildLogsSection();
      case 'settings':
        return _buildSettingsSection();
      case 'view':
        return _buildViewSection();
      default:
        return _buildGeneralSection();
    }
  }
  
  Widget _buildGeneralSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'כללי',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 24),
        
        // Installation Options
        Row(
          children: [
            Expanded(
              child: _buildInstallationCard(
                'Git',
                'התקן מרפוזיטורי',
                Icons.code,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInstallationCard(
                'WordPress',
                'התקן WordPress',
                Icons.web,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInstallationCard(
                'Nextcloud',
                'התקן Nextcloud',
                Icons.cloud,
                Colors.blue[600]!,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInstallationCard(
                'Custom',
                'התקנה מותאמת',
                Icons.build,
                Colors.grey[600]!,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 32),
        
        // Site Information
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'פרטי אתר',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow('דומיין:', _getSiteDomain(widget.site)),
                _buildInfoRow('רפוזיטורי:', _getSiteRepository(widget.site)),
                _buildInfoRow('גודל:', _getSiteSize(widget.site)),
                _buildInfoRow('נוצר:', widget.site['created_at'] ?? 'N/A'),
                _buildInfoRow('עודכן:', widget.site['updated_at'] ?? 'N/A'),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildInstallationCard(String title, String subtitle, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          if (title == 'Git') {
            _showGitInstallationDialog();
          } else {
            _showComingSoonDialog(title);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Placeholder sections for other functionality
  Widget _buildSSLSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ניהול SSL',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 24),
        
        // SSL Status Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.security,
                      color: Colors.green[600],
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'סטטוס SSL',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'לא פעיל',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoRow('סוג תעודה:', 'לא מותקנת'),
                _buildInfoRow('תאריך תפוגה:', 'לא רלוונטי'),
                _buildInfoRow('דומיינים מכוסים:', _getSiteDomain(widget.site)),
                _buildInfoRow('הקשפה אוטומטית:', 'מושבתת'),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // SSL Actions
        Row(
          children: [
            Expanded(
                             child: _buildSSLActionCard(
                 'התקן תעודה',
                 'התקן תעודת SSL חדשה',
                Icons.add_circle_outline,
                Colors.blue,
                () => _showSSLInstallDialog(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSSLActionCard(
                'חדש תעודה',
                'חדש תעודה קיימת',
                Icons.refresh,
                Colors.orange,
                () => _renewSSL(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSSLActionCard(
                'הסר SSL',
                'הסר תעודת SSL',
                Icons.delete_outline,
                Colors.red,
                () => _removeSSL(),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // SSL Certificate Details
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'פרטי תעודה',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.security,
                        size: 48,
                        color: Colors.red[400],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'אין תעודת SSL מותקנת',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'להתקנת תעודת SSL חדשה, לחץ על "התקן תעודה" למעלה',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildSSLActionCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showSSLInstallDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('התקן תעודת SSL'),
        content: const Text('האם ברצונך להתקין תעודת SSL חדשה?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ביטול'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('תעודת SSL מותקנת...')),
              );
            },
            child: const Text('התקן'),
          ),
        ],
      ),
    );
  }
  
  void _renewSSL() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('מחדש תעודת SSL...')),
    );
  }
  
  void _removeSSL() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('הסר תעודת SSL'),
        content: const Text('האם אתה בטוח שברצונך להסיר את תעודת ה-SSL?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ביטול'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('תעודת SSL הוסרה')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('הסר'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCronjobsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'משימות מתוזמנות',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _showAddCronjobDialog,
              icon: const Icon(Icons.add),
              label: const Text('הוסף משימה'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Cronjobs List
        Expanded(
          child: _buildCronjobsList(),
        ),
      ],
    );
  }
  
  Widget _buildCronjobsList() {
    // Mock data for cronjobs
    final cronjobs = [
      {
        'id': 1,
        'command': 'php artisan queue:work',
        'frequency': '*/5 * * * *',
        'description': 'Process queue jobs every 5 minutes',
        'enabled': true,
        'last_run': '2025-06-27 10:15:00',
      },
      {
        'id': 2,
        'command': 'php artisan backup:run',
        'frequency': '0 2 * * *',
        'description': 'Daily backup at 2 AM',
        'enabled': true,
        'last_run': '2025-06-27 02:00:00',
      },
      {
        'id': 3,
        'command': 'php artisan cache:clear',
        'frequency': '0 0 * * 0',
        'description': 'Clear cache weekly',
        'enabled': false,
        'last_run': null,
      },
    ];
    
    return ListView.builder(
      itemCount: cronjobs.length,
      itemBuilder: (context, index) {
        final cronjob = cronjobs[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                                                     Text(
                             cronjob['command'].toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                            ),
                          ),
                          const SizedBox(height: 4),
                                                     Text(
                             cronjob['description'].toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: cronjob['enabled'] as bool,
                      onChanged: (value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              value ? 'משימה הופעלה' : 'משימה הושבתה',
                            ),
                          ),
                        );
                      },
                    ),
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit),
                              SizedBox(width: 8),
                              Text('ערוך'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text('מחק'),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'delete') {
                          _deleteCronjob(cronjob['id'] as int);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'תדירות: ${cronjob['frequency']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                              fontFamily: 'monospace',
                            ),
                          ),
                          const Spacer(),
                          if (cronjob['last_run'] != null) ...[
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'הרצה אחרונה: ${cronjob['last_run']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                          ] else
                            Text(
                              'לא רץ עדיין',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  void _showAddCronjobDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddCronjobDialog(),
    );
  }
  
  void _deleteCronjob(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('מחק משימה מתוזמנת'),
        content: const Text('האם אתה בטוח שברצונך למחוק את המשימה?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ביטול'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('משימה נמחקה')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('מחק'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNotificationsSection() {
    return const Center(child: Text('Notifications Management - בפיתוח'));
  }
  
  Widget _buildMonitorSection() {
    return const Center(child: Text('Site Monitoring - בפיתוח'));
  }
  
  Widget _buildRedirectsSection() {
    return const Center(child: Text('Redirects Management - בפיתוח'));
  }
  
  Widget _buildManageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ניהול אתר',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 24),
        
        // Site Actions
        Row(
          children: [
            Expanded(
              child: _buildManageActionCard(
                'גיבוי',
                'צור גיבוי של האתר',
                Icons.backup,
                Colors.blue,
                () => _createBackup(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildManageActionCard(
                'רענן',
                'אתחל את השירותים',
                Icons.refresh,
                Colors.orange,
                () => _restartServices(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildManageActionCard(
                'נקה Cache',
                'נקה את המטמון',
                Icons.cleaning_services,
                Colors.green,
                () => _clearCache(),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // File Manager
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.folder,
                      color: Colors.blue[600],
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'מנהל קבצים',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _openFileManager,
                      child: const Text('פתח'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'נהל קבצים והתיקיות של האתר',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Database Management
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.storage,
                      color: Colors.purple[600],
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'ניהול מסד נתונים',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _createDatabaseBackup,
                        icon: const Icon(Icons.backup),
                        label: const Text('גיבוי DB'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _openPhpMyAdmin,
                        icon: const Icon(Icons.admin_panel_settings),
                        label: const Text('phpMyAdmin'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Deployment
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.rocket_launch,
                      color: Colors.green[600],
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'פריסה (Deployment)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _deployFromGit,
                        icon: const Icon(Icons.download),
                        label: const Text('Deploy מ-Git'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _showDeploymentHistory,
                        icon: const Icon(Icons.history),
                        label: const Text('היסטוריית Deploy'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Danger Zone
        Card(
          color: Colors.red[50],
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.warning,
                      color: Colors.red[600],
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'אזור מסוכן',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _suspendSite,
                        icon: const Icon(Icons.pause, color: Colors.orange),
                        label: const Text(
                          'השעה אתר',
                          style: TextStyle(color: Colors.orange),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.orange),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _deleteSite,
                        icon: const Icon(Icons.delete_forever, color: Colors.red),
                        label: const Text(
                          'מחק אתר',
                          style: TextStyle(color: Colors.red),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildManageActionCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                icon,
                size: 40,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _createBackup() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('יוצר גיבוי...')),
    );
  }
  
  void _restartServices() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('מאתחל שירותים...')),
    );
  }
  
  void _clearCache() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('מנקה cache...')),
    );
  }
  
  void _openFileManager() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('פותח מנהל קבצים...')),
    );
  }
  
  void _createDatabaseBackup() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('יוצר גיבוי מסד נתונים...')),
    );
  }
  
  void _openPhpMyAdmin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('פותח phpMyAdmin...')),
    );
  }
  
  void _deployFromGit() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('מפרס מ-Git...')),
    );
  }
  
  void _showDeploymentHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('מציג היסטוריית deployment...')),
    );
  }
  
  void _suspendSite() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('השעה אתר'),
        content: const Text('האם אתה בטוח שברצונך להשעות את האתר?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ביטול'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('האתר הושעה')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('השעה'),
          ),
        ],
      ),
    );
  }
  
  void _deleteSite() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('מחק אתר'),
        content: const Text('האם אתה בטוח שברצונך למחוק את האתר? פעולה זו בלתי הפיכה!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ביטול'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Return to sites list
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('האתר נמחק')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('מחק'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLogsSection() {
    return const Center(child: Text('Site Logs - בפיתוח'));
  }
  
  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'הגדרות אתר',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 24),
        
        // General Settings
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'הגדרות כלליות',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Site Domain
                TextFormField(
                  initialValue: _getSiteDomain(widget.site),
                  decoration: const InputDecoration(
                    labelText: 'דומיין האתר',
                    border: OutlineInputBorder(),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Document Root
                TextFormField(
                  initialValue: '/public',
                  decoration: const InputDecoration(
                    labelText: 'תיקיית שורש',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // PHP Settings
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'הגדרות PHP',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: '8.2',
                        decoration: const InputDecoration(
                          labelText: 'גרסת PHP',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: '7.4', child: Text('PHP 7.4')),
                          DropdownMenuItem(value: '8.0', child: Text('PHP 8.0')),
                          DropdownMenuItem(value: '8.1', child: Text('PHP 8.1')),
                          DropdownMenuItem(value: '8.2', child: Text('PHP 8.2')),
                          DropdownMenuItem(value: '8.3', child: Text('PHP 8.3')),
                        ],
                        onChanged: (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('גרסת PHP שונתה ל-$value')),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        initialValue: '256M',
                        decoration: const InputDecoration(
                          labelText: 'Memory Limit',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Security Settings
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'הגדרות אבטחה',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 16),
                
                SwitchListTile(
                  title: const Text('הגנת מסמכים רגישים'),
                  subtitle: const Text('חסימת גישה לקבצי .env ואחרים'),
                  value: true,
                  onChanged: (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          value ? 'הגנה הופעלה' : 'הגנה הושבתה',
                        ),
                      ),
                    );
                  },
                ),
                
                SwitchListTile(
                  title: const Text('Basic Auth'),
                  subtitle: const Text('דרוש שם משתמש וסיסמה לגישה'),
                  value: false,
                  onChanged: (value) {
                    if (value) {
                      _showBasicAuthDialog();
                    }
                  },
                ),
                
                SwitchListTile(
                  title: const Text('IP Whitelist'),
                  subtitle: const Text('הגבל גישה לכתובות IP מורשות'),
                  value: false,
                  onChanged: (value) {
                    if (value) {
                      _showIPWhitelistDialog();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Save Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saveSettings,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('שמור הגדרות'),
          ),
        ),
      ],
    );
  }
  
  void _showBasicAuthDialog() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('הגדר Basic Auth'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'שם משתמש',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'סיסמה',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ביטול'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Basic Auth הוגדר')),
                );
              },
              child: const Text('שמור'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showIPWhitelistDialog() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('רשימת IP מורשים'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'כתובת IP',
                  hintText: '192.168.1.1',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'הכנס כתובת IP אחת בכל שורה',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ביטול'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('רשימת IP עודכנה')),
                );
              },
              child: const Text('שמור'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('הגדרות נשמרו בהצלחה!'),
        backgroundColor: Colors.green,
      ),
    );
  }
  
  Widget _buildViewSection() {
    return const Center(child: Text('Site View - בפיתוח'));
  }
  
  void _showGitInstallationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GitInstallationDialog(site: widget.site);
      },
    );
  }
  
  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$feature - בפיתוח'),
          content: Text('התכונה $feature תהיה זמינה בקרוב!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('אוקיי'),
            ),
          ],
        );
      },
    );
  }
}

// Git Installation Dialog
class GitInstallationDialog extends StatefulWidget {
  final Map<String, dynamic> site;

  const GitInstallationDialog({super.key, required this.site});

  @override
  State<GitInstallationDialog> createState() => _GitInstallationDialogState();
}

class _GitInstallationDialogState extends State<GitInstallationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _repositoryController = TextEditingController();
  final _branchController = TextEditingController(text: 'main');
  String _provider = 'github';
  bool _isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text('התקן מרפוזיטורי Git'),
        content: SizedBox(
          width: 500,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Provider Selection
                DropdownButtonFormField<String>(
                  value: _provider,
                  decoration: const InputDecoration(
                    labelText: 'ספק Git',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'github', child: Text('GitHub')),
                    DropdownMenuItem(value: 'gitlab', child: Text('GitLab')),
                    DropdownMenuItem(value: 'bitbucket', child: Text('Bitbucket')),
                    DropdownMenuItem(value: 'custom', child: Text('Custom')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _provider = value!;
                    });
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Repository URL
                TextFormField(
                  controller: _repositoryController,
                  decoration: const InputDecoration(
                    labelText: 'כתובת רפוזיטורי',
                    hintText: 'https://github.com/username/repository',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'יש להזין כתובת רפוזיטורי';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Branch
                TextFormField(
                  controller: _branchController,
                  decoration: const InputDecoration(
                    labelText: 'ענף (Branch)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'יש להזין שם ענף';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Additional Options
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'אפשרויות נוספות',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text('• התקנת dependencies אוטומטית'),
                        const Text('• הגדרת webhook לעדכונים אוטומטיים'),
                        const Text('• הפעלת build scripts'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            child: const Text('ביטול'),
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : _installGitRepository,
            child: _isLoading 
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('התקן'),
          ),
        ],
      ),
    );
  }
  
  void _installGitRepository() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // TODO: Implement actual Ploi API call for Git installation
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('רפוזיטורי Git הותקן בהצלחה!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('שגיאה בהתקנת רפוזיטורי: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  @override
  void dispose() {
    _repositoryController.dispose();
    _branchController.dispose();
    super.dispose();
  }
}

// Add Cronjob Dialog
class AddCronjobDialog extends StatefulWidget {
  const AddCronjobDialog({super.key});
  
  @override
  State<AddCronjobDialog> createState() => _AddCronjobDialogState();
}

class _AddCronjobDialogState extends State<AddCronjobDialog> {
  final _formKey = GlobalKey<FormState>();
  final _commandController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _frequency = '0 * * * *'; // Every hour
  
  final List<Map<String, String>> _presetFrequencies = [
    {'label': 'כל דקה', 'value': '* * * * *'},
    {'label': 'כל 5 דקות', 'value': '*/5 * * * *'},
    {'label': 'כל שעה', 'value': '0 * * * *'},
    {'label': 'יומי ב-2:00', 'value': '0 2 * * *'},
    {'label': 'שבועי (ראשון)', 'value': '0 0 * * 0'},
    {'label': 'חודשי (1)', 'value': '0 0 1 * *'},
    {'label': 'מותאם אישית', 'value': 'custom'},
  ];
  
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text('הוסף משימה מתוזמנת'),
        content: SizedBox(
          width: 500,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Command
                TextFormField(
                  controller: _commandController,
                  decoration: const InputDecoration(
                    labelText: 'פקודה',
                    hintText: 'php artisan queue:work',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'יש להזין פקודה';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'תיאור (אופציונלי)',
                    hintText: 'תיאור המשימה',
                    border: OutlineInputBorder(),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Frequency Preset
                DropdownButtonFormField<String>(
                  value: _frequency,
                  decoration: const InputDecoration(
                    labelText: 'תדירות',
                    border: OutlineInputBorder(),
                  ),
                  items: _presetFrequencies.map((preset) {
                    return DropdownMenuItem(
                      value: preset['value'],
                      child: Text(preset['label']!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _frequency = value!;
                    });
                  },
                ),
                
                if (_frequency == 'custom') ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Cron Expression',
                      hintText: '0 2 * * *',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _frequency = value;
                    },
                    validator: (value) {
                      if (_frequency == 'custom' && (value == null || value.isEmpty)) {
                        return 'יש להזין Cron Expression';
                      }
                      return null;
                    },
                  ),
                ],
                
                const SizedBox(height: 16),
                
                // Cron Help
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'פורמט Cron:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'דקה שעה יום חודש יום-בשבוע',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const Text(
                        'דוגמה: 0 2 * * * = כל יום ב-2:00',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ביטול'),
          ),
          ElevatedButton(
            onPressed: _addCronjob,
            child: const Text('הוסף'),
          ),
        ],
      ),
    );
  }
  
  void _addCronjob() {
    if (!_formKey.currentState!.validate()) return;
    
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('משימה מתוזמנת נוספה בהצלחה!')),
    );
  }
  
  @override
  void dispose() {
    _commandController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
