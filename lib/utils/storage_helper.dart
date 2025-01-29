import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static const String skincareKey = 'skincareRoutine';

  // Save skincare routine completion status
  static Future<void> saveRoutine(List<bool> completedSteps) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> completedStringList = completedSteps.map((e) => e.toString()).toList();
    await prefs.setStringList(skincareKey, completedStringList);
  }

  // Load skincare routine completion status
  static Future<List<bool>> loadRoutine(int length) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedSteps = prefs.getStringList(skincareKey);

    if (savedSteps != null) {
      return savedSteps.map((e) => e == 'true').toList();
    }
    return List.generate(length, (index) => false); // Default: all steps incomplete
  }

  static Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('streakDays') ?? 0;
  }

  static Future<void> increaseStreak() async {
    final prefs = await SharedPreferences.getInstance();
    int currentStreak = await getStreak();
    await prefs.setInt('streakDays', currentStreak + 1);
  }

  static Future<void> resetStreak() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('streakDays', 0);
  }
}
