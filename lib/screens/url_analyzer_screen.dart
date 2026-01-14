import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import '../config/api_keys.dart';

const Color emeraldColor = Color(0xFF00C853);
const Color sportingbetBlue = Color(0xFF1E3A5F);

/// URL Analyzer Screen
/// Agent 1: Node.js (Screenshot)
/// Agent 2: Flutter calls Gemini directly (same as main.dart!)
class UrlAnalyzerScreen extends StatefulWidget {
  const UrlAnalyzerScreen({super.key});

  @override
  State<UrlAnalyzerScreen> createState() => _UrlAnalyzerScreenState();
}

class _UrlAnalyzerScreenState extends State<UrlAnalyzerScreen> {
  final TextEditingController _urlController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  String? _statusMessage;
  Uint8List? _resultImageBytes;

  String get _baseUrl {
    if (kIsWeb) return 'http://localhost:3000';
    try {
      if (Platform.isAndroid) return 'http://10.0.2.2:3000';
    } catch (e) {}
    return 'http://localhost:3000';
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _analyzeUrl() async {
    final url = _urlController.text.trim();
    
    if (url.isEmpty) {
      setState(() => _errorMessage = 'Please enter a URL');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _resultImageBytes = null;
      _statusMessage = '🔍 Agent 1: Taking screenshot...';
    });

    try {
      // AGENT 1: Get screenshot from Node.js
      print('📸 Getting screenshot from backend...');
      final screenshotResponse = await http.post(
        Uri.parse('$_baseUrl/screenshot'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'url': url}),
      ).timeout(const Duration(seconds: 60));

      if (screenshotResponse.statusCode != 200) {
        final error = jsonDecode(screenshotResponse.body);
        throw Exception(error['error'] ?? 'Screenshot failed');
      }

      final screenshotData = jsonDecode(screenshotResponse.body);
      final screenshotBase64 = screenshotData['image'] as String;
      print('✅ Screenshot received');

      // AGENT 2: Call Gemini directly from Flutter (SAME AS main.dart!)
      setState(() => _statusMessage = '🤖 Agent 2: Gemini adding banner...');
      
      final resultBytes = await _callGeminiForBanner(screenshotBase64);
      
      setState(() {
        _resultImageBytes = resultBytes;
      });

    } catch (e) {
      print('❌ Error: $e');
      setState(() => _errorMessage = e.toString().replaceAll('Exception: ', ''));
    } finally {
      setState(() {
        _isLoading = false;
        _statusMessage = null;
      });
    }
  }

  /// Call Gemini API - EXACT SAME CODE AS main.dart!
  Future<Uint8List> _callGeminiForBanner(String base64Image) async {
    const apiKey = geminiApiKey;
    
    final prompt = '''
Add a "SPORTINGBET" banner button to this mobile app screenshot.

⚠️ CRITICAL: DO NOT DELETE ANY CONTENT! Only ADD the banner. ⚠️

STEP 1 - ANALYZE THE SCREEN:
First, identify what's on the screen:
- What type of app is this? (sports, betting, news, etc.)
- What sections/categories exist?
- Where are natural "break points" between content?
- What has the user likely already seen vs. what's coming next?

STEP 2 - STRATEGIC PLACEMENT DECISION:
Choose the BEST location based on conversion psychology:
- AFTER a completed event (user finished consuming that content)
- BEFORE a new category starts (natural pause point)
- Between leagues/sections (users expect breaks here)
- NOT in the middle of active content the user is reading
- NOT covering betting odds or important information

STEP 3 - INSERT THE BANNER:
BUTTON DESIGN (Sportingbet):
- Background: Blue gradient (#1E3A5F)
- Text: "Sportingbet - Bet Now!" in WHITE, bold
- Style: Professional sports betting look
- Include a small sports icon or betting symbol if possible

BANNER DESIGN:
- Full width, height: 50-70px
- Rounded corners (10px)
- Text: "Sportingbet - Bet Now!" ⚽
- Must look professional and native to the app

ABSOLUTE RULES:
✅ ADD banner at a strategic location
✅ PUSH elements down if needed
✅ Keep ALL original content visible
❌ NEVER delete any element
❌ NEVER cover active content
❌ NEVER place inside a card or section

Return the modified screenshot with the banner strategically placed.
''';

    final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-3-pro-image-preview:generateContent?key=$apiKey');

    final requestBody = {
      'contents': [
        {
          'parts': [
            {'text': prompt},
            {
              'inline_data': {
                'mime_type': 'image/png',
                'data': base64Image,
              }
            }
          ]
        }
      ],
      'generationConfig': {
        'response_modalities': ['IMAGE'],
        'temperature': 0.1,
      }
    };

    print('📤 Calling Gemini API...');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    print('📥 Response: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['candidates'] != null &&
          data['candidates'].isNotEmpty &&
          data['candidates'][0]['content'] != null &&
          data['candidates'][0]['content']['parts'] != null &&
          data['candidates'][0]['content']['parts'].isNotEmpty) {

        final parts = data['candidates'][0]['content']['parts'];

        for (var part in parts) {
          final inlineData = part['inlineData'] ?? part['inline_data'];
          if (inlineData != null) {
            final mimeType = inlineData['mimeType'] ?? inlineData['mime_type'];
            final imageDataStr = inlineData['data'];

            if (mimeType != null && mimeType.startsWith('image/') && imageDataStr != null) {
              print('✅ Got image from Gemini!');
              return base64Decode(imageDataStr);
            }
          }
        }

        // Check for text error
        for (var part in parts) {
          if (part['text'] != null) {
            throw Exception('Gemini returned text: ${part['text']}');
          }
        }
      }
      throw Exception('No image in Gemini response');
    } else {
      throw Exception('Gemini API Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Row(
          children: [
            Icon(Icons.analytics, color: emeraldColor),
            SizedBox(width: 8),
            Text('URL Analyzer', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.withOpacity(0.2), Colors.purple.withOpacity(0.1)],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🤖 Architecture', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 8),
                  Row(children: [
                    Icon(Icons.camera_alt, color: Colors.orange, size: 16),
                    SizedBox(width: 8),
                    Text('Agent 1: Node.js + Puppeteer', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  ]),
                  SizedBox(height: 4),
                  Row(children: [
                    Icon(Icons.auto_awesome, color: Colors.purple, size: 16),
                    SizedBox(width: 8),
                    Expanded(child: Text('Agent 2: Flutter → Gemini (same as main!)', style: TextStyle(color: Colors.white70, fontSize: 13))),
                  ]),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // URL Input
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🔍 Enter URL', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _urlController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'www.example.com',
                      hintStyle: const TextStyle(color: Colors.white38),
                      prefixIcon: const Icon(Icons.link, color: Colors.white54),
                      filled: true,
                      fillColor: Colors.black26,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                    onSubmitted: (_) => _analyzeUrl(),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _analyzeUrl,
                      icon: _isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.search),
                      label: Text(_isLoading ? 'Processing...' : 'Scan & Add Banner'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: sportingbetBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Error
            if (_errorMessage != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 12),
                    Expanded(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red))),
                  ],
                ),
              ),
            ],

            // Loading
            if (_isLoading && _statusMessage != null) ...[
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: sportingbetBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const CircularProgressIndicator(color: Colors.white),
                    const SizedBox(height: 20),
                    Text(_statusMessage!, style: const TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center),
                  ],
                ),
              ),
            ],

            // Result
            if (_resultImageBytes != null) ...[
              const SizedBox(height: 30),
              const Row(
                children: [
                  Icon(Icons.check_circle, color: emeraldColor),
                  SizedBox(width: 8),
                  Text('Result', style: TextStyle(color: emeraldColor, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: emeraldColor, width: 2),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.memory(_resultImageBytes!, fit: BoxFit.fitWidth),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () => setState(() => _resultImageBytes = null),
                icon: const Icon(Icons.refresh),
                label: const Text('Scan Another URL'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  side: const BorderSide(color: Colors.white24),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
