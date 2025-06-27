import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/ploi_api_service.dart';

class ApiSettingsDialog extends StatefulWidget {
  const ApiSettingsDialog({super.key});

  @override
  State<ApiSettingsDialog> createState() => _ApiSettingsDialogState();
}

class _ApiSettingsDialogState extends State<ApiSettingsDialog> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  bool _isLoading = false;
  bool _isTestingConnection = false;
  String? _connectionStatus;
  Color? _statusColor;
  
  @override
  void initState() {
    super.initState();
    _loadCurrentToken();
  }
  
  void _loadCurrentToken() {
    final apiService = PloiApiService();
    if (apiService.apiToken != null) {
      _tokenController.text = apiService.apiToken!;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: Row(
          children: [
            Icon(Icons.api, color: Colors.blue[600]),
            const SizedBox(width: 8),
            const Text('הגדרות Ploi API'),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Instructions
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
                            'איך לקבל API Token?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '1. היכנס לחשבון Ploi שלך',
                        style: TextStyle(fontSize: 12),
                      ),
                      const Text(
                        '2. לך ל Settings > API Tokens',
                        style: TextStyle(fontSize: 12),
                      ),
                      const Text(
                        '3. צור Token חדש עם הרשאות מלאות',
                        style: TextStyle(fontSize: 12),
                      ),
                      const Text(
                        '4. העתק את ה-Token והדבק אותו כאן',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // API Token Input
                TextFormField(
                  controller: _tokenController,
                  decoration: InputDecoration(
                    labelText: 'Ploi API Token',
                    hintText: 'הדבק את ה-API Token כאן...',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.paste),
                      onPressed: _pasteFromClipboard,
                      tooltip: 'הדבק מהלוח',
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'יש להזין API Token';
                    }
                    if (value.length < 20) {
                      return 'API Token נראה קצר מדי';
                    }
                    return null;
                  },
                  obscureText: true,
                  maxLines: 1,
                ),
                
                const SizedBox(height: 16),
                
                // Test Connection Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _isTestingConnection ? null : _testConnection,
                    icon: _isTestingConnection 
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.wifi_protected_setup),
                    label: Text(_isTestingConnection ? 'בודק חיבור...' : 'בדוק חיבור'),
                  ),
                ),
                
                // Connection Status
                if (_connectionStatus != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _statusColor?.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _statusColor ?? Colors.grey),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _statusColor == Colors.green ? Icons.check_circle : Icons.error,
                          color: _statusColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _connectionStatus!,
                            style: TextStyle(
                              color: _statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                const SizedBox(height: 20),
                
                // Security Notice
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.security, color: Colors.orange[600], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'אבטחה',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[700],
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'ה-Token נשמר באופן מקומי ומוצפן במכשיר שלך בלבד.',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
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
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            child: const Text('ביטול'),
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : _saveToken,
            child: _isLoading 
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('שמור'),
          ),
        ],
      ),
    );
  }
  
  void _pasteFromClipboard() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      if (clipboardData?.text != null) {
        _tokenController.text = clipboardData!.text!.trim();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('לא ניתן להדביק מהלוח')),
        );
      }
    }
  }
  
  void _testConnection() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isTestingConnection = true;
      _connectionStatus = null;
    });
    
    try {
      final apiService = PloiApiService();
      
      // Temporarily set the token for testing
      await apiService.setApiToken(_tokenController.text.trim());
      
      // Test the connection
      final response = await apiService.testConnection();
      
      setState(() {
        _connectionStatus = 'חיבור הצליח! שלום ${response['data']?['name'] ?? 'משתמש'}';
        _statusColor = Colors.green;
      });
      
    } catch (e) {
      setState(() {
        _connectionStatus = 'חיבור נכשל: ${e.toString()}';
        _statusColor = Colors.red;
      });
    } finally {
      setState(() {
        _isTestingConnection = false;
      });
    }
  }
  
  void _saveToken() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final apiService = PloiApiService();
      await apiService.setApiToken(_tokenController.text.trim());
      
      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('API Token נשמר בהצלחה!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('שגיאה בשמירת Token: ${e.toString()}'),
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
    _tokenController.dispose();
    super.dispose();
  }
} 