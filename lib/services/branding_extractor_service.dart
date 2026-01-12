import 'dart:convert';
import 'package:http/http.dart' as http;

class BrandingExtractorService {
  static const String _geminiApiKey = 'AIzaSyAGAD-twAvL-6UFwvI4aFHCtcsrI1poUrg';
  
  // חילוץ מיתוג מאתר באמצעות AI
  static Future<Map<String, dynamic>?> extractBrandingFromUrl(String url) async {
    print('🔍 Starting branding extraction for URL: $url');
    
    // וידוא שה-URL תקין
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      throw Exception('URL must start with http:// or https://');
    }

    try {
      print('📡 Calling AI to analyze branding...');
      final brandingData = await _analyzeBrandingWithAI(url);
      
      if (brandingData != null) {
        print('✅ Branding extracted successfully: $brandingData');
      } else {
        print('⚠️ Branding data is null');
      }
      
      return brandingData;
    } catch (e) {
      print('❌ Error extracting branding: $e');
      rethrow;
    }
  }

  // ניתוח מיתוג באמצעות Gemini AI
  static Future<Map<String, dynamic>?> _analyzeBrandingWithAI(String url) async {
    try {
      final geminiUrl = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent?key=$_geminiApiKey');

      final prompt = '''
Analyze this website URL and extract branding information: $url

Extract the branding information from the website.

Return ONLY valid JSON:
{
  "name": "Brand Name (extract from domain or visible text)",
  "primary_color_hex": "#003366 (main brand color from CSS/design)",
  "secondary_color_hex": "#10B981 (accent/CTA color)",
  "logo_url": "https://example.com/logo.png (if found, otherwise null)",
  "description": "Brief description of the brand"
}

CRITICAL RULES:
1. Extract brand name from domain name (e.g., sportingbet.com -> "Sportingbet")

2. Find primary color from:
   - CSS variables (--primary-color, --brand-color)
   - Header/navigation background
   - Main brand elements
   - Common betting site colors (usually dark blue, green, or red)

3. Find secondary color from:
   - CTA buttons
   - Highlights
   - Accent elements

4. Find logo URL - if you can find a logo URL, return it. Otherwise return null.

5. If you know this brand (Sportingbet, Superbet, etc.), use your knowledge:
   - Sportingbet: primary #003366 (dark blue), secondary #10B981 (green)
   - Superbet: primary #FF0000 (red), secondary #FFFFFF (white)
   - Bet365: primary #006600 (green), secondary #FFFFFF (white)

6. Colors MUST be in hex format (#RRGGBB)
7. Return ONLY JSON, no additional text or markdown
''';

      final requestBody = {
        'contents': [{
          'parts': [{'text': prompt}]
        }],
        'generationConfig': {
          'temperature': 0.1,
          'maxOutputTokens': 1024,
        }
      };

      print('📤 Sending request to Gemini API...');
      final response = await http.post(
        geminiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      ).timeout(const Duration(seconds: 30));

      print('📥 Received response: status ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('📄 Response data keys: ${data.keys}');
        
        if (data['candidates'] != null &&
            data['candidates'].isNotEmpty &&
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          
          String text = data['candidates'][0]['content']['parts'][0]['text'];
          print('📝 AI response text (first 200 chars): ${text.substring(0, text.length > 200 ? 200 : text.length)}...');
          
          text = text.replaceAll('```json', '').replaceAll('```', '').trim();
          
          // ניסיון למצוא JSON בתשובה
          final jsonMatch = RegExp(r'\{[\s\S]*\}', dotAll: true).firstMatch(text);
          if (jsonMatch == null) {
            throw Exception('No JSON found in AI response: $text');
          }
          
          final jsonStr = jsonMatch.group(0)!;
          print('🔍 Extracted JSON: $jsonStr');
          
          final result = jsonDecode(jsonStr) as Map<String, dynamic>;
          print('✅ Parsed JSON successfully');
          
          // טיפול בצבעים - וידוא שהם בפורמט Hex נכון
          String primaryColor = result['primary_color_hex'] as String? ?? '#003366';
          if (!primaryColor.startsWith('#')) {
            primaryColor = '#$primaryColor';
          }
          
          String secondaryColor = result['secondary_color_hex'] as String? ?? '#10B981';
          if (!secondaryColor.startsWith('#')) {
            secondaryColor = '#$secondaryColor';
          }
          
          return {
            'name': result['name'] as String? ?? _extractNameFromUrl(url),
            'primaryColor': primaryColor,
            'secondaryColor': secondaryColor,
            'logoUrl': result['logo_url'] as String?,
            'description': result['description'] as String? ?? '',
          };
        } else {
          throw Exception('Invalid API response format: ${response.body}');
        }
      } else {
        final errorBody = response.body;
        print('❌ API error: ${response.statusCode} - $errorBody');
        throw Exception('Gemini API error: ${response.statusCode} - ${errorBody.length > 200 ? errorBody.substring(0, 200) + "..." : errorBody}');
      }
    } catch (e, stackTrace) {
      print('❌ AI Analysis error: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  // חילוץ שם מהכתובת URL (fallback)
  static String _extractNameFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final host = uri.host;
      return host.split('.').first.toUpperCase();
    } catch (e) {
      return 'Bookmaker';
    }
  }
}
