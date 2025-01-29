import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static const String skincareKey = 'skincareRoutine';
  static const String lastCompletedDateKey = 'lastCompletedDate';
  static const String streakKey = 'streakDays';

  // Save skincare routine completion status along with the date
  static Future<void> saveRoutine(List<bool> completedSteps) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> completedStringList = completedSteps.map((e) => e.toString()).toList();
    await prefs.setStringList(skincareKey, completedStringList);

    // Save the current date when the routine is completed
    String currentDate = DateTime.now().toIso8601String().split('T')[0];  // Format as yyyy-MM-dd
    await prefs.setString(lastCompletedDateKey, currentDate);
  }

  // Load skincare routine completion status
  static Future<List<bool>> loadRoutine(int length) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedSteps = prefs.getStringList(skincareKey);
    String? lastCompletedDate = prefs.getString(lastCompletedDateKey);
    String currentDate = DateTime.now().toIso8601String().split('T')[0];  // Format as yyyy-MM-dd

    // If the date has changed (new day), reset the steps
    if (lastCompletedDate != null && lastCompletedDate != currentDate) {
      await resetRoutine();
      return List.generate(length, (index) => false); // Default: all steps incomplete
    }

    if (savedSteps != null) {
      return savedSteps.map((e) => e == 'true').toList();
    }
    return List.generate(length, (index) => false); // Default: all steps incomplete
  }

  // Reset the routine (mark all steps as incomplete)
  static Future<void> resetRoutine() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(skincareKey, List.generate(5, (index) => 'false')); // 5 steps by default
    await prefs.setString(lastCompletedDateKey, DateTime.now().toIso8601String().split('T')[0]);
  }

  // Get current streak
  static Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(streakKey) ?? 0;
  }

  // Increase streak if all steps are completed
  static Future<void> increaseStreak() async {
    final prefs = await SharedPreferences.getInstance();
    int currentStreak = await getStreak();
    await prefs.setInt(streakKey, currentStreak + 1);
  }

  // Reset streak to 0
  static Future<void> resetStreak() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(streakKey, 0);
  }
}
