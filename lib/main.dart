import 'package:flutter/material.dart';

import 'core/services/onboarding_preferences.dart';
import 'core/services/share_intent_service.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'theme/swiss_theme.dart';

/// Global navigation key enabling programmatic routing from external triggers (e.g. Share Intents).
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final hasSeenOnboarding = await OnboardingPreferences.hasSeenOnboarding();
  runApp(MyApp(initialHasSeenOnboarding: hasSeenOnboarding));
}

/// Root application widget configuring Swiss-Minimalist adaptive light/dark themes,
/// mounting [HomeScreen] or [OnboardingScreen], and registering [ShareIntentService]
/// to listen for incoming WhatsApp chat export files.
class MyApp extends StatefulWidget {
  final ShareIntentService? shareIntentService;
  final GlobalKey<NavigatorState>? navigatorKey;
  final bool? initialHasSeenOnboarding;

  const MyApp({
    super.key,
    this.shareIntentService,
    this.navigatorKey,
    this.initialHasSeenOnboarding,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GlobalKey<NavigatorState> _navKey;
  late final ShareIntentService _shareService;
  late final bool _hasSeenOnboarding;

  @override
  void initState() {
    super.initState();
    _navKey = widget.navigatorKey ?? rootNavigatorKey;
    _shareService = widget.shareIntentService ??
        ShareIntentService(
          navigatorKey: _navKey,
        );
    _shareService.initialize();
    _hasSeenOnboarding = widget.initialHasSeenOnboarding ?? false;
  }

  @override
  void dispose() {
    _shareService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navKey,
      title: 'seasons',
      debugShowCheckedModeBanner: false,
      theme: SwissTheme.lightTheme,
      darkTheme: SwissTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: _hasSeenOnboarding
          ? const HomeScreen()
          : const OnboardingScreen(),
    );
  }
}
