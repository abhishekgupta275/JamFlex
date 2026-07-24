import 'package:flutter/material.dart';
import 'theme/appt_theme.dart';
import 'settings_controller.dart';
import 'onboarding_screen.dart';
import 'settings_screen.dart';
import 'screens/home_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/sos_screen.dart';
import 'screens/peers_screen.dart';

void main() => runApp(const JamFlexApp());

class JamFlexApp extends StateLessWidget {
    const JamFlexApp({super.key});

    @override
    State<JamFlexApp> createState() => _JamFlexAppState();
}

class _JamFlexAppState extends State<JamFlexApp> {
  final SettingsController _settingsController = SettingsController();
  bool _onboarding = false;

  @override
  void dispose(){
    _settings.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context){
  return SettingsScope(
    controller: _settings,
    child: AnimatedBuilder(
      animation: _settings,
      builder: (context, _) {
        return MaterialApp(
          title: 'JamFlex',
          debugShowCheckedModeBanner: false,
          theme: _settings.highContrast ? AppTheme.highContrast : AppTheme.dark,
          builder: (context, child) {
            //Global text scaling driven by the accessibility settings
            // (settingscontroller.settings.textScaleFactor already clamps 0.85-1.4).
            final mq = MediaQuery.of(context);
            return MediaQuery(
              data: mq.copyWith(textScaler: TextScaler.linear(_settings.textScaleFactor)),
              child: child!,
            );
          }
          home: _onboarded
              ? const RootShell()
              : OnboardingScreen(onDone: () => setState(() => _onboarded = true)),
        );   
      },
    ),
 );
}
}

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _Index = 0;

  static const _screens = [
    HomeScreen(),
    MessagesScreen(),
    PeersScreen(),
    SosScreen(),
  ];

  static const _titles = [
    'Home',
    'Messages',
    'Peers',
    'SOS',
  ];

  @override
  Widget build(BuildContext context){
    final settings = SettingsScope.of(context);

    return Scafflod(
      body: SafeArea(
        child: AnimatedSwitcher(
        duration: settings.reduceMotion ? Duration.zero : const Duration(milliseconds: 220),
        switchInCurve: Curves.easeOut,  
        transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
        child: KeyedSubtree(
          key: ValueKey(_index),
          child: _screens[_index],
        ),
      ),
    ),
    floatingActionButton: _index == 0
    ? FloatingActionButton.small(
      heroTag: 'settings',
      backgroundColor: Theme.of(context).colorScheme.surface,
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>  const SettingsScreen()),
        ),
      child: const Icon(Icons.accessibility_new, size: 18),
    )
    : null,
    bottomNavigationBar: NavigationBar(
      selectedIndex: _index,
      onDestinationSelected: (i) => setState(() => _index = i),
      destinations: List.generate(_titles.length, (i) {
        const icons = [Icons.hub_outlined, Icons.chat_bubble_outline, Icons.warning_amber_outlined, Icons.people_outline];
        return NavigationDestination(
          icon: Semantics(lable: .${_titles[i]} tab, child: Icon(icons[i])),
          selectedIcon: Icon(selectedIcons[i]),
          lable: _titles[i],
        );
      }), 
    ),
  );
}
}