import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bookmaker.dart';

class BookmakerService {
  static const String _key = 'bookmakers';
  static SharedPreferences? _prefs;

  static Future<void> _init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // קבלת כל ה-bookmakers
  static Future<List<Bookmaker>> getAllBookmakers() async {
    await _init();
    final String? bookmakersJson = _prefs!.getString(_key);
    if (bookmakersJson == null || bookmakersJson.isEmpty) {
      return [];
    }
    try {
      final List<dynamic> jsonList = jsonDecode(bookmakersJson);
      return jsonList.map((json) => Bookmaker.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error loading bookmakers: $e');
      return [];
    }
  }

  // שמירת bookmaker
  static Future<bool> saveBookmaker(Bookmaker bookmaker) async {
    await _init();
    final List<Bookmaker> bookmakers = await getAllBookmakers();
    
    // בדיקה אם כבר קיים bookmaker עם אותו ID
    final existingIndex = bookmakers.indexWhere((b) => b.id == bookmaker.id);
    if (existingIndex >= 0) {
      bookmakers[existingIndex] = bookmaker.copyWith(updatedAt: DateTime.now());
    } else {
      bookmakers.add(bookmaker);
    }

    return await _saveAll(bookmakers);
  }

  // מחיקת bookmaker
  static Future<bool> deleteBookmaker(String id) async {
    await _init();
    final List<Bookmaker> bookmakers = await getAllBookmakers();
    bookmakers.removeWhere((b) => b.id == id);
    return await _saveAll(bookmakers);
  }

  // קבלת bookmaker לפי ID
  static Future<Bookmaker?> getBookmakerById(String id) async {
    final List<Bookmaker> bookmakers = await getAllBookmakers();
    try {
      return bookmakers.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  // שמירת כל ה-bookmakers
  static Future<bool> _saveAll(List<Bookmaker> bookmakers) async {
    await _init();
    final List<Map<String, dynamic>> jsonList = bookmakers.map((b) => b.toJson()).toList();
    final String bookmakersJson = jsonEncode(jsonList);
    return await _prefs!.setString(_key, bookmakersJson);
  }

  // יצירת ID ייחודי
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
