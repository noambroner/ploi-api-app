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
          title: Text('Ploi API Dashboard v1.1.0'),
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
                        // TODO: Navigate to server details
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Server ${server['name']} clicked'),
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
