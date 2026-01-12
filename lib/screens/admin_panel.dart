import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../models/bookmaker.dart';
import '../services/bookmaker_service.dart';
import '../services/branding_extractor_service.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  List<Bookmaker> _bookmakers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmakers();
  }

  Future<void> _loadBookmakers() async {
    setState(() => _isLoading = true);
    final bookmakers = await BookmakerService.getAllBookmakers();
    setState(() {
      _bookmakers = bookmakers;
      _isLoading = false;
    });
  }

  Future<void> _showAddEditDialog({Bookmaker? bookmaker}) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: bookmaker?.name ?? '');
    final urlController = TextEditingController(text: bookmaker?.url ?? '');
    final primaryColorController = TextEditingController(text: bookmaker?.primaryColor ?? '#003366');
    final secondaryColorController = TextEditingController(text: bookmaker?.secondaryColor ?? '#10B981');
    final logoUrlController = TextEditingController(text: bookmaker?.logoUrl ?? '');
    bool isExtracting = false;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          // קריאת logoPath מה-logoUrlController (בכל פעם מחדש)
          String? currentLogoPath;
          File? currentLogoFile;
          
          if (logoUrlController.text.startsWith('file://')) {
            currentLogoPath = logoUrlController.text.replaceFirst('file://', '');
            try {
              final file = File(currentLogoPath!);
              if (file.existsSync()) {
                currentLogoFile = file;
              }
            } catch (e) {
              // File doesn't exist or invalid path
            }
          } else if (logoUrlController.text.isNotEmpty && !logoUrlController.text.startsWith('http')) {
            currentLogoPath = logoUrlController.text;
            try {
              final file = File(currentLogoPath!);
              if (file.existsSync()) {
                currentLogoFile = file;
              }
            } catch (e) {
              // File doesn't exist or invalid path
            }
          }
          
          return AlertDialog(
            title: Text(bookmaker == null ? 'הוסף Bookmaker' : 'ערוך Bookmaker'),
            content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'שם'),
                    validator: (value) => value?.isEmpty ?? true ? 'חובה למלא שם' : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: urlController,
                          decoration: const InputDecoration(labelText: 'URL'),
                          validator: (value) => value?.isEmpty ?? true ? 'חובה למלא URL' : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: isExtracting
                            ? null
                            : () async {
                                // בדיקה שה-URL לא ריק
                                final urlText = urlController.text.trim();
                                if (urlText.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('⚠️ יש להזין URL תחילה'),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                  return;
                                }

                                // וידוא שה-URL מתחיל עם http:// או https://
                                String finalUrl = urlText;
                                if (!urlText.startsWith('http://') && !urlText.startsWith('https://')) {
                                  finalUrl = 'https://$urlText';
                                  urlController.text = finalUrl;
                                }

                                setDialogState(() => isExtracting = true);
                                print('Starting branding extraction for: $finalUrl');
                                
                                try {
                                  final branding = await BrandingExtractorService.extractBrandingFromUrl(finalUrl);
                                  print('Branding result: $branding');
                                  
                                  if (branding != null) {
                                    nameController.text = branding['name'] ?? '';
                                    primaryColorController.text = branding['primaryColor'] ?? '#003366';
                                    secondaryColorController.text = branding['secondaryColor'] ?? '#10B981';
                                    logoUrlController.text = branding['logoUrl'] ?? '';
                                    setDialogState(() {});
                                    
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('✅ המיתוג נחלץ בהצלחה!'),
                                          backgroundColor: Colors.green,
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                    }
                                  } else {
                                    throw Exception('Failed to extract branding - no data returned');
                                  }
                                } catch (e) {
                                  print('Error in branding extraction: $e');
                                  if (context.mounted) {
                                    final errorMessage = e.toString().contains('Gemini API error')
                                        ? 'שגיאת API - בדוק את החיבור לאינטרנט'
                                        : 'שגיאה בחילוץ מיתוג: ${e.toString().length > 50 ? e.toString().substring(0, 50) + "..." : e.toString()}';
                                    
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('❌ $errorMessage'),
                                        backgroundColor: Colors.red,
                                        duration: const Duration(seconds: 5),
                                      ),
                                    );
                                  }
                                } finally {
                                  setDialogState(() => isExtracting = false);
                                }
                              },
                        icon: isExtracting
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Icons.auto_fix_high, size: 18),
                        label: Text(isExtracting ? 'מעבד...' : 'חלץ מיתוג'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                TextFormField(
                  controller: primaryColorController,
                  decoration: const InputDecoration(
                    labelText: 'צבע ראשי (Hex)',
                    hintText: '#003366',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'חובה למלא צבע ראשי';
                    if (!RegExp(r'^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$').hasMatch(value!)) {
                      return 'פורמט לא תקין (לדוגמה: #003366)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: secondaryColorController,
                  decoration: const InputDecoration(
                    labelText: 'צבע משני (Hex)',
                    hintText: '#10B981',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'חובה למלא צבע משני';
                    if (!RegExp(r'^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$').hasMatch(value!)) {
                      return 'פורמט לא תקין (לדוגמה: #10B981)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'לוגו:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: logoUrlController,
                        decoration: const InputDecoration(
                          labelText: 'URL לוגו (אופציונלי)',
                          hintText: 'https://example.com/logo.png',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          try {
                            // שמירת הלוגו בתיקייה מקומית
                            final directory = await getApplicationDocumentsDirectory();
                            final logoDir = Directory('${directory.path}/bookmaker_logos');
                            if (!await logoDir.exists()) {
                              await logoDir.create(recursive: true);
                            }
                            
                            // יצירת שם קובץ ייחודי
                            final bookmakerId = bookmaker?.id ?? BookmakerService.generateId();
                            final logoFileName = 'logo_$bookmakerId.png';
                            final savedLogoFile = File('${logoDir.path}/$logoFileName');
                            
                            // העתקת הקובץ
                            final pickedFile = File(image.path);
                            await pickedFile.copy(savedLogoFile.path);
                            
                            setDialogState(() {
                              logoUrlController.text = 'file://${savedLogoFile.path}';
                            });
                            
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('✅ לוגו הועלה בהצלחה'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('❌ שגיאה בהעלאת לוגו: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        }
                      },
                      icon: const Icon(Icons.image, size: 18),
                      label: const Text('העלה לוגו'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
                ),
                // תצוגת הלוגו שנבחר
                if (currentLogoFile != null || (logoUrlController.text.isNotEmpty && logoUrlController.text.startsWith('http')))
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: currentLogoFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(currentLogoFile, fit: BoxFit.contain),
                            )
                          : logoUrlController.text.isNotEmpty && logoUrlController.text.startsWith('http')
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    logoUrlController.text,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) => const Center(
                                      child: Icon(Icons.error, color: Colors.red),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
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
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final bookmakerToSave = bookmaker?.copyWith(
                  name: nameController.text,
                  url: urlController.text,
                  primaryColor: primaryColorController.text,
                  secondaryColor: secondaryColorController.text,
                  logoUrl: logoUrlController.text.isEmpty ? null : logoUrlController.text,
                  updatedAt: DateTime.now(),
                ) ?? Bookmaker(
                  id: BookmakerService.generateId(),
                  name: nameController.text,
                  url: urlController.text,
                  primaryColor: primaryColorController.text,
                  secondaryColor: secondaryColorController.text,
                  logoUrl: logoUrlController.text.isEmpty ? null : logoUrlController.text,
                  createdAt: DateTime.now(),
                );

                await BookmakerService.saveBookmaker(bookmakerToSave);
                Navigator.pop(context);
                _loadBookmakers();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${bookmaker == null ? "נוסף" : "עודכן"} בהצלחה')),
                );
              }
            },
            child: const Text('שמור'),
          ),
        ],
          );
        },
      ),
    );
  }

  Future<void> _deleteBookmaker(Bookmaker bookmaker) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('מחיקת Bookmaker'),
        content: Text('האם אתה בטוח שברצונך למחוק את ${bookmaker.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('ביטול'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('מחק'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await BookmakerService.deleteBookmaker(bookmaker.id);
      _loadBookmakers();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${bookmaker.name} נמחק בהצלחה')),
      );
    }
  }

  Color _hexToColor(String hex) {
    final hexCode = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ניהול Bookmakers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEditDialog(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _bookmakers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.sports_soccer, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text('אין bookmakers', style: TextStyle(fontSize: 18, color: Colors.grey)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _showAddEditDialog(),
                        child: const Text('הוסף Bookmaker ראשון'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _bookmakers.length,
                  itemBuilder: (context, index) {
                    final bookmaker = _bookmakers[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: _hexToColor(bookmaker.primaryColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: bookmaker.logoUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: bookmaker.logoUrl!.startsWith('file://')
                                      ? Image.file(
                                          File(bookmaker.logoUrl!.replaceFirst('file://', '')),
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Icon(
                                            Icons.sports_soccer,
                                            color: _hexToColor(bookmaker.secondaryColor),
                                          ),
                                        )
                                      : Image.network(
                                          bookmaker.logoUrl!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Icon(
                                            Icons.sports_soccer,
                                            color: _hexToColor(bookmaker.secondaryColor),
                                          ),
                                        ),
                                )
                              : Icon(
                                  Icons.sports_soccer,
                                  color: _hexToColor(bookmaker.secondaryColor),
                                ),
                        ),
                        title: Text(bookmaker.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(bookmaker.url, style: const TextStyle(fontSize: 12)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: _hexToColor(bookmaker.primaryColor),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.grey),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: _hexToColor(bookmaker.secondaryColor),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showAddEditDialog(bookmaker: bookmaker),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteBookmaker(bookmaker),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
