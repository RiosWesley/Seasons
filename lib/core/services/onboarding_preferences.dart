import 'package:shared_preferences/shared_preferences.dart';

/// Service managing onboarding first-run persistence and replay flags.
class OnboardingPreferences {
  OnboardingPreferences._();

  static const String keyHasSeenOnboarding = 'hasSeenOnboarding';

  /// Returns true if the user has completed or skipped the onboarding flow.
  static Future<bool> hasSeenOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(keyHasSeenOnboarding) ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Persists the onboarding completion status.
  static Future<void> setHasSeenOnboarding([bool value = true]) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(keyHasSeenOnboarding, value);
    } catch (_) {
      // Graceful degradation for headless test environments
    }
  }

  /// Resets the onboarding status to false (useful for debug or automated testing).
  static Future<void> resetOnboarding() async {
    await setHasSeenOnboarding(false);
  }
}
