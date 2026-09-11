import 'package:flutter/material.dart';

import 'core/services/share_intent_service.dart';
import 'screens/home_screen.dart';
import 'theme/swiss_theme.dart';

/// Global navigation key enabling programmatic routing from external triggers (e.g. Share Intents).
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

/// Root application widget configuring Swiss-Minimalist adaptive light/dark themes,
/// mounting [HomeScreen], and registering [ShareIntentService] to listen for incoming
/// WhatsApp chat export files.
class MyApp extends StatefulWidget {
  final ShareIntentService? shareIntentService;
  final GlobalKey<NavigatorState>? navigatorKey;

  const MyApp({
    super.key,
    this.shareIntentService,
    this.navigatorKey,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GlobalKey<NavigatorState> _navKey;
  late final ShareIntentService _shareService;

  @override
  void initState() {
    super.initState();
    _navKey = widget.navigatorKey ?? rootNavigatorKey;
    _shareService = widget.shareIntentService ??
        ShareIntentService(
          navigatorKey: _navKey,
        );
    _shareService.initialize();
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
      title: 'Chat Wrapped',
      debugShowCheckedModeBanner: false,
      theme: SwissTheme.lightTheme,
      darkTheme: SwissTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
