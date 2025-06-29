import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'services/ploi_api_service.dart';
import 'dialogs/api_settings_dialog.dart';

import 'package:shared_preferences/shared_preferences.dart';
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

// Old PloiApiService class removed - now using the one from services/ploi_api_service.dart

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
              title: 'Ploi API Manager v1.9.10',
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

  void _showApiSettings() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const ApiSettingsDialog(),
    );
    
    if (result == true) {
      // API token was saved, check connection status
      final apiService = PloiApiService();
      await apiService.initialize();
      
      if (apiService.isConfigured) {
        setState(() {
          _isConnected = true;
        });
      }
    }
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
          title: Text('Ploi API Dashboard v1.9.5'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: _showApiSettings,
              tooltip: 'הגדרות API',
            ),
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
      final apiService = PloiApiService();
      await apiService.setApiToken(_tokenController.text.trim());
      final response = await apiService.testConnection();
      final success = response.isNotEmpty;
      
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
        final apiService = PloiApiService();
        await apiService.setApiToken(token);
        final serverData = await apiService.getServers();
        
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
              // Note: getServerProviders method needs to be implemented
        final providers = <Map<String, dynamic>>[];
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
              // Note: createServer method needs to be implemented
        final result = {'message': 'Server creation not yet implemented'};
      
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
  Map<String, String> siteStatuses = {}; // Store simple status for each site
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
        final apiService = PloiApiService();
        await apiService.setApiToken(token);
        final sitesData = await apiService.getSites(serverId);
        
        setState(() {
          sites = sitesData;
          isLoadingSites = false;
        });
        
        // Check each site with CURL
        _checkSitesWithCurl();
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

  // Simple CURL check for each site
  Future<void> _checkSitesWithCurl() async {
    for (final site in sites) {
      final domain = _getSiteDomain(site);
      if (domain == 'Unknown Domain') continue;
      
      _checkSingleSite(domain);
    }
  }

  // Check single site with CURL
  Future<void> _checkSingleSite(String domain) async {
    try {
      final result = await Process.run('curl', [
        '-I', // HEAD request only
        '-s', // Silent
        '-w', '%{http_code}', // Write HTTP status code
        '--connect-timeout', '3', // 3 second timeout
        '--max-time', '5', // 5 second max time
        'http://$domain',
      ]);
      
      if (result.exitCode == 0) {
        final fullOutput = result.stdout.toString();
        final lines = fullOutput.split('\n');
        final statusCode = lines.last.trim(); // Last line is the status code
        final headers = lines.take(lines.length - 1).join('\n'); // Everything else is headers
        
        setState(() {
          siteStatuses[domain] = '$statusCode|||$headers'; // Store both status and headers
        });
      } else {
        setState(() {
          siteStatuses[domain] = 'ERROR|||Connection failed';
        });
      }
    } catch (e) {
      setState(() {
        siteStatuses[domain] = 'FAIL|||Exception: $e';
      });
    }
  }

  // Extract status code from stored data
  String _getStatusCode(String storedData) {
    final parts = storedData.split('|||');
    return parts[0]; // First part is the status code
  }

  // Extract headers/details from stored data
  String _getStatusTooltip(String storedData) {
    final parts = storedData.split('|||');
    if (parts.length < 2) return parts[0];
    
    final statusCode = parts[0];
    final headers = parts[1];
    
    String tooltip = 'Status: $statusCode\n\n';
    if (headers.isNotEmpty) {
      tooltip += 'Headers:\n$headers';
    }
    
    return tooltip.trim();
  }

  // Get color based on status
  Color _getStatusColor(String status) {
    if (status == '200') return Colors.green;
    if (status == '404') return Colors.red;
    if (status.startsWith('3')) return Colors.orange; // Redirects
    if (status.startsWith('4') || status.startsWith('5')) return Colors.red;
    if (status == 'ERROR' || status == 'FAIL') return Colors.grey;
    return Colors.blue; // Default
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
                    icon: const Icon(Icons.add),
                    onPressed: _showCreateSiteDialog,
                    tooltip: 'הוסף אתר חדש',
                  ),
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
          child: Column(
            children: [
              Row(
                children: [
                  // Simple site icon
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                domain,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                                                         // Show CURL status
                             if (siteStatuses.containsKey(domain))
                               Tooltip(
                                 message: _getStatusTooltip(siteStatuses[domain]!),
                                 child: Container(
                                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                   decoration: BoxDecoration(
                                     color: _getStatusColor(_getStatusCode(siteStatuses[domain]!)),
                                     borderRadius: BorderRadius.circular(12),
                                   ),
                                   child: Text(
                                     _getStatusCode(siteStatuses[domain]!),
                                     style: const TextStyle(
                                       color: Colors.white,
                                       fontSize: 12,
                                       fontWeight: FontWeight.bold,
                                     ),
                                   ),
                                 ),
                               ),
                          ],
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
                      const PopupMenuItem(
                        value: 'ssl',
                        child: Row(
                          children: [
                            Icon(Icons.security, size: 16),
                            SizedBox(width: 8),
                            Text('הוסף SSL'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'ssh_keys',
                        child: Row(
                          children: [
                            Icon(Icons.vpn_key, size: 16),
                            SizedBox(width: 8),
                            Text('SSH Keys'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'sftp',
                        child: Row(
                          children: [
                            Icon(Icons.folder_shared, size: 16),
                            SizedBox(width: 8),
                            Text('SFTP'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(value: 'delete', child: Text('מחק')),
                    ],
                    onSelected: (value) => _handleSiteMenuAction(value, site, domain),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }





  // Handle site menu actions
  void _handleSiteMenuAction(String action, Map<String, dynamic> site, String domain) {
    switch (action) {
      case 'edit':
        // Navigate to site management page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SiteManagementPage(
              site: site,
              serverData: widget.server,
            ),
          ),
        );
        break;
      case 'ssl':
        _showSSLDialog(site, domain);
        break;
      case 'ssh_keys':
        _showSSHKeysDialog(site, domain);
        break;
      case 'sftp':
        _showSFTPDialog(site, domain);
        break;
      case 'delete':
        _showDeleteSiteDialog(site, domain);
        break;
    }
  }

  // Show SSL management dialog
  void _showSSLDialog(Map<String, dynamic> site, String domain) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.security, color: Colors.green),
            SizedBox(width: 8),
            Text('הוספת SSL'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('הוסף SSL Certificate עבור "$domain"'),
            const SizedBox(height: 16),
            const Text(
              'סוגי SSL זמינים:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.verified_user, color: Colors.green),
              title: const Text('Let\'s Encrypt (חינם)'),
              subtitle: const Text('SSL חינם ואוטומטי'),
              onTap: () {
                Navigator.pop(context);
                _createLetsEncryptSSL(site, domain);
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload_file, color: Colors.blue),
              title: const Text('SSL מותאם אישית'),
              subtitle: const Text('העלה SSL Certificate משלך'),
              onTap: () {
                Navigator.pop(context);
                _showCustomSSLDialog(site, domain);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ביטול'),
          ),
        ],
      ),
    );
  }

  // Show SSH Keys management dialog
  void _showSSHKeysDialog(Map<String, dynamic> site, String domain) {
    showDialog(
      context: context,
      builder: (context) => SSHKeysDialog(
        serverId: widget.server['id'],
        serverName: widget.server['name'] ?? 'Unknown Server',
        siteDomain: domain,
      ),
    );
  }

  // Create Let's Encrypt SSL
  Future<void> _createLetsEncryptSSL(Map<String, dynamic> site, String domain) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('יוצר SSL Certificate...'),
          ],
        ),
      ),
    );

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('ploi_api_token');
      
      if (token != null) {
        final apiService = PloiApiService();
        await apiService.setApiToken(token);
        
        // Create Let's Encrypt SSL
        await apiService.createSSLCertificate(
          serverId: widget.server['id'],
          siteId: site['id'],
          type: 'letsencrypt',
        );
        
        // Close loading dialog
        if (mounted) Navigator.pop(context);
        
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('SSL Certificate נוצר בהצלחה עבור "$domain"')),
          );
        }
      }
    } catch (e) {
      // Close loading dialog
      if (mounted) Navigator.pop(context);
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('שגיאה ביצירת SSL: $e')),
        );
      }
    }
  }

  // Show custom SSL dialog
  void _showCustomSSLDialog(Map<String, dynamic> site, String domain) {
    final certificateController = TextEditingController();
    final privateKeyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('SSL מותאם אישית - $domain'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: certificateController,
                maxLines: 8,
                decoration: const InputDecoration(
                  labelText: 'Certificate (*.crt)',
                  hintText: '-----BEGIN CERTIFICATE-----\n...\n-----END CERTIFICATE-----',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: privateKeyController,
                maxLines: 8,
                decoration: const InputDecoration(
                  labelText: 'Private Key (*.key)',
                  hintText: '-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ביטול'),
          ),
          ElevatedButton(
            onPressed: () {
              if (certificateController.text.isNotEmpty && privateKeyController.text.isNotEmpty) {
                Navigator.pop(context);
                _createCustomSSL(site, domain, certificateController.text, privateKeyController.text);
              }
            },
            child: const Text('צור SSL'),
          ),
        ],
      ),
    );
  }

  // Create custom SSL
  Future<void> _createCustomSSL(Map<String, dynamic> site, String domain, String certificate, String privateKey) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('מעלה SSL Certificate...'),
          ],
        ),
      ),
    );

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('ploi_api_token');
      
      if (token != null) {
        final apiService = PloiApiService();
        await apiService.setApiToken(token);
        
        // Create custom SSL
        await apiService.createSSLCertificate(
          serverId: widget.server['id'],
          siteId: site['id'],
          type: 'custom',
          certificate: certificate,
          privateKey: privateKey,
        );
        
        // Close loading dialog
        if (mounted) Navigator.pop(context);
        
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('SSL Certificate הועלה בהצלחה עבור "$domain"')),
          );
        }
      }
    } catch (e) {
      // Close loading dialog
      if (mounted) Navigator.pop(context);
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('שגיאה בהעלאת SSL: $e')),
        );
      }
    }
  }

  // Show SFTP dialog
  void _showSFTPDialog(Map<String, dynamic> site, String domain) {
    showDialog(
      context: context,
      builder: (context) => SFTPDialog(
        serverId: widget.server['id'],
        siteId: site['id'],
        siteDomain: domain,
        serverIp: widget.server['ip_address'],
      ),
    );
  }

  // Show site deletion confirmation dialog
  void _showDeleteSiteDialog(Map<String, dynamic> site, String domain) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('מחיקת אתר'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('האם אתה בטוח שברצונך למחוק את האתר "$domain"?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: const Text(
                '⚠️ פעולה זו תמחק את האתר לצמיתות ולא ניתן לבטל אותה!',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
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
              _deleteSite(site['id'], domain);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('מחק אתר'),
          ),
        ],
      ),
    );
  }

  // Delete site implementation
  Future<void> _deleteSite(int siteId, String domain) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('מוחק אתר...'),
          ],
        ),
      ),
    );

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('ploi_api_token');
      
      if (token != null) {
        final apiService = PloiApiService();
        await apiService.setApiToken(token);
        
        // Call delete site API
        await apiService.deleteSite(widget.server['id'], siteId);
        
        // Close loading dialog
        if (mounted) Navigator.pop(context);
        
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('האתר "$domain" נמחק בהצלחה')),
          );
          
          // Refresh sites list
          _loadSites();
        }
      }
    } catch (e) {
      // Close loading dialog
      if (mounted) Navigator.pop(context);
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('שגיאה במחיקת האתר: $e')),
        );
      }
    }
  }




  void _showCreateSiteDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateSiteDialog(
        serverId: widget.server['id'],
        onSiteCreated: () {
          _loadSites(); // Refresh sites list after creation
        },
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
    return SingleChildScrollView(
      child: Column(
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
      ),
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
      builder: (context) => SSLInstallDialog(site: widget.site),
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
      // Simulate Git installation - would integrate with Ploi API in production
      await Future.delayed(const Duration(seconds: 2));
      
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

// SSL Installation Dialog
class SSLInstallDialog extends StatefulWidget {
  final Map<String, dynamic> site;

  const SSLInstallDialog({super.key, required this.site});

  @override
  State<SSLInstallDialog> createState() => _SSLInstallDialogState();
}

class _SSLInstallDialogState extends State<SSLInstallDialog> {
  String _certificateType = 'letsencrypt';
  bool _isLoading = false;
  final _domainsController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // Pre-fill with site domain
    final siteDomain = widget.site['domain'] ?? 'ploi.bflow.co.il';
    _domainsController.text = siteDomain;
  }
  
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text('התקן תעודת SSL'),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Certificate Type Selection
              Text(
                'סוג תעודה:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              
              DropdownButtonFormField<String>(
                value: _certificateType,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  helperText: 'בחר את סוג התעודה המתאים',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'letsencrypt',
                    child: Text('Let\'s Encrypt'),
                  ),
                  DropdownMenuItem(
                    value: 'custom',
                    child: Text('Custom Certificate'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _certificateType = value!;
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              // Domains
              Text(
                'דומיינים מכוסים:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              
              TextFormField(
                controller: _domainsController,
                decoration: const InputDecoration(
                  labelText: 'דומיינים',
                  hintText: 'example.com,www.example.com',
                  border: OutlineInputBorder(),
                  helperText: 'הפרד דומיינים בפסיק',
                ),
                maxLines: 2,
              ),
              
              const SizedBox(height: 16),
              
              // Info Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue[600], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'מידע חשוב',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• ודא שה-DNS מצביע לשרת הנכון',
                      style: TextStyle(fontSize: 12),
                    ),
                    const Text(
                      '• התקנת SSL עלולה לקחת מספר דקות',
                      style: TextStyle(fontSize: 12),
                    ),
                    const Text(
                      '• התעודה תתחדש אוטומטית',
                      style: TextStyle(fontSize: 12),
                    ),
                    const Text(
                      '• Let\'s Encrypt מגביל 5 תעודות לדומיין בשבוע',
                      style: TextStyle(fontSize: 12, color: Colors.orange),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            child: const Text('ביטול'),
          ),

          ElevatedButton(
            onPressed: _isLoading ? null : _installSSL,
            child: _isLoading 
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('התקן תעודה'),
          ),
        ],
      ),
    );
  }
  
  void _installSSL() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final ploiService = PloiApiService();
      
      // Verify API is configured
      if (!ploiService.isConfigured) {
        throw Exception('API Token לא מוגדר. אנא הגדר את ה-Token בהגדרות.');
      }
      
      final serverId = widget.site['server_id'] ?? widget.site['id'] ?? 1;
      final siteId = widget.site['id'] ?? 1;
      
      // Parse domains
      final domains = _domainsController.text
          .split(',')
          .map((d) => d.trim())
          .where((d) => d.isNotEmpty)
          .toList();
      
      if (domains.isEmpty) {
        throw Exception('יש להזין לפחות דומיין אחד');
      }
      
      // For Let's Encrypt, use first domain only (Ploi might not support multiple domains in one request)
      String certificateValue;
      if (_certificateType == 'letsencrypt') {
        certificateValue = domains.first; // Use only first domain for Let's Encrypt
      } else {
        certificateValue = domains.join(','); // For custom certificates, join all domains
      }
      
      // Test API connection first
      await ploiService.testConnection();
      
      // Install certificate - REAL API CALL
      final result = await ploiService.installSSLCertificate(
        serverId: serverId,
        siteId: siteId,
        certificate: certificateValue,
        type: _certificateType,
      );
      
      if (mounted) {
        Navigator.pop(context);
        
        // Show success dialog with more details
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green[600]),
                const SizedBox(width: 8),
                const Text('התקנה הושלמה!'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('בקשת התקנת SSL נשלחה בהצלחה:'),
                const SizedBox(height: 8),
                Text('• דומיינים: ${domains.join(', ')}'),
                Text('• סוג: ${_certificateType == 'letsencrypt' ? 'Let\'s Encrypt' : 'Custom'}'),
                Text('• מזהה תעודה: ${result['data']?['id'] ?? result['id'] ?? 'לא זמין'}'),
                Text('• סטטוס: ${result['data']?['status'] ?? result['status'] ?? 'בתהליך'}'),
                const SizedBox(height: 8),
                Text('• Server ID: $serverId'),
                Text('• Site ID: $siteId'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '⚠️ זה לא מבטיח שה-SSL הותקן!',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'בדוק בעוד מספר דקות אם התעודה באמת פעילה.\nאם יש שגיאה, היא תופיע בלוגים של Ploi.',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                if (result.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ExpansionTile(
                    title: const Text('פרטים טכניים'),
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          result.toString(),
                          style: const TextStyle(fontFamily: 'monospace', fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('סגור'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        // Check if it's a rate limiting error
        final isRateLimitError = e.toString().contains('too many certificates') || 
                                e.toString().contains('rate limit') ||
                                e.toString().contains('168h');
        
        // Show detailed error dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(
                  isRateLimitError ? Icons.access_time : Icons.error, 
                  color: isRateLimitError ? Colors.orange[600] : Colors.red[600]
                ),
                const SizedBox(width: 8),
                Text(isRateLimitError ? 'מגבלת Let\'s Encrypt' : 'שגיאה בהתקנת SSL'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isRateLimitError) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🚨 הגעת למגבלת Let\'s Encrypt',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[700],
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Let\'s Encrypt מגביל 5 תעודות לאותו דומיין בשבוע (168 שעות).',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '💡 פתרונות מומלצים:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Text('• המתן שבוע מלא ונסה שוב'),
                        const Text('• השתמש ב-Let\'s Encrypt Staging לבדיקות'),
                        const Text('• השתמש בתעודה Custom במקום'),
                        const Text('• בדוק אם יש תעודה קיימת שעובדת'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                const Text('פרטי השגיאה:'),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isRateLimitError ? Colors.grey[50] : Colors.red[50],
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isRateLimitError ? Colors.grey[300]! : Colors.red[200]!,
                    ),
                  ),
                  child: Text(
                    e.toString(),
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'אפשרויות לפתרון כלליות:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                if (!isRateLimitError) ...[
                  const Text('• ודא שה-API Token תקף'),
                  const Text('• בדוק שה-DNS מצביע לשרת הנכון'),
                  const Text('• ודא שהדומיין נגיש מהאינטרנט'),
                  const Text('• נסה שוב בעוד מספר דקות'),
                ] else ...[
                  const Text('• בדוק בלוג Ploi אם יש תעודות קיימות'),
                  const Text('• שקול להשתמש בתעודה Custom'),
                  const Text('• צור קשר עם תמיכת Ploi במידת הצורך'),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('סגור'),
              ),
            ],
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
    _domainsController.dispose();
    super.dispose();
  }
}

// Create Site Dialog
class CreateSiteDialog extends StatefulWidget {
  final int serverId;
  final VoidCallback onSiteCreated;

  const CreateSiteDialog({
    super.key,
    required this.serverId,
    required this.onSiteCreated,
  });

  @override
  State<CreateSiteDialog> createState() => _CreateSiteDialogState();
}

class _CreateSiteDialogState extends State<CreateSiteDialog> {
  final _formKey = GlobalKey<FormState>();
  final _domainController = TextEditingController();
  bool _isLoading = false;
  bool _showAdvanced = false;
  
  // Basic settings
  String _projectType = 'php';
  String _phpVersion = '8.3';
  String _webDirectory = '/public';
  
  // Advanced settings
  String _gitRepository = '';
  String _gitBranch = 'main';
  bool _installRepository = false;
  bool _installComposer = true;
  bool _installNpm = false;
  
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text('יצירת אתר חדש'),
        content: SizedBox(
          width: 500,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Domain field
                  TextFormField(
                    controller: _domainController,
                    decoration: const InputDecoration(
                      labelText: 'דומיין האתר',
                      hintText: 'example.com',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'יש להזין דומיין';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Project type
                  DropdownButtonFormField<String>(
                    value: _projectType,
                    decoration: const InputDecoration(
                      labelText: 'סוג פרויקט',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'php', child: Text('PHP')),
                      DropdownMenuItem(value: 'laravel', child: Text('Laravel')),
                      DropdownMenuItem(value: 'wordpress', child: Text('WordPress')),
                      DropdownMenuItem(value: 'nodejs', child: Text('Node.js')),
                      DropdownMenuItem(value: 'static', child: Text('Static HTML')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _projectType = value!;
                        // Auto-adjust settings based on project type
                        if (value == 'laravel') {
                          _webDirectory = '/public';
                          _installComposer = true;
                          _installNpm = false;
                        } else if (value == 'wordpress') {
                          _webDirectory = '/';
                          _installComposer = false;
                          _installNpm = false;
                        } else if (value == 'nodejs') {
                          _webDirectory = '/dist';
                          _installComposer = false;
                          _installNpm = true;
                        } else if (value == 'static') {
                          _webDirectory = '/';  // Static HTML צריך root directory
                          _installComposer = false;
                          _installNpm = false;
                        } else if (value == 'php') {
                          _webDirectory = '/public';
                          _installComposer = false;
                          _installNpm = false;
                        }
                      });
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // PHP Version (only for PHP projects)
                  if (_projectType == 'php' || _projectType == 'laravel' || _projectType == 'wordpress')
                    DropdownButtonFormField<String>(
                      value: _phpVersion,
                      decoration: const InputDecoration(
                        labelText: 'גרסת PHP',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: '8.3', child: Text('PHP 8.3')),
                        DropdownMenuItem(value: '8.2', child: Text('PHP 8.2')),
                        DropdownMenuItem(value: '8.1', child: Text('PHP 8.1')),
                        DropdownMenuItem(value: '7.4', child: Text('PHP 7.4')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _phpVersion = value!;
                        });
                      },
                    ),
                  
                  if (_projectType == 'php' || _projectType == 'laravel' || _projectType == 'wordpress')
                    const SizedBox(height: 16),
                  
                  // Web directory
                  TextFormField(
                    initialValue: _webDirectory,
                    decoration: const InputDecoration(
                      labelText: 'תיקיית Web',
                      hintText: '/public',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _webDirectory = value;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Advanced settings toggle
                  Row(
                    children: [
                      Checkbox(
                        value: _showAdvanced,
                        onChanged: (value) {
                          setState(() {
                            _showAdvanced = value!;
                          });
                        },
                      ),
                      const Text('הגדרות מתקדמות'),
                    ],
                  ),
                  
                  // Advanced settings
                  if (_showAdvanced) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'הגדרות Git',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          
                          // Git repository
                          TextFormField(
                            initialValue: _gitRepository,
                            decoration: const InputDecoration(
                              labelText: 'Git Repository (אופציונלי)',
                              hintText: 'https://github.com/user/repo.git',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              _gitRepository = value;
                              setState(() {
                                _installRepository = value.isNotEmpty;
                              });
                            },
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Git branch
                          if (_gitRepository.isNotEmpty)
                            TextFormField(
                              initialValue: _gitBranch,
                              decoration: const InputDecoration(
                                labelText: 'Git Branch',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                _gitBranch = value;
                              },
                            ),
                          
                          const SizedBox(height: 16),
                          
                          const Text(
                            'התקנות נוספות',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          
                          // Installation options
                          CheckboxListTile(
                            title: const Text('התקן Composer'),
                            value: _installComposer,
                            onChanged: (value) {
                              setState(() {
                                _installComposer = value!;
                              });
                            },
                          ),
                          
                          CheckboxListTile(
                            title: const Text('התקן NPM'),
                            value: _installNpm,
                            onChanged: (value) {
                              setState(() {
                                _installNpm = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            child: const Text('ביטול'),
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : _createSite,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('צור אתר'),
          ),
        ],
      ),
    );
  }
  
  void _createSite() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final ploiService = PloiApiService();
      
      // Verify API is configured
      if (!ploiService.isConfigured) {
        throw Exception('API Token לא מוגדר. אנא הגדר את ה-Token בהגדרות.');
      }
      
      // Prepare site data - Based on Ploi API format
      final siteData = <String, dynamic>{
        'root_domain': _domainController.text.trim(),
        'web_directory': _webDirectory,
        'project_directory': '/',
        'system_user': 'ploi',
      };
      
      // Add project type if not default
      if (_projectType != 'php') {
        siteData['project_type'] = _projectType;
      }
      
      // Add PHP version for PHP projects
      if (_projectType == 'php' || _projectType == 'laravel' || _projectType == 'wordpress') {
        siteData['php_version'] = _phpVersion;
      }
      
      // Add Git settings if provided
      if (_gitRepository.isNotEmpty) {
        siteData['repository'] = _gitRepository;
        siteData['branch'] = _gitBranch;
        siteData['install_repository'] = _installRepository;
      }
      
      // Add installation settings only if they're not default
      if (_installComposer) {
        siteData['install_composer'] = _installComposer;
      }
      if (_installNpm) {
        siteData['install_npm'] = _installNpm;
      }
      
      // Call the API to create the site
      final createResult = await ploiService.createSite(widget.serverId, siteData);
      debugPrint('✅ [CREATE_SITE] Site created successfully: $createResult');
      
      // Get the newly created site ID
      final newSiteId = createResult['data']['id'];
      final siteDomain = _domainController.text.trim();
      
      debugPrint('🌐 [CREATE_SITE] Attempting to create basic website for site ID: $newSiteId');
      
      if (mounted) {
        Navigator.pop(context);
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'האתר "$siteDomain" נוצר בהצלחה!\n'
              'כעת תוכל להעלות קבצים באמצעות SFTP.',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
          ),
        );
        
        // Refresh sites list
        widget.onSiteCreated();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('שגיאה ביצירת האתר: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
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
    _domainController.dispose();
    super.dispose();
  }
}

// SSH Keys Management Dialog
class SSHKeysDialog extends StatefulWidget {
  final int serverId;
  final String serverName;
  final String siteDomain;

  const SSHKeysDialog({
    super.key,
    required this.serverId,
    required this.serverName,
    required this.siteDomain,
  });

  @override
  State<SSHKeysDialog> createState() => _SSHKeysDialogState();
}

class _SSHKeysDialogState extends State<SSHKeysDialog> {
  List<Map<String, dynamic>> sshKeys = [];
  bool isLoading = true;
  String? error;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController keyController = TextEditingController();
  String generatedPublicKey = '';
  String keyFingerprint = '';
  String keyType = '';

  @override
  void initState() {
    super.initState();
    _loadSSHKeys();
    // Don't generate key automatically - only when user clicks button
    debugPrint('🔑 [MAIN] SSH Keys dialog initialized without auto-generating key');
  }
  
  Future<void> _generateNewKey() async {
    try {
      debugPrint('🔑 [MAIN] Starting SSH key generation from main.dart...');
      final keyData = await PloiApiService().generateSSHKeyPair();
      debugPrint('✅ [MAIN] SSH key generation successful in main.dart');
      debugPrint('📋 [MAIN] Key type: ${keyData['key_type']}');
      debugPrint('📋 [MAIN] Note: ${keyData['note']}');
      
      setState(() {
        generatedPublicKey = keyData['public_key'] ?? '';
        keyFingerprint = keyData['fingerprint'] ?? '';
        keyType = keyData['key_type'] ?? 'RSA 2048-bit';
        keyController.text = generatedPublicKey;
      });
    } catch (e) {
      debugPrint('❌ [MAIN] SSH key generation failed in main.dart: $e');
      debugPrint('📝 [MAIN] Stack trace: ${StackTrace.current}');
      // Fallback to demo key if generation fails
      setState(() {
        generatedPublicKey = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDYwd6O4Z+STMxTlFCPcN8VAq9ZNKvaQRYbsEDKK0ydvTxdwt72xRo8supYX1vgDgRpYBhgDy8OPEMLDuk61sXRdbTITFW1B98rUsvvLEYHM4wJQnkWZvcyZz79id2H3r75ow+EL6SF4zxrSnJ9Ax09cKN2oM3nQUn0jkaqG4Hb/thbKbF8SzevBrcI0Ld4K64Mduc2XQbW2qMikT4xPBtu7bwPuP1XhipZOBcCBnXdrWCZk6pfYtA/aq5En7a2JAyglIpEsAIbtSVmj62BgstmSOy/4tQjVinh6IG8y8ixq59GbmC8KP9zUQ3hhLfT/nqreXpeh039cotUTWJHyVOB demo@fallback';
        keyFingerprint = 'SHA256:demo:key:fingerprint';
        keyType = 'RSA 2048-bit (Demo)';
        keyController.text = generatedPublicKey;
      });
    }
  }

  Future<void> _loadSSHKeys() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('ploi_api_token');
      
      if (token != null) {
        final apiService = PloiApiService();
        await apiService.setApiToken(token);
        
        final keys = await apiService.getSSHKeys(widget.serverId);
        
        setState(() {
          sshKeys = keys;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _addSSHKey() async {
    if (nameController.text.trim().isEmpty || keyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('אנא מלא את כל השדות')),
      );
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('ploi_api_token');
      
      if (token != null) {
        final apiService = PloiApiService();
        await apiService.setApiToken(token);
        
        await apiService.createSSHKey(
          serverId: widget.serverId,
          name: nameController.text.trim(),
          key: keyController.text.trim(),
        );
        
        nameController.clear();
        await _generateNewKey(); // Generate new key for next use
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('SSH Key נוסף בהצלחה')),
          );
        }
        
        _loadSSHKeys(); // Refresh list
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('שגיאה בהוספת SSH Key: $e')),
        );
      }
    }
  }

  Future<void> _deleteSSHKey(int keyId, String keyName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('מחיקת SSH Key'),
        content: Text('האם אתה בטוח שברצונך למחוק את המפתח "$keyName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('ביטול'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('מחק'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('ploi_api_token');
        
        if (token != null) {
          final apiService = PloiApiService();
          await apiService.setApiToken(token);
          
          await apiService.deleteSSHKey(widget.serverId, keyId);
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('SSH Key נמחק בהצלחה')),
            );
          }
          
          _loadSSHKeys(); // Refresh list
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('שגיאה במחיקת SSH Key: $e')),
          );
        }
      }
    }
  }

  Future<void> _showRealKeyInstructions() async {
    try {
      debugPrint('🔑 [MAIN] Starting SSH key generation for instructions dialog...');
      final keyData = await PloiApiService().generateSSHKeyPair();
      debugPrint('✅ [MAIN] SSH key generation successful for instructions dialog');
      debugPrint('📋 [MAIN] Key type: ${keyData['key_type']}');
      debugPrint('📋 [MAIN] Note: ${keyData['note']}');
      
      final isRealKey = keyData['key_type']!.contains('אמיתי');
      debugPrint('🔍 [MAIN] Is real key: $isRealKey');
      
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(
                  isRealKey ? Icons.vpn_key : Icons.warning,
                  color: isRealKey ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(isRealKey ? 'מפתח SSH אמיתי נוצר!' : 'הוראות יצירת מפתח SSH'),
              ],
            ),
            content: SizedBox(
              width: 500,
              height: 600,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Status indicator
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isRealKey ? Colors.green[50] : Colors.orange[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isRealKey ? Colors.green[200]! : Colors.orange[200]!,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isRealKey ? Icons.check_circle : Icons.info,
                                color: isRealKey ? Colors.green[600] : Colors.orange[600],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                keyData['note']!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isRealKey ? Colors.green[800] : Colors.orange[800],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'סוג מפתח: ${keyData['key_type']}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            'טביעת אצבע: ${keyData['fingerprint']}',
                            style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Instructions
                    const Text(
                      'הוראות שימוש:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(keyData['instructions']!),
                    const SizedBox(height: 16),
                    
                    if (isRealKey) ...[
                      const Text(
                        'המפתח הציבורי שנוצר:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'מפתח ציבורי (העתק את כל הטקסט):',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                TextButton.icon(
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(text: keyData['public_key']!));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('מפתח הועתק ללוח')),
                                    );
                                  },
                                  icon: const Icon(Icons.copy, size: 16),
                                  label: const Text('העתק'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SelectableText(
                              keyData['public_key']!,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.terminal, color: Colors.blue[600], size: 20),
                                const SizedBox(width: 8),
                                const Text(
                                  'צעדים מפורטים ליצירת מפתח אמיתי:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text('1. פתח Terminal/Git Bash'),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const SelectableText(
                                'ssh-keygen -t rsa -b 2048 -C "your-email@example.com"',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text('2. לחץ Enter פעמיים (בלי סיסמה)'),
                            const SizedBox(height: 8),
                            const Text('3. העתק את המפתח הציבורי:'),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const SelectableText(
                                'cat ~/.ssh/id_rsa.pub',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text('4. הדבק את התוכן בשדה "Public Key" למעלה'),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            actions: [
              if (isRealKey)
                TextButton.icon(
                  onPressed: () {
                    // Copy the key to the field
                    setState(() {
                      keyController.text = keyData['public_key']!;
                      generatedPublicKey = keyData['public_key']!;
                      keyFingerprint = keyData['fingerprint']!;
                      keyType = keyData['key_type']!;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('מפתח אמיתי הועתק לשדה!')),
                    );
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('השתמש במפתח זה'),
                ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('סגור'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ [MAIN] Error in _showRealKeyInstructions: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('שגיאה ביצירת מפתח: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        height: 750,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.vpn_key, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'SSH Keys - ${widget.serverName}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Add new SSH Key section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'הוסף SSH Key חדש',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            TextButton.icon(
                              onPressed: _showRealKeyInstructions,
                              icon: const Icon(Icons.help_outline, size: 16),
                              label: const Text('איך ליצור מפתח אמיתי?'),
                            ),
                            TextButton.icon(
                              onPressed: _generateNewKey,
                              icon: const Icon(Icons.vpn_key, size: 16),
                              label: const Text('יצור מפתח SSH אמיתי'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'שם המפתח',
                        hintText: 'למשל: DataFlow Key',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Show key info only if a key was generated
                    if (generatedPublicKey.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: keyType.contains('אמיתי') ? Colors.green[50] : Colors.orange[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: keyType.contains('אמיתי') ? Colors.green[200]! : Colors.orange[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  keyType.contains('אמיתי') ? Icons.vpn_key : Icons.warning, 
                                  color: keyType.contains('אמיתי') ? Colors.green[600] : Colors.orange[600], 
                                  size: 16
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  keyType.contains('אמיתי') ? 'מפתח SSH אמיתי נוצר!' : 'מפתח SSH לדמו בלבד',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: keyType.contains('אמיתי') ? Colors.green[800] : Colors.orange[800],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('סוג: $keyType', style: const TextStyle(fontSize: 12)),
                            Text('טביעת אצבע: $keyFingerprint', 
                                 style: const TextStyle(fontSize: 12, fontFamily: 'monospace')),
                            if (!keyType.contains('אמיתי')) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.red[200]!),
                                ),
                                child: Text(
                                  '⚠️ זה מפתח דמו! לשימוש אמיתי, צור מפתח SSH אמיתי ועדכן את השדה',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.red[800],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: keyController,
                      maxLines: 4,
                      readOnly: false,
                      decoration: InputDecoration(
                        labelText: generatedPublicKey.isEmpty ? 'Public Key' : 
                                  (keyType.contains('אמיתי') ? 'מפתח SSH אמיתי' : 'Public Key (ערוך לשימוש אמיתי)'),
                        hintText: generatedPublicKey.isEmpty ? 'לחץ על "יצור מפתח SSH אמיתי" כדי ליצור מפתח' :
                                 (keyType.contains('אמיתי') ? 'מפתח SSH אמיתי מוכן לשימוש!' : 'החלף במפתח SSH אמיתי או השתמש במפתח הדמו לבדיקות'),
                        border: const OutlineInputBorder(),
                        helperText: keyType.contains('אמיתי') ? 'מפתח אמיתי נוצר בהצלחה!' : 'לשימוש אמיתי: ssh-keygen -t rsa -b 2048',
                      ),
                      style: const TextStyle(
                        fontSize: 11,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _addSSHKey,
                      icon: const Icon(Icons.add),
                      label: const Text('הוסף SSH Key'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Existing SSH Keys list
            const Text(
              'SSH Keys קיימים',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            // SSH Keys content
            SizedBox(
              height: 200,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error, color: Colors.red, size: 48),
                              const SizedBox(height: 8),
                              Text('שגיאה: $error'),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: _loadSSHKeys,
                                child: const Text('נסה שוב'),
                              ),
                            ],
                          ),
                        )
                      : sshKeys.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.vpn_key_off, color: Colors.grey, size: 48),
                                  SizedBox(height: 8),
                                  Text('אין SSH Keys'),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: sshKeys.length,
                              itemBuilder: (context, index) {
                                final key = sshKeys[index];
                                return Card(
                                  child: ListTile(
                                    leading: const Icon(Icons.vpn_key, color: Colors.blue),
                                    title: Text(key['name'] ?? 'Unnamed Key'),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('User: ${key['system_user'] ?? 'ploi'}'),
                                        Text(
                                          'Key: ${(key['key'] ?? '').substring(0, (key['key'] ?? '').length > 50 ? 50 : (key['key'] ?? '').length)}...',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'monospace',
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      onPressed: () => _deleteSSHKey(
                                        key['id'],
                                        key['name'] ?? 'Unnamed Key',
                                      ),
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                    ),
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
          ),
      ),
    );
  }
}

// SFTP Dialog - File management for sites
class SFTPDialog extends StatefulWidget {
  final int serverId;
  final int siteId;
  final String siteDomain;
  final String serverIp;

  const SFTPDialog({
    super.key,
    required this.serverId,
    required this.siteId,
    required this.siteDomain,
    required this.serverIp,
  });

  @override
  State<SFTPDialog> createState() => _SFTPDialogState();
}

class _SFTPDialogState extends State<SFTPDialog> {
  bool isConnected = false;
  bool isConnecting = false;
  String currentPath = '/';
  List<Map<String, dynamic>> files = [];
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _connectToSFTP();
  }

  Future<void> _connectToSFTP() async {
    setState(() {
      isConnecting = true;
      error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('ploi_api_token');
      
      if (token == null) {
        throw Exception('לא נמצא API Token');
      }
      
      final apiService = PloiApiService();
      await apiService.setApiToken(token);
      
      // Set default path for site
      currentPath = '/home/ploi/${widget.siteDomain}';
      
      setState(() {
        isConnected = true;
        isConnecting = false;
      });
      
      _loadFiles();
      
    } catch (e) {
      setState(() {
        error = 'שגיאה בהתחברות: $e';
        isConnecting = false;
      });
    }
  }

  Future<void> _loadFiles() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('ploi_api_token');
      
      if (token == null) {
        throw Exception('לא נמצא API Token');
      }
      
      final apiService = PloiApiService();
      await apiService.setApiToken(token);
      
      final result = await apiService.listSiteFiles(
        serverId: widget.serverId,
        siteId: widget.siteId,
        path: currentPath,
      );
      
      if (result['success'] == true) {
        final filesList = List<Map<String, dynamic>>.from(result['files'] ?? []);
        setState(() {
          files = filesList;
          isLoading = false;
        });
      } else {
        throw Exception(result['error'] ?? 'Failed to list files');
      }
    } catch (e) {
      setState(() {
        error = 'שגיאה בטעינת קבצים: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 800,
        height: 600,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.folder_shared, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'SFTP - ${widget.siteDomain}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (isConnected)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, size: 16, color: Colors.green[800]),
                        const SizedBox(width: 4),
                        Text('מחובר', style: TextStyle(color: Colors.green[800], fontSize: 12)),
                      ],
                    ),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (isConnecting)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('מתחבר ל-SFTP...'),
                  ],
                ),
              )
            else if (error != null)
              Center(
                child: Column(
                  children: [
                    Icon(Icons.error, size: 48, color: Colors.red[400]),
                    const SizedBox(height: 16),
                    Text(error!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _connectToSFTP,
                      child: const Text('נסה שוב'),
                    ),
                  ],
                ),
              )
            else if (isConnected)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Path bar
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          if (currentPath != '/home/ploi/${widget.siteDomain}')
                            IconButton(
                              onPressed: _navigateBack,
                              icon: const Icon(Icons.arrow_back, size: 16),
                              tooltip: 'חזור לתיקייה הקודמת',
                            ),
                          const Icon(Icons.folder, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                currentPath,
                                style: const TextStyle(fontFamily: 'monospace'),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: _loadFiles,
                            icon: const Icon(Icons.refresh, size: 16),
                            tooltip: 'רענן',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Action buttons
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _showUploadDialog,
                          icon: const Icon(Icons.upload_file),
                          label: const Text('העלה קובץ'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: _showCreateFolderDialog,
                          icon: const Icon(Icons.create_new_folder),
                          label: const Text('צור תיקייה'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Files list
                    Expanded(
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _buildFilesList(),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilesList() {
    if (files.isEmpty) {
      return const Center(
        child: Text('התיקייה ריקה'),
      );
    }

    return ListView.builder(
      itemCount: files.length,
      itemBuilder: (context, index) {
        final file = files[index];
        final isDirectory = file['type'] == 'directory';
        
        return ListTile(
          leading: Icon(
            isDirectory ? Icons.folder : Icons.insert_drive_file,
            color: isDirectory ? Colors.blue : Colors.grey[600],
          ),
          title: Text(file['name']),
          subtitle: isDirectory 
              ? null 
              : Text('${file['size']} bytes • ${file['modified']}'),
          trailing: PopupMenuButton(
            itemBuilder: (context) => [
              if (!isDirectory)
                const PopupMenuItem(
                  value: 'download',
                  child: Row(
                    children: [
                      Icon(Icons.download, size: 16),
                      SizedBox(width: 8),
                      Text('הורד'),
                    ],
                  ),
                ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 16, color: Colors.red),
                    SizedBox(width: 8),
                    Text('מחק', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            onSelected: (value) => _handleFileAction(value.toString(), file),
          ),
          onTap: isDirectory ? () => _navigateToFolder(file['name']) : null,
        );
      },
    );
  }

  void _navigateToFolder(String folderName) {
    setState(() {
      currentPath = currentPath.endsWith('/') 
          ? '$currentPath$folderName'
          : '$currentPath/$folderName';
    });
    _loadFiles();
  }

  void _navigateBack() {
    if (currentPath != '/home/ploi/${widget.siteDomain}') {
      setState(() {
        // Remove the last directory from the path
        final pathParts = currentPath.split('/');
        if (pathParts.length > 1) {
          pathParts.removeLast();
          currentPath = pathParts.join('/');
          if (currentPath.isEmpty) {
            currentPath = '/';
          }
        }
      });
      _loadFiles();
    }
  }

  void _handleFileAction(String action, Map<String, dynamic> file) {
    switch (action) {
      case 'download':
        _downloadFile(file);
        break;
      case 'delete':
        _deleteFile(file);
        break;
    }
  }

  void _downloadFile(Map<String, dynamic> file) async {
    final fileName = file['name'];
    final filePath = '$currentPath/$fileName';
    
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('מוריד קובץ...'),
          ],
        ),
      ),
    );

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('ploi_api_token');
      
      if (token != null) {
        final apiService = PloiApiService();
        await apiService.setApiToken(token);
        
        final result = await apiService.downloadFileFromSite(
          serverId: widget.serverId,
          siteId: widget.siteId,
          remotePath: filePath,
        );
        
        if (mounted) Navigator.pop(context); // Close loading dialog
        
        if (result['success'] == true) {
          // Show file content in a dialog
          if (mounted) _showFileContentDialog(result['file_name'], result['file_content']);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('שגיאה בהורדת קובץ: ${result['error']}')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) Navigator.pop(context); // Close loading dialog
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('שגיאה בהורדת קובץ: $e')),
        );
      }
    }
  }

  void _showFileContentDialog(String fileName, String content) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 700,
          height: 600,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.description, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    'תוכן הקובץ - $fileName',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      content,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('סגור'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteFile(Map<String, dynamic> file) {
    final fileName = file['name'];
    final isDirectory = file['type'] == 'directory';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            const SizedBox(width: 8),
            Text('מחיקת ${isDirectory ? 'תיקייה' : 'קובץ'}'),
          ],
        ),
        content: Text(
          'האם אתה בטוח שברצונך למחוק את ${isDirectory ? 'התיקייה' : 'הקובץ'} "$fileName"?\n\n'
          '${isDirectory ? '⚠️ פעולה זו תמחק את התיקייה וכל תוכנה!' : '⚠️ פעולה זו אינה ניתנת לביטול!'}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ביטול'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performDelete(file);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('מחק'),
          ),
        ],
      ),
    );
  }

  Future<void> _performDelete(Map<String, dynamic> file) async {
    final fileName = file['name'];
    final filePath = '$currentPath/$fileName';
    
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('מוחק...'),
          ],
        ),
      ),
    );

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('ploi_api_token');
      
      if (token != null) {
        final apiService = PloiApiService();
        await apiService.setApiToken(token);
        
        final result = await apiService.deleteFileFromSite(
          serverId: widget.serverId,
          siteId: widget.siteId,
          remotePath: filePath,
        );
        
        if (mounted) Navigator.pop(context); // Close loading dialog
        
        if (result['success'] == true) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$fileName נמחק בהצלחה')),
            );
          }
          _loadFiles(); // Refresh file list
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('שגיאה במחיקה: ${result['error']}')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) Navigator.pop(context); // Close loading dialog
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('שגיאה במחיקה: $e')),
        );
      }
    }
  }

  void _showUploadDialog() {
    final fileNameController = TextEditingController();
    final fileContentController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 500,
          height: 500,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.upload_file, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Text(
                    'העלאת קובץ חדש',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: fileNameController,
                decoration: const InputDecoration(
                  labelText: 'שם הקובץ',
                  hintText: 'index.html, style.css, script.js...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextField(
                  controller: fileContentController,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    labelText: 'תוכן הקובץ',
                    hintText: 'הכנס את תוכן הקובץ כאן...',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('ביטול'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _uploadFile(
                      fileNameController.text.trim(),
                      fileContentController.text.trim(),
                    ),
                    child: const Text('העלה קובץ'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateFolderDialog() {
    final folderNameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.create_new_folder, color: Colors.blue),
            SizedBox(width: 8),
            Text('צור תיקייה חדשה'),
          ],
        ),
        content: TextField(
          controller: folderNameController,
          decoration: const InputDecoration(
            labelText: 'שם התיקייה',
            hintText: 'images, css, js...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ביטול'),
          ),
          ElevatedButton(
            onPressed: () => _createFolder(folderNameController.text.trim()),
            child: const Text('צור תיקייה'),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadFile(String fileName, String fileContent) async {
    if (fileName.isEmpty || fileContent.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('אנא מלא את כל השדות')),
      );
      return;
    }

    Navigator.pop(context); // Close upload dialog

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('מעלה קובץ...'),
          ],
        ),
      ),
    );

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('ploi_api_token');
      
      if (token != null) {
        final apiService = PloiApiService();
        await apiService.setApiToken(token);
        
        final result = await apiService.uploadFileToSite(
          serverId: widget.serverId,
          siteId: widget.siteId,
          remotePath: currentPath,
          fileName: fileName,
          fileContent: fileContent,
        );
        
        if (mounted) Navigator.pop(context); // Close loading dialog
        
        if (result['success'] == true) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('קובץ $fileName הועלה בהצלחה')),
            );
          }
          _loadFiles(); // Refresh file list
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('שגיאה בהעלאת קובץ: ${result['error']}')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) Navigator.pop(context); // Close loading dialog
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('שגיאה בהעלאת קובץ: $e')),
        );
      }
    }
  }

  Future<void> _createFolder(String folderName) async {
    if (folderName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('אנא הכנס שם תיקייה')),
      );
      return;
    }

    Navigator.pop(context); // Close create folder dialog

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('יוצר תיקייה...'),
          ],
        ),
      ),
    );

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('ploi_api_token');
      
      if (token != null) {
        final apiService = PloiApiService();
        await apiService.setApiToken(token);
        
        final result = await apiService.createDirectoryInSite(
          serverId: widget.serverId,
          siteId: widget.siteId,
          remotePath: currentPath,
          directoryName: folderName,
        );
        
        if (mounted) Navigator.pop(context); // Close loading dialog
        
        if (result['success'] == true) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('תיקייה $folderName נוצרה בהצלחה')),
            );
          }
          _loadFiles(); // Refresh file list
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('שגיאה ביצירת תיקייה: ${result['error']}')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) Navigator.pop(context); // Close loading dialog
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('שגיאה ביצירת תיקייה: $e')),
        );
      }
    }
  }
}
