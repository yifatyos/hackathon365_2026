  import 'package:flutter/material.dart';
  import 'dart:math' as math;
  import 'dart:ui' as ui;
  import 'package:image_picker/image_picker.dart';
  import 'dart:io';
  import 'dart:convert';
  import 'package:image/image.dart' as img;
  import 'package:http/http.dart' as http;
  import 'dart:ui';

  void main() {
    runApp(const BetFlowApp());
  }

  // Defining a custom emerald color to use throughout the app
  const Color emeraldColor = Color(0xFF10B981);

  class BetFlowApp extends StatelessWidget {
    const BetFlowApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'BetFlow AI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          fontFamily: 'Roboto',
        ),
        home: const LandingPage(),
      );
    }
  }

  class LandingPage extends StatefulWidget {
    const LandingPage({super.key});

    @override
    State<LandingPage> createState() => _LandingPageState();
  }

  class _LandingPageState extends State<LandingPage> with TickerProviderStateMixin {
    late AnimationController _scannerController;
    late AnimationController _floatController;

    @override
    void initState() {
      super.initState();
      // בקר עבור סורק ה-AI
      _scannerController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 3),
      )..repeat(reverse: true);

      // בקר עבור תנועה כללית של אלמנטים צפים
      _floatController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 10),
      )..repeat();
    }

    @override
    void dispose() {
      _scannerController.dispose();
      _floatController.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Stack(
          children: [
            // רקע - אפקטים של תאורה (Glow Mesh)
            const GlowBackground(),

            // אלמנטים של כסף צף
            const FloatingMoneyBackground(),

            // התוכן הראשי (גלילה)
            SingleChildScrollView(
              child: Column(
                children: [
                  const Navbar(),
                  const HeroSection(),
                  const RevenueSection(),
                  AIScannerSection(controller: _scannerController),
                  const ScreenshotAnalyzerSection(),
                  const FinalCTA(),
                  const Footer(),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  // --- רכיבי העיצוב ---

  class GlowBackground extends StatelessWidget {
    const GlowBackground({super.key});

    @override
    Widget build(BuildContext context) {
      return Stack(
        children: [
          Positioned(
            top: -200,
            left: -200,
            child: Container(
              width: 600,
              height: 600,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: emeraldColor.withOpacity(0.05),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent.withOpacity(0.03),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
        ],
      );
    }
  }

  class Navbar extends StatelessWidget {
    const Navbar({super.key});

    @override
    Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          border: const Border(bottom: BorderSide(color: Colors.white10)),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 800) {
              // Layout for smaller screens - vertical stacking
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [emeraldColor, Colors.green]),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.attach_money, color: Colors.black),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'BETFLOW',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -1),
                      ),
                      const Text(
                        ' AI',
                        style: TextStyle(fontSize: 12, color: Colors.white38),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      _navItem('How it works'),
                      _navItem('Offers'),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: const Text('Start Earning', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              );
            }
            // Layout for larger screens - horizontal
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [emeraldColor, Colors.green]),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.attach_money, color: Colors.black),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'BETFLOW',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -1),
                    ),
                    const Text(
                      ' AI',
                      style: TextStyle(fontSize: 12, color: Colors.white38),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _navItem('How it works'),
                    const SizedBox(width: 24),
                    _navItem('Offers'),
                    const SizedBox(width: 24),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Start Earning', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );
    }

    Widget _navItem(String title) {
      return Text(
        title,
        style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
      );
    }
  }

  class HeroSection extends StatelessWidget {
    const HeroSection({super.key});

    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                border: Border.all(color: Colors.white10),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: emeraldColor, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  const Text('NEXT-GEN AFFILIATE PLATFORM', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'BIG DEALS.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 80, fontWeight: FontWeight.w900, letterSpacing: -4, height: 0.9),
            ),
            const Text(
              'SMALL EFFORT.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                color: emeraldColor,
                letterSpacing: -4,
                height: 0.9,
                shadows: [Shadow(color: emeraldColor, blurRadius: 40)],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Access VIP Revshare deals instantly\nwith AI-powered optimization.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white54, height: 1.5),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: emeraldColor,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Start for Free', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(width: 10),
                  Icon(Icons.north_east, color: Colors.black),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  class RevenueSection extends StatelessWidget {
    const RevenueSection({super.key});

    @override
    Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
        child: Column(
          children: [
            const Text('WHY WE PAY MORE', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900)),
            const SizedBox(height: 60),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                _revenueCard('TRADITIONAL WAY', 'Small publishers get 15-20% max. Hard approval.', Colors.white10),
                _revenueCard('BETFLOW AI WAY', 'Direct contracts give you 30% instantly. No big traffic needed.', emeraldColor.withOpacity(0.1), isHighlight: true),
              ],
            ),
          ],
        ),
      );
    }

    Widget _revenueCard(String title, String desc, Color color, {bool isHighlight = false}) {
      return Container(
        width: 350,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: isHighlight ? emeraldColor.withOpacity(0.3) : Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: isHighlight ? emeraldColor : Colors.white38, fontWeight: FontWeight.bold, letterSpacing: 2)),
            const SizedBox(height: 15),
            Text(desc, style: const TextStyle(fontSize: 16, color: Colors.white70, height: 1.5)),
          ],
        ),
      );
    }
  }

  class AIScannerSection extends StatelessWidget {
    final AnimationController controller;
    const AIScannerSection({super.key, required this.controller});

    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  // replaced NetworkImage with a styled container to avoid host lookup error
                  Container(
                    height: 400,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Colors.white10),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.02),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.dashboard_outlined, color: Colors.white.withOpacity(0.1), size: 100),
                          const SizedBox(height: 20),
                          Text(
                            "UI DATA ANALYSIS",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.1),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // אנימציית לייזר
                  AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) {
                      return Positioned(
                        top: controller.value * 400,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            color: emeraldColor,
                            boxShadow: [BoxShadow(color: emeraldColor.withOpacity(0.8), blurRadius: 20, spreadRadius: 2)],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 60),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('AI SCANNING', style: TextStyle(color: emeraldColor, fontWeight: FontWeight.bold, letterSpacing: 2)),
                  SizedBox(height: 20),
                  Text('THE AI THAT DESIGNS FOR YOU', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, height: 1.1)),
                  SizedBox(height: 20),
                  Text(
                    "Don't guess. Our AI maps the high-conversion areas based on real user behavior.",
                    style: TextStyle(fontSize: 18, color: Colors.white54, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  class FinalCTA extends StatelessWidget {
    const FinalCTA({super.key});

    @override
    Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 150),
        child: Column(
          children: [
            const Text('START WINNING.', style: TextStyle(fontSize: 80, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 30),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              ),
              child: const Text('JOIN THE ALPHA', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      );
    }
  }

  class Footer extends StatelessWidget {
    const Footer({super.key});

    @override
    Widget build(BuildContext context) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Text('© 2026 BETFLOW AI. ALL RIGHTS RESERVED.', style: TextStyle(color: Colors.white10, letterSpacing: 2, fontSize: 10)),
      );
    }
  }

  // --- Floating Assets Animation ---

  class FloatingMoneyBackground extends StatelessWidget {
    const FloatingMoneyBackground({super.key});

    @override
    Widget build(BuildContext context) {
      return Stack(
        children: List.generate(15, (index) {
          final random = math.Random(index);
          return Positioned(
            top: random.nextDouble() * 1000,
            left: random.nextDouble() * 1000,
            child: _FloatingAsset(delay: random.nextInt(5)),
          );
        }),
      );
    }
  }

  class _FloatingAsset extends StatefulWidget {
    final int delay;
    const _FloatingAsset({required this.delay});

    @override
    State<_FloatingAsset> createState() => _FloatingAssetState();
  }

  class _FloatingAssetState extends State<_FloatingAsset> with SingleTickerProviderStateMixin {
    late AnimationController _controller;

    @override
    void initState() {
      super.initState();
      _controller = AnimationController(vsync: this, duration:  Duration(seconds: 5 + math.Random().nextInt(5)))..repeat(reverse: true);
    }

    @override
    Widget build(BuildContext context) {
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 30 * _controller.value),
            child: Transform.rotate(
              angle: 0.2 * _controller.value,
              child: Icon(
                math.Random().nextBool() ? Icons.attach_money : Icons.copyright_sharp,
                color: emeraldColor.withOpacity(0.05),
                size: 40,
              ),
            ),
          );
        },
      );
    }

    @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }
  }

  // --- AI Screenshot Analyzer Section ---

  class ScreenshotAnalyzerSection extends StatefulWidget {
    const ScreenshotAnalyzerSection({super.key});

    @override
    State<ScreenshotAnalyzerSection> createState() => _ScreenshotAnalyzerSectionState();
  }

  class _ScreenshotAnalyzerSectionState extends State<ScreenshotAnalyzerSection> {
    File? _selectedImage;
    File? _annotatedImage;
    bool _isAnalyzing = false;
    String? _buttonLocation;
    Offset? _buttonPosition;
    Size? _imageSize;
    List<Map<String, dynamic>>? _elementsToMove; // אלמנטים שצריך להזיז
    int? _buttonHeight;
    bool? _pushRequired;
    double? _pushDownFromY;
    int? _pushDownPixels;

    Future<void> _pickImage() async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image != null) {
        
        setState(() {
        _selectedImage = File(image.path);
        _annotatedImage = null;
        _buttonLocation = null;
        _buttonPosition = null;
        _elementsToMove = null;
        _buttonHeight = null;
        _pushRequired = null;
        _pushDownFromY = null;
        _pushDownPixels = null;
        });
      }
    }

    Future<void> _analyzeImage() async {
      if (_selectedImage == null) return;

      setState(() {
        _isAnalyzing = true;
      });

      try {
        // קריאה ל-AI API
        final result = await _callAIApi(_selectedImage!);
        
        if (result != null) {
          // אם המודל החזיר תמונה מוכנה (image generation)
          if (result['isImageResponse'] == true && result['imageFile'] != null) {
            setState(() {
              _annotatedImage = result['imageFile'] as File;
              _buttonLocation = 'AI generated mockup with button inserted';
            });
          } else {
            // אם המודל החזיר JSON (text response) - נמשיך עם הלוגיקה הישנה
            // עיבוד בטוח של elementsToMove
            List<Map<String, dynamic>>? elementsToMove;
            if (result['elementsToMove'] != null && result['elementsToMove'] is List) {
              try {
                elementsToMove = (result['elementsToMove'] as List)
                    .map((e) => e as Map<String, dynamic>)
                    .toList();
              } catch (e) {
                elementsToMove = [];
              }
            }
            
            setState(() {
              _buttonPosition = result['position'];
              _buttonLocation = result['description'];
              _imageSize = result['imageSize'];
              _elementsToMove = elementsToMove;
              _buttonHeight = result['buttonHeight'] as int?;
              _pushRequired = result['pushRequired'] as bool?;
              _pushDownFromY = result['pushDownFromY'] as double?;
              _pushDownPixels = result['pushDownPixels'] as int?;
            });
            
            // יצירת תמונה עם סימון
            await _createAnnotatedImage();
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isAnalyzing = false;
          });
        }
      }
    }

    Future<Map<String, dynamic>?> _callAIApi(File imageFile) async {
      try {
        const apiKey = 'AIzaSyAGAD-twAvL-6UFwvI4aFHCtcsrI1poUrg';
        
        final imageBytes = await imageFile.readAsBytes();
        final base64Image = base64Encode(imageBytes);
        
        final prompt = '''
Transform this mobile app screenshot and place a dummy banner ad button.
CRITICAL: Find a VISIBLE EMPTY GAP between two complete UI elements - NOT inside any element!
RESULT: the original screenshot with a dummy banner.


STEP-BY-STEP:

1. Identify where each UI element ENDS (bottom edge)
2. Identify where the next element STARTS (top edge)
3. Find the EMPTY SPACE between these edges (background color only, NO content)
4. realign and resize the elements if neceesary, so that the banner has enough space and it will not override any existing component
5. Place the dummy green banner inside the empty space
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
        
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestBody),
        );
        
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          
          // לוג לדיבוג
          print('📥 API Response: ${response.body.length > 500 ? response.body.substring(0, 500) + "..." : response.body}');
          
          if (data['candidates'] != null && 
              data['candidates'].isNotEmpty &&
              data['candidates'][0]['content'] != null &&
              data['candidates'][0]['content']['parts'] != null &&
              data['candidates'][0]['content']['parts'].isNotEmpty) {
            
            final parts = data['candidates'][0]['content']['parts'];
            
            // לוג של המבנה
            print('📦 Parts structure: ${parts.map((p) => p.keys.toList()).toList()}');
            
            // בדיקה אם יש תמונה בתשובה (image generation)
            // API יכול להחזיר inlineData (camelCase) או inline_data (snake_case)
            for (var part in parts) {
              // בדיקת שני הפורמטים
              final inlineData = part['inlineData'] ?? part['inline_data'];
              if (inlineData != null) {
                final mimeType = inlineData['mimeType'] ?? inlineData['mime_type'];
                final imageDataStr = inlineData['data'];
                
                if (mimeType != null && mimeType.startsWith('image/') && imageDataStr != null) {
                  print('✅ Found image in response! mimeType: $mimeType');
                  // המודל החזיר תמונה - נשמור אותה ישירות
                  final generatedImageBytes = base64Decode(imageDataStr);
                  final outputFile = File('${imageFile.path}_mockup.png');
                  await outputFile.writeAsBytes(generatedImageBytes);
                  
                  // מחזירים את הנתונים כך שהקוד יודע שזו תמונה
                  return {
                    'imageFile': outputFile,
                    'isImageResponse': true,
                  };
                }
              }
            }
            
            // אם לא מצאנו תמונה, נבדוק אם יש טקסט (שגיאה)
            String? errorText;
            for (var part in parts) {
              if (part['text'] != null) {
                errorText = part['text'];
                break;
              }
            }
            
            throw Exception('No image found in AI response. ${errorText != null ? "Server returned: $errorText" : "Server returned a message instead of an image."}');
          }
          throw Exception('Invalid API response format');
        } else {
          final errorBody = response.body;
          print('❌ API error: ${response.statusCode} - $errorBody');
          throw Exception('API Error ${response.statusCode}: ${errorBody.length > 200 ? errorBody.substring(0, 200) + "..." : errorBody}');
        }
      } catch (e) {
        print('Error calling AI API: $e');
        rethrow;
      }
    }

    Future<void> _createAnnotatedImage() async {
      if (_selectedImage == null || _buttonPosition == null) return;

      final bytes = await _selectedImage!.readAsBytes();
      final originalImage = img.decodeImage(bytes);
      if (originalImage == null) return;

      // יצירת תמונה חדשה עם גובה נוסף אם צריך לדחוף
      final buttonHeight = _buttonHeight ?? 60;
      final pushPixels = _pushRequired == true ? (_pushDownPixels ?? buttonHeight) : 0;
      final newHeight = originalImage.height + pushPixels;
      
      // יצירת תמונה חדשה
      final image = img.Image(width: originalImage.width, height: newHeight);
      img.fill(image, color: img.ColorRgb8(255, 255, 255));
      
      // העתקת התמונה המקורית
      img.compositeImage(image, originalImage, dstX: 0, dstY: 0);

      // אם צריך לדחוף אלמנטים - העתק את התוכן שמתחת למיקום הכפתור
      if (_pushRequired == true && _pushDownFromY != null) {
        final pushFromY = _pushDownFromY!.toInt();
        final contentHeight = originalImage.height - pushFromY;
        
        if (contentHeight > 0 && pushFromY < originalImage.height) {
          // חיתוך התוכן שמתחת למיקום הכפתור
          final contentToMove = img.copyCrop(
            originalImage,
            x: 0,
            y: pushFromY,
            width: originalImage.width,
            height: contentHeight,
          );
          
          // מחיקת התוכן הישן (מציירים רקע לבן)
          img.fillRect(
            image,
            x1: 0,
            y1: pushFromY,
            x2: originalImage.width,
            y2: originalImage.height,
            color: img.ColorRgb8(255, 255, 255),
          );
          
          // הדבקת התוכן במיקום החדש (למטה)
          img.compositeImage(
            image,
            contentToMove,
            dstX: 0,
            dstY: pushFromY + pushPixels,
          );
        }
      }

      // הגדרות עיצוב - ירוק Sportingbet
      final emeraldColor = img.ColorRgb8(16, 185, 129);
      final whiteColor = img.ColorRgb8(255, 255, 255);
      final blackColor = img.ColorRgb8(0, 0, 0);

      // מיקום הכפתור - Y הוא המיקום העליון של הכפתור
      final int buttonTopY = _buttonPosition!.dy.toInt();

      // ציור רקע ירוק לכפתור (full width)
      img.fillRect(
        image,
        x1: 0,
        y1: buttonTopY.clamp(0, image.height),
        x2: image.width,
        y2: (buttonTopY + buttonHeight).clamp(0, image.height),
        color: emeraldColor,
      );

      // הוספת מסגרת לבנה סביב הכפתור
      img.drawRect(
        image,
        x1: 0,
        y1: buttonTopY.clamp(0, image.height),
        x2: image.width,
        y2: (buttonTopY + buttonHeight).clamp(0, image.height),
        color: whiteColor,
        thickness: 3,
      );

      // הוספת קו אנכי במרכז (כדי לסמן שזה כפתור)
      img.drawLine(
        image,
        x1: image.width ~/ 2,
        y1: buttonTopY.clamp(0, image.height),
        x2: image.width ~/ 2,
        y2: (buttonTopY + buttonHeight).clamp(0, image.height),
        color: blackColor,
        thickness: 2,
      );

      // הוספת חץ קטן שמצביע על הכפתור
      final arrowSize = 20;
      final arrowY = buttonTopY - arrowSize - 5;
      if (arrowY > 0) {
        final arrowX = image.width ~/ 2;
        final arrowColor = img.ColorRgb8(255, 255, 0); // צהוב
        
        // ציור חץ למעלה
        img.drawLine(
          image,
          x1: arrowX,
          y1: arrowY,
          x2: arrowX,
          y2: arrowY + arrowSize,
          color: arrowColor,
          thickness: 4,
        );
        img.drawLine(
          image,
          x1: arrowX,
          y1: arrowY,
          x2: arrowX - 10,
          y2: arrowY + 10,
          color: arrowColor,
          thickness: 4,
        );
        img.drawLine(
          image,
          x1: arrowX,
          y1: arrowY,
          x2: arrowX + 10,
          y2: arrowY + 10,
          color: arrowColor,
          thickness: 4,
        );
      }

      final outputFile = File('${_selectedImage!.path}_annotated.png');
      await outputFile.writeAsBytes(img.encodePng(image));

      setState(() {
        _annotatedImage = outputFile;
      });
    }
    // Future<void> _createAnnotatedImage() async {
    //   if (_selectedImage == null || _buttonPosition == null || _imageSize == null) return;
    //
    //   final bytes = await _selectedImage!.readAsBytes();
    //   final image = img.decodeImage(bytes);
    //   if (image == null) return;
    //
    //   // ציור כפתור אמיתי עם טקסט "sportingbet"
    //   final x = _buttonPosition!.dx.toInt();
    //   final y = _buttonPosition!.dy.toInt();
    //   final buttonWidth = 180;
    //   final buttonHeight = 50;
    //
    //   final buttonX = (x - buttonWidth ~/ 2).clamp(0, image.width - buttonWidth);
    //   final buttonY = (y - buttonHeight ~/ 2).clamp(0, image.height - buttonHeight);
    //
    //   // ציור רקע לכפתור (מלבן מעוגל)
    //   final buttonColor = img.ColorRgb8(16, 185, 129); // emeraldColor
    //   final borderColor = img.ColorRgb8(255, 255, 255); // לבן למסגרת
    //
    //   // ציור מסגרת לבנה
    //   img.drawRect(
    //     image,
    //     x1: buttonX - 2,
    //     y1: buttonY - 2,
    //     x2: buttonX + buttonWidth + 2,
    //     y2: buttonY + buttonHeight + 2,
    //     color: borderColor,
    //   );
    //
    //   // ציור רקע הכפתור
    //   img.fillRect(
    //     image,
    //     x1: buttonX,
    //     y1: buttonY,
    //     x2: buttonX + buttonWidth,
    //     y2: buttonY + buttonHeight,
    //     color: buttonColor,
    //   );
    //
    //   // הוספת סימון ברור לכפתור - נצייר מסגרת וסימון
    //   // ציור מסגרת כפולה סביב הכפתור
    //   final borderThickness = 3;
    //   for (int i = 0; i < borderThickness; i++) {
    //     img.drawRect(
    //       image,
    //       x1: buttonX - i,
    //       y1: buttonY - i,
    //       x2: buttonX + buttonWidth + i,
    //       y2: buttonY + buttonHeight + i,
    //       color: img.ColorRgb8(255, 255, 0), // צהוב בוהק
    //     );
    //   }
    //
    //   // ציור קו אנכי במרכז (כדי לסמן שזה כפתור)
    //   img.drawLine(
    //     image,
    //     x1: buttonX + buttonWidth ~/ 2,
    //     y1: buttonY + 5,
    //     x2: buttonX + buttonWidth ~/ 2,
    //     y2: buttonY + buttonHeight - 5,
    //     color: img.ColorRgb8(0, 0, 0), // שחור
    //     thickness: 2,
    //   );
    //
    //   // הוספת טקסט "sportingbet" על הכפתור
    //   // נצייר את האותיות בצורה ברורה יותר - נצייר קווים עבים שייצגו את הטקסט
    //   final text = 'sportingbet';
    //   final textColor = img.ColorRgb8(0, 0, 0); // שחור
    //   final textSize = 16;
    //   final textX = buttonX + (buttonWidth - text.length * 9) ~/ 2;
    //   final textY = buttonY + (buttonHeight + textSize) ~/ 2;
    //
    //   // ציור טקסט בצורה ברורה - נצייר קווים עבים שייצגו את האותיות
    //   // נצייר קו עב עבור כל אות (כדי שיהיה ברור שזה טקסט)
    //   for (int i = 0; i < text.length; i++) {
    //     final charX = textX + i * 9;
    //     // ציור קו עב עבור כל אות (כדי שיהיה ברור שזה טקסט)
    //     img.drawLine(
    //       image,
    //       x1: charX,
    //       y1: textY - 8,
    //       x2: charX + 7,
    //       y2: textY - 8,
    //       color: textColor,
    //       thickness: 3,
    //     );
    //     img.drawLine(
    //       image,
    //       x1: charX,
    //       y1: textY,
    //       x2: charX + 7,
    //       y2: textY,
    //       color: textColor,
    //       thickness: 3,
    //     );
    //     img.drawLine(
    //       image,
    //       x1: charX,
    //       y1: textY + 8,
    //       x2: charX + 7,
    //       y2: textY + 8,
    //       color: textColor,
    //       thickness: 3,
    //     );
    //   }
    //
    //   // הוספת חץ קטן שמצביע על הכפתור
    //   final arrowSize = 25;
    //   final arrowX = buttonX + buttonWidth ~/ 2;
    //   final arrowY = buttonY - arrowSize - 8;
    //
    //   if (arrowY > 0) {
    //     // ציור חץ למעלה (צהוב)
    //     img.drawLine(
    //       image,
    //       x1: arrowX,
    //       y1: arrowY,
    //       x2: arrowX,
    //       y2: arrowY + arrowSize,
    //       color: img.ColorRgb8(255, 255, 0), // צהוב
    //       thickness: 4,
    //     );
    //     img.drawLine(
    //       image,
    //       x1: arrowX,
    //       y1: arrowY,
    //       x2: arrowX - 10,
    //       y2: arrowY + 10,
    //       color: img.ColorRgb8(255, 255, 0),
    //       thickness: 4,
    //     );
    //     img.drawLine(
    //       image,
    //       x1: arrowX,
    //       y1: arrowY,
    //       x2: arrowX + 10,
    //       y2: arrowY + 10,
    //       color: img.ColorRgb8(255, 255, 0),
    //       thickness: 4,
    //     );
    //   }
    //
    //   // הוספת סימון לאלמנטים שצריך להזיז (אם יש)
    //   if (_elementsToMove != null && _elementsToMove!.isNotEmpty) {
    //     for (final element in _elementsToMove!) {
    //       final direction = element['direction'] as String? ?? 'down';
    //       final pixels = (element['pixels'] as num?)?.toInt() ?? 0;
    //       final description = element['description'] as String? ?? 'element';
    //
    //       // נצייר חץ שמצביע על הכיוון שצריך להזיז
    //       // זה רק הסבר ויזואלי - הזזת אלמנטים בפועל דורשת AI חזק יותר
    //       final indicatorY = buttonY - 50;
    //       if (indicatorY > 0) {
    //         // ציור חץ שמצביע על הכיוון
    //         final arrowColor = img.ColorRgb8(255, 165, 0); // כתום
    //         if (direction == 'down') {
    //           // חץ למטה
    //           img.drawLine(
    //             image,
    //             x1: buttonX - 30,
    //             y1: indicatorY,
    //             x2: buttonX - 30,
    //             y2: indicatorY + 20,
    //             color: arrowColor,
    //             thickness: 3,
    //           );
    //           img.drawLine(
    //             image,
    //             x1: buttonX - 30,
    //             y1: indicatorY + 20,
    //             x2: buttonX - 40,
    //             y2: indicatorY + 10,
    //             color: arrowColor,
    //             thickness: 3,
    //           );
    //           img.drawLine(
    //             image,
    //             x1: buttonX - 30,
    //             y1: indicatorY + 20,
    //             x2: buttonX - 20,
    //             y2: indicatorY + 10,
    //             color: arrowColor,
    //             thickness: 3,
    //           );
    //         }
    //       }
    //     }
    //   }
    //
    //   // שמירת התמונה
    //   final outputFile = File('${_selectedImage!.path}_annotated.png');
    //   await outputFile.writeAsBytes(img.encodePng(image));
    //
    //   setState(() {
    //     _annotatedImage = outputFile;
    //   });
    // }

    @override
    Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
        child: Column(
          children: [
            const Text(
              'AI BUTTON PLACEMENT',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 20),
            const Text(
              'Upload your app screenshot and let AI suggest the best location for a "sportingbet" button',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white54, height: 1.5),
            ),
            const SizedBox(height: 40),
            
            // כפתור להעלאת תמונה
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Screenshot'),
              style: ElevatedButton.styleFrom(
                backgroundColor: emeraldColor,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            
            if (_selectedImage != null) ...[
              const SizedBox(height: 30),
              // תצוגת התמונה המקורית
              Container(
                constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(_selectedImage!),
                ),
              ),
              const SizedBox(height: 20),
              
              // כפתור לניתוח
              ElevatedButton(
                onPressed: _isAnalyzing ? null : _analyzeImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: _isAnalyzing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                      )
                    : const Text('Analyze with AI', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
            
            if (_annotatedImage != null) ...[
              const SizedBox(height: 30),
              const Text(
                'Suggested Location:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: emeraldColor),
              ),
              if (_buttonLocation != null) ...[
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    _buttonLocation!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ),
              ],
              if (_elementsToMove != null && _elementsToMove!.isNotEmpty) ...[
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.orange, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Elements to Move:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
                      ),
                      const SizedBox(height: 10),
                      ..._elementsToMove!.map((element) {
                        final direction = element['direction'] ?? 'down';
                        final pixels = element['pixels'] ?? 0;
                        final description = element['description'] ?? 'element';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            '• $description: Move $direction by ${pixels}px',
                            style: const TextStyle(fontSize: 14, color: Colors.white70),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
              // תצוגת התמונה המסומנת
              Container(
                constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: emeraldColor, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(_annotatedImage!),
                ),
              ),
            ],
          ],
        ),
      );
    }
  }